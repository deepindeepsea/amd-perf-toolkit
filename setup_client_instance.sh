#!/bin/bash
# setup_client_instance.sh - Spin up dedicated wrk client instance
set -e

echo "=== Setting up dedicated wrk client instance $(date) ==="

# Use same key and security group as M8A for simplicity
KEY_NAME="ruby_pradeepn"
SECURITY_GROUP="sg-05c4e2b2c7c6b8d5a"  # Same as M8A
SUBNET="subnet-0c7a7c4d8a5b9e6f2"     # Same as M8A

echo "Launching c7a.8xlarge client instance..."

# Launch client instance
CLIENT_INSTANCE=$(aws ec2 run-instances \
    --image-id ami-0c02fb55956c7d316 \
    --count 1 \
    --instance-type c7a.8xlarge \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP" \
    --subnet-id "$SUBNET" \
    --associate-public-ip-address \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=wrk-client-amd},{Key=Purpose,Value=load-generator}]' \
    --metadata-options HttpTokens=required,HttpPutResponseHopLimit=1,HttpEndpoint=enabled \
    --iam-instance-profile Name=EC2-SSM-Role \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Client instance launched: $CLIENT_INSTANCE"

# Wait for instance to be running
echo "Waiting for instance to be in running state..."
aws ec2 wait instance-running --instance-ids "$CLIENT_INSTANCE"

# Get private IP for later use
CLIENT_IP=$(aws ec2 describe-instances \
    --instance-ids "$CLIENT_INSTANCE" \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text)

echo "Client instance ready:"
echo "  Instance ID: $CLIENT_INSTANCE"
echo "  Private IP: $CLIENT_IP"

# Wait for SSM agent to be ready
echo "Waiting for SSM agent to be ready (60 seconds)..."
sleep 60

# Install wrk and dependencies
echo "Installing wrk and dependencies on client instance..."
timeout 300s aws ssm send-command \
    --instance-ids "$CLIENT_INSTANCE" \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=[
        "apt-get update -y",
        "apt-get install -y build-essential git libssl-dev",
        "cd /home/ubuntu",
        "git clone https://github.com/wg/wrk.git",
        "cd wrk && make -j$(nproc)",
        "ln -sf /home/ubuntu/wrk/wrk /usr/local/bin/wrk",
        "wrk --version",
        "echo \"Client setup complete\""
    ]' \
    --output text

echo "Client instance setup initiated"
echo ""
echo "Next steps:"
echo "1. Test connectivity from client to server"
echo "2. Run split-host benchmark"
echo "3. Scale client load to find server limits"
echo ""
echo "Client instance details:"
echo "  ID: $CLIENT_INSTANCE"
echo "  IP: $CLIENT_IP"
echo "  Server IP: $(aws ec2 describe-instances --instance-ids i-082ca0124af7a18d0 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)"

# Save instance info for later use
cat > client_instance_info.txt << EOF
CLIENT_INSTANCE=$CLIENT_INSTANCE
CLIENT_IP=$CLIENT_IP
SERVER_INSTANCE=i-082ca0124af7a18d0
SERVER_IP=$(aws ec2 describe-instances --instance-ids i-082ca0124af7a18d0 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
EOF

echo "Instance info saved to client_instance_info.txt"
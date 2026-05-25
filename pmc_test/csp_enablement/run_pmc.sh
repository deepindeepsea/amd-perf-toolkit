#!/bin/bash
set -u
BUCKET=amd-pmc-toolkit-pradeepn
SWEEP=${1:-sweep_runner}
WORK=/opt/pmc-toolkit
RESULT=/tmp/pmc-result-$$
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
IID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id || echo unknown)
ITYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type || echo unknown)
[ -z "$IID" ] && IID=unknown
[ -z "$ITYPE" ] && ITYPE=unknown
DATE=$(date -u +%F)
S3KEY="results/aws/$ITYPE/$IID/$DATE/${SWEEP}.txt"
sudo mkdir -p $WORK
if [ ! -x $WORK/mhammer.x86_64 ]; then
  sudo aws s3 cp s3://$BUCKET/artifacts/mhammer.x86_64 $WORK/mhammer.x86_64
  sudo chmod +x $WORK/mhammer.x86_64
fi
if [ ! -f $WORK/$SWEEP.sh ]; then
  sudo aws s3 cp s3://$BUCKET/artifacts/$SWEEP.sh $WORK/$SWEEP.sh
  sudo chmod +x $WORK/$SWEEP.sh
fi
sudo ln -sf $WORK/mhammer.x86_64 /tmp/mhammer
bash $WORK/$SWEEP.sh > $RESULT 2>&1
cat $RESULT
aws s3 cp $RESULT s3://$BUCKET/$S3KEY
echo "uploaded: s3://$BUCKET/$S3KEY"

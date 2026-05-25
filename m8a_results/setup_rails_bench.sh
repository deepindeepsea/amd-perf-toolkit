#!/bin/bash -l
###############################################################################
# Rails Puma Hello World benchmark — one-shot setup script
#
# Idempotent: safe to re-run. Detects existing installs and skips them.
# Tested on:
#   - Ubuntu 24.04 LTS server x86_64 (AMI ami-016d360a89daa11ba in us-west-2)
#   - AWS m8a.metal-24xl, m8a.2xlarge, c8a.2xlarge (EPYC 9R45 Zen5 Turin)
#
# Provisions:
#   - apt build deps (incl. unzip — required for wrk's bundled LuaJIT-2.1)
#   - rbenv + Ruby 3.3.11 (compiled with --enable-shared, openssl, psych)
#   - Bundler 4.0.12, Rails 8.1.3
#   - wrk 4.2.0 (built from wg/wrk upstream — pulls bundled OpenSSL 1.1)
#   - Rails 'bench_app' with HomeController returning "Hello World!" plain text
#   - jemalloc shared lib (libjemalloc2)
#
# Anyone running this on a fresh Ubuntu 24.04 instance should get:
#   ruby: ruby 3.3.11
#   bundle: 4.0.12
#   wrk: wrk 4.2.0 [epoll]
#   bench_app/ ready at ~/bench_app
#
# Usage:
#   curl -fLo setup.sh https://<your-repo>/setup_rails_bench.sh
#   bash setup.sh
# or:
#   tmux new-session -d -s setup 'bash setup.sh; sleep 600'
#
# Log: /tmp/setup_rails_bench.log
###############################################################################

set -euo pipefail
LOG=/tmp/setup_rails_bench.log
exec > >(tee -a "$LOG") 2>&1

RUBY_VERSION=3.3.11
BUNDLER_VERSION=4.0.12
RAILS_VERSION=8.1.3

log()  { echo "[$(date +%H:%M:%S)] $*"; }
fail() { echo "[FATAL] $*" >&2; exit 1; }

log ">>> SETUP START on $(hostname) — $(date)"

# --- preflight: OS check ---
if ! grep -q "Ubuntu 24" /etc/os-release; then
  log "WARN: not Ubuntu 24.04 — proceeding but apt package names may differ"
fi

# --- 1. apt packages (unzip is REQUIRED for wrk LuaJIT) ---
log "Step 1/6: apt install build deps"
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    build-essential libssl-dev libreadline-dev zlib1g-dev \
    libsqlite3-dev libffi-dev libyaml-dev libjemalloc2 \
    git curl autoconf bison unzip ca-certificates

# Verify libjemalloc path (used by bench script via LD_PRELOAD)
JEMALLOC_PATH=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
[ -f "$JEMALLOC_PATH" ] || fail "libjemalloc.so.2 not found at $JEMALLOC_PATH"

# --- 2. rbenv + ruby-build ---
log "Step 2/6: rbenv + ruby-build"
if [ ! -d "$HOME/.rbenv" ]; then
  git clone --depth=1 https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  git clone --depth=1 https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
  # bashrc only if not already there
  grep -q "rbenv/bin" "$HOME/.bashrc" || cat >> "$HOME/.bashrc" <<'EOF'
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(~/.rbenv/bin/rbenv init - bash)"
EOF
else
  log "  rbenv already installed — skipping clone"
fi
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init - bash)"

# --- 3. Ruby compile ---
log "Step 3/6: Ruby $RUBY_VERSION (compile takes ~3 min)"
if rbenv versions --bare | grep -qx "$RUBY_VERSION"; then
  log "  Ruby $RUBY_VERSION already installed — skipping"
else
  rbenv install -s "$RUBY_VERSION"
fi
rbenv global "$RUBY_VERSION"
rbenv rehash
ruby -v | grep -q "$RUBY_VERSION" || fail "Ruby install failed"

# --- 4. Gems ---
log "Step 4/6: bundler + rails gems"
gem list -i bundler -v "$BUNDLER_VERSION" >/dev/null 2>&1 || \
  gem install bundler -v "$BUNDLER_VERSION" --no-document
gem list -i rails -v "$RAILS_VERSION" >/dev/null 2>&1 || \
  gem install rails -v "$RAILS_VERSION" --no-document

# --- 5. wrk (pulls bundled OpenSSL 1.1 — ~3 min compile) ---
log "Step 5/6: wrk (build from source, ~3 min)"
if [ -x "$HOME/wrk/wrk" ]; then
  log "  wrk already built — skipping"
else
  rm -rf "$HOME/wrk"
  git clone --depth=1 https://github.com/wg/wrk.git "$HOME/wrk"
  cd "$HOME/wrk"
  make -j"$(nproc)"
  [ -x ./wrk ] || fail "wrk build failed (check /tmp/setup_rails_bench.log)"
fi

# --- 6. Rails bench_app ---
log "Step 6/6: bench_app (Rails new + minimal controller)"
if [ -d "$HOME/bench_app" ] && [ -f "$HOME/bench_app/config/routes.rb" ]; then
  log "  bench_app already exists — skipping"
else
  cd "$HOME"
  rails new bench_app --skip-test --skip-system-test
  cd "$HOME/bench_app"
  cat > config/routes.rb <<'EOF'
Rails.application.routes.draw do
  get "/", to: "home#index"
end
EOF
  cat > app/controllers/home_controller.rb <<'EOF'
class HomeController < ApplicationController
  def index
    render plain: "Hello World!"
  end
end
EOF
  bundle install
  RAILS_ENV=production bundle exec rails db:prepare
  bundle exec rails assets:precompile RAILS_ENV=production
fi

# --- sanity check ---
log "Sanity: starting Puma for 5s..."
cd "$HOME/bench_app"
export SECRET_KEY_BASE
SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || openssl rand -hex 32)
nohup bundle exec puma -e production -p 3000 -w 1 -t 1 > /tmp/puma_sanity.log 2>&1 &
SANITY_PID=$!
sleep 5
if curl -sf http://127.0.0.1:3000/ | grep -q "Hello World"; then
  log "  SANITY OK — Puma serves 'Hello World!'"
else
  log "  SANITY FAILED — check /tmp/puma_sanity.log"
fi
kill -9 $SANITY_PID 2>/dev/null || true
pkill -9 -f puma 2>/dev/null || true

log ">>> SETUP COMPLETE on $(hostname) — $(date)"
log "  ruby:   $(ruby -v)"
log "  bundle: $(bundle -v)"
log "  wrk:    $($HOME/wrk/wrk --version 2>&1 | head -1)"
log "  app:    $HOME/bench_app"
log ""
log "Next: run bench script — see m8a_results/bench_2xl.sh"

#!/bin/bash
set -euo pipefail

# Clean, idempotent ASG user-data using dnf when available.
# Goals: fewer lines, predictable startup, minimal package work.

LOG=/var/log/user-data.log
exec > >(tee -a "$LOG") 2>&1

echo "user-data start: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"

# Determine hostname for the page
HOSTNAME_FULL=$(hostname -f || hostname)

# Install nginx only if missing. Prefer dnf, fall back to yum if needed.
if ! command -v nginx >/dev/null 2>&1; then
  echo "nginx not found — installing"
  if command -v dnf >/dev/null 2>&1; then
    dnf -y --quiet install nginx --setopt=install_weak_deps=False || true
  elif command -v yum >/dev/null 2>&1; then
    yum -y -q install nginx || true
  else
    echo "No supported package manager found; continuing without nginx"
  fi
else
  echo "nginx present: $(command -v nginx)"
fi

# Ensure web directory and index page exist
mkdir -p /usr/share/nginx/html
cat > /usr/share/nginx/html/index.html <<HTML
Hello, World from ASG, ${HOSTNAME_FULL}
HTML
chown nginx:nginx /usr/share/nginx/html/index.html || true

# Start nginx service
systemctl enable --now nginx || systemctl start nginx || true

echo "user-data completed: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
exit 0
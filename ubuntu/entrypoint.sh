#!/usr/bin/env bash

set -e

user_id=${SERVICE_UID:-$(id -u)}
group_id=${SERVICE_GID:-$(id -g)}

# Create passwd entry for arbitrary user ID
if [[ -z "$(awk -F ':' "\$3 == $user_id" /etc/passwd)" ]]; then
    echo "Adding arbitrary user"
    echo "${USER_NAME:-default}:x:$user_id:$group_id:${USER_NAME:-default} user:/home/qwc:/sbin/nologin" \
        >> /etc/passwd
    echo "$(awk -F ':' "\$3 == $user_id" /etc/passwd)"
fi

echo "Running as $(id -un):$(id -gn)"

# Create home directory
mkdir -p /home/qwc
chown $user_id:$group_id /home/qwc
export HOME=/home/qwc

uwsgi \
  --http-socket :9090 \
  --buffer-size $REQ_HEADER_BUFFER_SIZE \
  --processes $UWSGI_PROCESSES \
  --threads $UWSGI_THREADS \
  --plugins python3 $UWSGI_EXTRA \
  --protocol uwsgi \
  --wsgi-disable-file-wrapper \
  --uid $user_id \
  --gid $group_id \
  --master \
  --chdir /srv/qwc_service \
  --mount $SERVICE_MOUNTPOINT=server:app \
  --manage-script-name

FROM docker.io/rclone/rclone:1

RUN set -eux \
    && apk --no-cache add --virtual build-dependencies unzip supervisor fuse tzdata tree netcat-openbsd curl bash nfs-utils

# setup nfs

# remove the default config files
RUN rm /etc/exports && mkdir -p /mnt/remote

RUN echo "/mnt/remote  *(rw,sync,no_subtree_check,crossmnt,fsid=0)" >> /etc/exports

EXPOSE 2049

# setup rclone

RUN curl https://rclone.org/install.sh | bash || true

RUN mkdir -p /rclone/config /rclone/cache

ENTRYPOINT ["/bin/sh", "-c" , "rc-service nfs start && rclone"]

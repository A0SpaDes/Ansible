#!/usr/bin/env bash
DISK="$1"

echo "wipe signature on ${DISK}"
wipefs --all --force ${DISK}

echo "generate new GPT / MBR on ${DISK}"
sgdisk --zap-all ${DISK}

echo "clear ${DISK} disk"
dd if=/dev/zero of=${DISK} bs=1M count=5000 oflag=direct,dsync

echo "remove /dev/mapper/ceph-* not used links"
ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %
echo "cleanup finish"

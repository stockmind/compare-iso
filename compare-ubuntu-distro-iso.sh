#!/usr/bin/env bash
# Author: Simone Roberto Nunzi aka stockmind

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

ISO1=$1
ISO2=$2

mkdir -p iso1
mkdir -p iso2
mkdir -p filesystem1
mkdir -p filesystem2

echo "Trying to mount $ISO1 ..."
mount "$ISO1" ./iso1
echo "Trying to mount $ISO2 ..."
mount "$ISO2" ./iso2

mount ./iso1/casper/filesystem.squashfs ./filesystem1
mount ./iso2/casper/filesystem.squashfs ./filesystem2

rsync --recursive --delete --links --checksum --verbose --dry-run ./iso1/ ./iso2/ > isodiff.txt
rsync --recursive --delete --links --checksum --verbose --dry-run ./filesystem1/ ./filesystem2/ > filesystemdiff.txt

umount ./iso1
umount ./iso2
umount ./filesystem1
umount ./filesystem2

rm -dfr iso1
rm -dfr iso2
rm -dfr filesystem1
rm -dfr filesystem2
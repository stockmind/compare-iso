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

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    echo "Trying to mount $ISO1 ..."
    mount "$ISO1" ./iso1
    echo "Trying to mount $ISO2 ..."
    mount "$ISO2" ./iso2
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    echo "Trying to mount $ISO1 ..."
    hdiutil attach -mountpoint ./iso1 "$ISO1"
    echo "Trying to mount $ISO2 ..."
	hdiutil attach -mountpoint ./iso2 "$ISO2"
else
    # System Unknown.
    echo "System unknown! Will try a standard mount."
    echo "Trying to mount $ISO1 ..."
    mount "$ISO1" ./iso1
    echo "Trying to mount $ISO2 ..."
    mount "$ISO2" ./iso2
fi

rsync --recursive --delete --links --checksum --verbose --dry-run ./iso1/ ./iso2/ > isodiff.txt

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    umount ./iso1
    umount ./iso2
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    hdiutil detach ./iso1
	hdiutil detach ./iso2
else
    # System Unknown.
    echo "System unknown! Will try a standard mount."
    umount ./iso1
    umount ./iso2
fi
#!/usr/bin/env bash
# Author: Simone Roberto Nunzi aka stockmind

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

EXTRACT=false
FIRST=false

# Check arguments
for i in "$@" ; do
    if [[ $i == "extract" ]] ; then
        echo "Extract different files from second iso"
        EXTRACT=true
        continue
    fi
    if [[ $i == "first" ]] ; then
        echo "Force extract from first iso, use with extract argument"
        FIRST=true
        continue
    fi
done

ISO1=$1
ISO2=$2

# Init environment
mkdir -p iso1
mkdir -p iso2
mkdir -p filesystem1
mkdir -p filesystem2

# Mount base iso
echo "Trying to mount $ISO1 ..."
mount "$ISO1" ./iso1
echo "Trying to mount $ISO2 ..."
mount "$ISO2" ./iso2

# Mount internal filesystem layer
mount ./iso1/casper/filesystem.squashfs ./filesystem1
mount ./iso2/casper/filesystem.squashfs ./filesystem2

# Look for differences
rsync --recursive --delete --links --checksum --verbose --dry-run ./iso1/ ./iso2/ > isodiff.txt
rsync --recursive --delete --links --checksum --verbose --dry-run ./filesystem1/ ./filesystem2/ > filesystemdiff.txt

# Remove unnecessary output or obvious differences like kernel files from output
sed -i '/skipping non-regular file/d' filesystemdiff.txt
sed -i '/sending incremental file list/d' filesystemdiff.txt
sed -i '/lib\/modules\/[0-9]*.[0-9]*.[0-9]*-[^/]*\/*/d' filesystemdiff.txt
sed -i '/sent [,.0-9]* bytes/d' filesystemdiff.txt
sed -i '/total size/d' filesystemdiff.txt

if [[ "$EXTRACT" = true ]]; then
    FILE="filesystemdiff.txt"
    DESTINATIONFOLDER="extracted"
    SOURCEFOLDER="filesystem2"
    
    # Clean previous run
    rm -frd "$DESTINATIONFOLDER"
    mkdir -p "$DESTINATIONFOLDER"
    
    if [[ "$FIRST" = true ]]; then
        SOURCEFOLDER="filesystem1"
    fi
    
    # Read files one by one and copy them on destination folder
    while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "Extract file: $line"
	# Copy file only if exist on ISO selected
	if [[ -f "$SOURCEFOLDER"/"$line" ]]; then
        	cp --parents "$SOURCEFOLDER"/"$line" "$DESTINATIONFOLDER"
	else
		echo "File non present on selected ISO. Must be on the other ISO."
	fi
    done < "$FILE"

fi

# Unmount everything and delete temp directories
umount ./filesystem1
umount ./filesystem2
umount ./iso1
umount ./iso2

rm -dfr filesystem1
rm -dfr filesystem2
rm -dfr iso1
rm -dfr iso2

# Compare ISO

Scripts for macOS (OSX) and Linux to mount and compare two ISOs.

## macOS

Install dependencies with brew

	brew tap homebrew/dupes
	brew install rsync
    brew install squashfs

## Linux

### Debian, Ubuntu, and derivates... :

    sudo apt -y install squashfs-tools rsync

### Arch :

	sudo pacman -Sy squashfs-tools rsync

# How to use

Execute script as root and pass ISO filenames as arguments

    ./compare-iso.sh <iso1> <iso2>

A "isodiff.txt" file containing the diffs will be generated on current directory.
Mount of hybrid image on macOs is not yet supported.
"compare-ubuntu-distro-iso.sh" works only on Linux system for this reason.

If you want to compare two different Ubuntu distributions iso run this:

    ./compare-ubuntu-distro-iso.sh


A "isodiff.txt" file containing the base image diffs will be generated on current directory.
A "filesystemdiff.txt" file containing the diffs of underlying filesystem of images will be generated on current directory.

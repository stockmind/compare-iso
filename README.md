# Compare ISO

Scripts for Linux to mount and compare two ISOs. 
Initial support for macOS, but doesn't likely will have a bright future.

# Dependencies

## Linux

### Debian, Ubuntu, and derivates... :

    sudo apt -y install squashfs-tools rsync

### Arch :

    sudo pacman -Sy squashfs-tools rsync
	
## macOS 

Install dependencies with brew

    brew tap homebrew/dupes
    brew install rsync
    brew install squashfs

# How to use

Execute script as root and pass ISO filenames as arguments

    ./compare-iso.sh <iso1> <iso2>

A "isodiff.txt" file containing the diffs will be generated on current directory.
Mount of hybrid image on macOs is not yet supported.
The following script "compare-ubuntu-distro-iso.sh" works only on Linux system for this reason.

If you want to compare two different Ubuntu distributions iso run this:

    ./compare-ubuntu-distro-iso.sh <iso1> <iso2> [extract [first]]

A "isodiff.txt" file containing the base image diffs will be generated on current directory.
A "filesystemdiff.txt" file containing the diffs of underlying filesystem of images will be generated on current directory.

Arguments:

	extract - Optional argument, will extract found files from <iso2> in a folder named "extracted"
	first - Optional argument, must be used with "extract" argument. Force <iso1> as source for extract action.

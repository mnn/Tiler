#!/bin/bash

#--------------------------------.
#                                 \
#    Tiler script by *monnef*      )
#                                 /
#--------------------------------´

function usage {
	echo "Usage: $0 <width> <height> [--fadeout|-f] -- <files>"
	echo "e.g. $0 160 160 -f -- file1.png file2.png"
	echo -e "\t[fadeout]\tcreate fade-out border"
}

function help {
	echo
	echo "Tiler script created by monnef (http://monnef.tk)"
	echo
}

function ensureNumber {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
   		echo "'$1' is not a number" >&2
   		exit 1
	fi
}

myDir=$(readlink -f $(dirname "$0"))

if [ "$#" -eq 1 -a \( "$1" == "--help" -o "$1" == "-h" \) ]; then
	help
	usage
	exit 0
fi

if [ "$#" -lt "3" ]; then
	echo "At least three arguments are required"
	usage
	exit 1
fi

ensureNumber "$1"
ensureNumber "$2"
width="$1"
height="$2"
shift
shift

fadeout=false
while [ $# -lt 1 -o $1 != "--" ]; do
	case "$1" in
		"--fadeout"|"-f") fadeout=true ;;
		*) echo "Unknown argument: '$1'"; exit 2; ;;
	esac
	shift
done
shift # getting after --

if [ $# -lt 1 ]; then
	echo "No files specified."
	exit 3
fi

echo "Options: size=$size, fadeout=$fadeout"
echo "Files: $@"

outDir="out"
foutDir="$outDir/fadeout"

mkdir -p "$outDir"
mkdir -p "$foutDir"

genericMaskFile="$foutDir/mask.png"
if [ "$fadeout" == "true" ]; then
	"$myDir"/maskCreator.sh "$width" "$height" "$genericMaskFile"
fi

for i in "$@"; do
	if [ -f "$i" ]; then
		outFile="$outDir"/"$i"
		convert -background none -size "${width}x${height}" tile:$i "$outFile"
		if [ "$fadeout" == "true" ]; then
			maskFile="$outDir/mask_current.png"
			convert "$outFile" -set colorspace RGB -alpha Extract "$maskFile"

			maskCompositeFile="$outDir/mask_composite.png"
			convert "$genericMaskFile" "$maskFile" -compose Multiply -set colorspace Gray -alpha Remove -composite png8:"$maskCompositeFile"

			foutFile="$foutDir"/"$i"
			convert "$outFile" "$maskCompositeFile" -alpha Off -compose CopyOpacity -composite "$foutFile"
		fi
	else
		echo "File '$i' not found."
	fi
done

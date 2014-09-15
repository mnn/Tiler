#!/bin/bash

function usage {
	echo "Usage: $0 <width> <height> <filename>"
	echo "e.g. $0 160 160 file1.png"
}

function help {
	echo
	echo "Mask creator script created by monnef (http://monnef.tk)"
	echo
}

function ensureNumber {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
   		echo "'$1' is not a number" >&2
   		exit 1
	fi
}

if [ "$#" -eq 1 -a \( "$1" == "--help" -o "$1" == "-h" \) ]; then
	help
	usage
	exit 0
fi

if [ "$#" -ne "3" ]; then
	echo "Exactly three arguments are expected."
	usage
	exit 1
fi
ensureNumber "$1"
ensureNumber "$2"

w=$1
h=$2
fname=$3

minSize=$w
maxSize=$h
if (( w>h )); then
	minSize=$h
	maxSize=$w
fi

cornerRadius=$[minSize/10]

blurSize=$[minSize/20]
space=$[3*blurSize]

x1=$[space]
y1=$[space]
x2=$[w-space]
y2=$[h-space]

rx=$cornerRadius
ry=$cornerRadius


args="-blur 0x$blurSize"

#echo "Configuration: w=$w h=$h cornerRadius=$cornerRadius blurSize=$blurSize space=$space"

convert -size ${w}x${h} xc:black -fill white -stroke black -draw "roundrectangle $x1,$y1 $x2,$y2 $rx,$ry" $args $fname

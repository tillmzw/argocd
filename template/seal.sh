#!/bin/bash

declare -r INPUT=$1
declare -r OUTPUT="${INPUT%.*}-sealed.${INPUT##*.}"

if [ ! -f $INPUT ]; then
	echo "Not a file: $INPUT"
	exit 1
else
	echo "$INPUT --> $OUTPUT"
fi

kubeseal --controller-name sealed-secrets --format yaml < $INPUT > $OUTPUT 

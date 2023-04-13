#!/bin/bash

newfile=$2
oldfile=$1
newlines=./newlines.txt

if [ -f $newfile ] && [ -f $oldfile ]
	then
		#while IFS= read -r line
		while read line
		do
			if ! grep "$line" $oldfile; then
				echo "$line" >> $newlines
			fi
		done < <(grep . "$newfile")
	fi

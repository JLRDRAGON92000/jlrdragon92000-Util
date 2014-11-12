#!/bin/bash

# Get first argument
# If it is nil, use * (Everything)
CFIL="$1";
if [ -z "$1" ];
then
	CFIL="*";
fi

# Copy the specified objects
for FNAME in $UTIL_DIR/$CFIL.sh;
do
	if [ -x "$FNAME" ];
	then
		cp "$FNAME" "$HOME/bin/$(basename ${FNAME%\.sh})";
		cpresult="$?";
		if [ "$cpresult" -ne 0 ];
		then
			echo -e "\e[01;31m$UTIL_DIR/$CFIL.sh not found\e[00m";
		else
			echo -e "\e[01;32m$FNAME -> $HOME/bin/$(basename ${FNAME%\.sh})\e[00m";
		fi
	else
		echo -e "\e[01;31m$UTIL_DIR/$CFIL.sh not found or not executable\e[00m";
	fi
done


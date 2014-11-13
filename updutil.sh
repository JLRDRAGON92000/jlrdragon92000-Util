#!/bin/bash

# Update Util/

# Remote URL of the git repository
FETCH_REPO_URL="https://github.com/JLRDRAGON92000/jlrdragon92000-Util.git";
# Working directory while new Util/ is merged
UTIL_TMP_DIR="$HOME/Util.tmp";

# Get first argument
# If it is nil, use * (Everything)
CFIL="$1";

# Fetch mode (Fetch from the git repository)
if [ "$CFIL" == "--fetch" ];
then
	FFIL="$2";
	if [ -z "$2" ];
	then
		:;
	fi
	
	# Save the user's current working directory
	pwdbak="$PWD";
	# Go to Util/
	cd "$UTIL_DIR";
	# Get the list of different files from the upstream
	UTIL_DIFF_LIST=$(git diff --name-only @{upstream} -- "$FFIL");
	# Download the most current version of Util/ from the repo
	cd "$HOME";
	git clone "$FETCH_REPO_URL";
	mv "jlrdragon92000-Util" "Util.tmp";
	# Copy the changed files to Util/
	for CFNAME in $UTIL_DIFF_LIST;
	do
		cp -f "Util.tmp/$CFNAME" "Util/$CFNAME"; 
	done
	# Clean up
	rm -rf "Util.tmp";
	cd "$pwdbak";
	exit 0;
fi

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
		if [ "$CFIL" == "*" ];
		then
			echo -e "\e[01;31m$FNAME not executable\e[00m";
		else
			echo -e "\e[01;31m$UTIL_DIR/$CFIL.sh not found or not executable\e[00m";
		fi

	fi
done


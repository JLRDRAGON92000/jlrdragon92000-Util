#!/bin/bash

# Update Util/

# Remote URL of the git repository
FETCH_REPO_URL="https://github.com/JLRDRAGON92000/jlrdragon92000-Util.git";
# Working directory while new Util/ is merged
UTIL_TMP_DIR="$HOME/Util.tmp";

# Get first argument
# If it is nil, use * (Everything)
CFIL="$1";
FFIL="";

# Fetch mode (Fetch from the git repository)
if [ "$CFIL" == "--fetch" ] || [ "$CFIL" == "--fetch-all" ];
then
	FFIL="$2";
	if [ -z "$2" ];
	then
		FFIL="*";
	fi
	
	# Save the user's current working directory
	pwdbak="$PWD";
	# Go to Util/
	cd "$UTIL_DIR";
	# Update the HEAD of the upstream
	git fetch -u "origin" "master";
	# Get the list of different files from the upstream
	UTIL_DIFF_LIST=$(git diff --name-only @{upstream} -- "$FFIL.sh");
	# Show the diff list
	echo -e "\e[01;32mFiles to be changed:
\e[01;37m$UTIL_DIFF_LIST\e[00m";
	# Download the most current version of Util/ from the repo
	cd "$HOME";
	git clone "$FETCH_REPO_URL";
	mv "jlrdragon92000-Util" "Util.tmp";
	
	# Are we in --fetch-all mode? If so, every file is changed
	if [ "$CFIL" == "--fetch-all" ];
	then
		UTIL_DIFF_LIST="$HOME/Util.tmp/*";
	fi
	# Copy the changed files to Util/ (or all of them if --fetch-all)
	for CFNAME in $UTIL_DIFF_LIST;
	do
		cp -f "$HOME/Util.tmp/$(basename $CFNAME)" "$HOME/Util/$(basename $CFNAME)"; 
	done
	# Clean up
	rm -rf "$HOME/Util.tmp";
	cd "$pwdbak";
	# Did we copy any files? If not, exit now
	if [ "$CFIL" != "--fetch-all" ] && [ -z "$UTIL_DIFF_LIST" ];
	then
		exit 0;
	fi
fi

if [ -z "$1" ];
then
	CFIL="*";
elif [ "$1" == "--fetch" ] || [ "$1" == "--fetch-all" ];
then
	CFIL="$FFIL";
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


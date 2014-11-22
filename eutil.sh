#!/bin/bash
# Edit a Util shell script by name from anywhere, then copy it to the bin when done

# Change default editor here
EUTIL_EDITOR="vim";

# Get target script
target="$1";

# Get mode (Currently, this can only be either 'nocopy' or unset)
EUTIL_NOCOPY="";
EUTIL_DOCHMOD="";

mode="$2";
if [ ! -z "$mode" ];
then
	case $mode in
		nocopy)
			# Set no-copy mode (Will not copy when done)
			EUTIL_NOCOPY="1";;
		*)
			# The user entered an invalid mode, warn them
			echo -e "\033[01;31mValid mode arguments are: nocopy\033[00m";
			exit 1;
	esac
fi

# Is the target a new file? If so, we will make it executable when it comes time to copy it
if [ ! -e "$UTIL_DIR/$target.sh" ];
then
	EUTIL_DOCHMOD="1";
else
	EUTIL_DOCHMOD="";
fi

# Invoke specified editor on script (The user will enter it without a .sh extension, so we add that for them)
"$EUTIL_EDITOR" "$UTIL_DIR/$target.sh";

# When the user is done, we will copy the newly edited script to ~/bin for them.
# Functionality reused from updutil, but I didn't want to invoke it directly. (What if they edit it with this, and then break it?)
if [ -z "$EUTIL_NOCOPY" ];
then
	# Make it executable
	[ -n "$EUTIL_DOCHMOD" ] && chmod 755 "$UTIL_DIR/$target.sh";
	
	# Copy it only if it is executable
	if [ -x "$UTIL_DIR/$target.sh" ];
	then
		cp "$UTIL_DIR/$target.sh" "$HOME/bin/$target" 2>/dev/null;
		cpresult="$?";
		if [ "$cpresult" -ne 0 ];
		then
			echo -e "\033[01;31m$UTIL_DIR/$target.sh not found, or $HOME/bin/$target could not be created\033[00m";
		else
			echo -e "\033[01;32m$UTIL_DIR/$target.sh -> $HOME/bin/$target\033[00m";
		fi
	fi
fi


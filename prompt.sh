#!/bin/bash

# prompt.sh : That part of Util/ that starts everything.
# Sourced in .bashrc, just after .emerdefaults.sh.

# Determine whether we should allow some features exclusive to terminals in desktop environments.
case $TERM in
	xterm*|rxvt*)
		export USE_LINEDRAW_ESCS="1";
		export USE_TITLEBAR="1";;
	*)
		export USE_LINEDRAW_ESCS="";
		export USE_TITLEBAR="";
esac

# Get just the IP from $SSH_CLIENT.
export SSH_IP="${SSH_CLIENT:+$(echo $SSH_CLIENT | cut -f1 -d' ')}";

# Get the TTY
export TTY="$(tty)";

# Constants for the prompt and associated utilities
export UTIL_DIR="$HOME/Util";
export PS1L_FIL="$UTIL_DIR/.ps1modelast.lock";
export PS1M_DIR="$UTIL_DIR/.ps1custopts.lock";

# Source git-prompt.sh from here instead of ~/.git-prompt.sh, which does not show upstream names
source "$UTIL_DIR/git-prompt.sh";

# Check terminal size
shopt -s checkwinsize;

# Default variable values for the Git PS1 string
GIT_PS1_SHOWDIRTYSTATE=1;
GIT_PS1_SHOWSTASHSTATE=1;
GIT_PS1_SHOWUNTRACKEDFILES=1;
GIT_PS1_SHOWUPSTREAM="verbose name";
GIT_PS1_SHOWCOLORHINTS=1;

# Aliases
alias md="mkdir";

# Common small utilities that don't need their own files
# jrm - Delete all class and source files associated with a Java class
jrm () {
	rm "$1.java"
	rm "$1.class"
	rm $1\$*.class
}

# gitcpush - Create new commit, then push and set tracking upstream
gitcpush () {
	git commit -am "$1";
	git push -u "$2" "$3"
}

# mkcd - Make a directory, then cd into it
mkcd () {
	mkdir "$1";
	cd "$1";
}

# rd - Remove a directory recursively
rd () {
	rm -r "$1";
}

# Download something from the C9 workspace
# C9's new backend changed things a lot, so I have to change this to make up for that
C9DL_DAV_URLBASE="https://vfs-gce-usw-02.c9.io/vfs/634996/pWHoaKm397vtCYIt/workspace";
c9dl () {
	curl "$C9DL_DAV_URLBASE/$1" -o "$(basename $1)";
}

# It turns out cd can already cd into the last used directory
# So implemented here is a method that will not echo $OLDPWD to stdout when this happens
cdlast () {
	if [ "$1" == "-" ];
	then
		cd "$OLDPWD";
	else
		cd "$1";
	fi
}
# Set an alias to use it instead of cd
alias cd="cdlast";

# cat and append a newline
catn () {
	command cat $* && echo "";
}
# Set an alias to use it instead of cat
alias cat="catn";

# Count the number of characters in each argument, then return the length of the longest one
longestw () {
	let lngst=0;
	for a in $@;
	do
		if [ "${#a}" -gt "$lngst" ];
		then
			let lngst="${#a}";
		fi
	done
	echo -n "$lngst";
}

# List PS1 modes
ps1_list () {
	local SEARCH_DIR llng lngst ps1ln finout;
	echo -e "\e[01;33mGetting PS1 modes from directory...\e[00m";
	let lngst=0;
	SEARCH_DIR="$PS1M_DIR";
	for FN in $SEARCH_DIR/*.sh;
	do
		ps1ln="$(ps1_longname -p $FN)";
		if [ "${#ps1ln}" -gt "$lngst" ];
		then
			let lngst=${#ps1ln};
		fi
	done
	if [ -n "$USE_LINEDRAW_ESCS" ];
	then
		fil="qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq";
	else
		fil="-----------------------------------------------------------------------------------------------";
	fi
	let llng=$lngst+3;
	
	finout="";
	ps1lnx="Long name";
	let flngx=$llng-${#ps1lnx};
	let flng=$flngx-2;
	finout=$finout$(echo "\e[A\e[01;33m$ps1lnx" "\e(0${fil:0:flng}\e(B" "\e[01;33mShort name\n");
	for FN in $SEARCH_DIR/*.sh;
	do
		ps1lnx="$(ps1_longname -p $FN)";
		let flngx=$llng-${#ps1lnx};
		let flng=$flngx-2;
		if [ "$(basename $FN)" == "$PS1MODELAST.sh" ];
		then
			finout=$finout$(echo "\e[01;34m"$(ps1_longname -p "$FN") "\e(0${fil:0:flng}\e(B" "\e[01;34m"$(ps1_shortname -p "$FN")"\n");
		else
			finout=$finout$(echo "\e[01;37m"$(ps1_longname -p "$FN") "\e(0${fil:0:flng}\e(B" "\e[00m"$(ps1_shortname -p "$FN")"\n");
		fi
	done
	echo -e "$finout";
}
# Create a new PS1 mode
ps1_add () {
	local shn lon p1s p2s p3s p4s prc ini gds gss guf gup gch SEARCH_DIR;
	
	if [ "$1" == "-a" ];
	then
		# Either by argument mode...
		if [ "$#" -lt "14" ];
		then
			disperr "fatal" "Not enough arguments";
			return 2;
		else
			shn="$2";
			lon="$3";
			p1s="$4";
			p2s="$5";
			p3s="$6";
			p4s="$7";
			prc="$8";
			ini="$9";
			gds="$10";
			gss="$11";
			guf="$12";
			gup="$13";
			gch="$14";
		fi
	else
		# ... or by input mode
		echo -n "Short name: ";
		read -r shn;
		echo -n "Long name: ";
		read -r lon;
		echo -e "\e[01;33mNOTICE: The system will automatically add a space to the end of PS1, PS2, PS3, and PS4.\e[00m";
		echo -n "PS1 string: ";
		read -r p1s;
		echo -n "PS2 string: ";
		read -r p2s;
		echo -n "PS3 string: ";
		read -r p3s;
		echo -n "PS4 string: ";
		read -r p4s;
		echo -n "PROMPT_COMMAND string: ";
		read -r prc;
		echo -n "Initialization code string: ";
		read -r ini;
		echo -n "Value for GIT_PS1_SHOWDIRTYSTATE: ";
		read -r gds;
		echo -n "Value for GIT_PS1_SHOWSTASHSTATE: ";
		read -r gss;
		echo -n "Value for GIT_PS1_SHOWUNTRACKEDFILES: ";
		read -r guf;
		echo -n "Value for GIT_PS1_SHOWUPSTREAM: ";
		read -r gup;
		echo -n "Value for GIT_PS1_SHOWCOLORHINTS: ";
		read -r gch;
	fi
	SEARCH_DIR="$PS1M_DIR";
	echo -n "$shn	$lon	$p1s 	$p2s 	$p3s 	$p4s 	$prc	$ini	$gds	$gss	$guf	$gup	$gch" >"$SEARCH_DIR/$shn.sh";
	echo -e "\e[01;33mNew PS1 mode \"\e[01;31m$lon\e[01;33m\" created successfully.";
}
# Remove a PS1 mode (though you could just do this with rm, but it is easier when you don't have to cd into the directory, or type a fully qualified pathname)
ps1_rm () {
	local SEARCH_DIR skwd;
	SEARCH_DIR="$PS1M_DIR";
	if [ "$1" == "" ];
	then
		disperr "fatal" "Bad argument #1 to ps1_rm";
	else
		skwd="$1";
		if [ -e "$SEARCH_DIR/$skwd.sh" ];
		then
			echo -e "\e[01;33mPS1 mode \"\e[01;31m$(ps1_longname $skwd)\e[01;33m\" removed successfully."
			rm "$SEARCH_DIR/$skwd.sh";
		else
			disperr "fatal" "The specified PS1 mode was not found.";
		fi
	fi
}
# Set a PS1 mode temporarily
# After the session ends or the PS1 mode is changed, it is as though that PS1 mode never existed
ps1_cust () {
	local shn lon p1s p2s p3s p4s prc ini gds gss guf gup gch SEARCH_DIR;
	
	if [ "$1" == "-a" ];
	then
		# Either by argument mode...
		if [ "$#" -lt "14" ];
		then
			disperr "fatal" "Not enough arguments";
			return 2;
		else
			shn="$2";
			lon="$3";
			p1s="$4";
			p2s="$5";
			p3s="$6";
			p4s="$7";
			prc="$8";
			ini="$9";
			gds="$10";
			gss="$11";
			guf="$12";
			gup="$13";
			gch="$14";
		fi
	else
		# ... or by input mode
		echo -n "Short name: ";
		read -r shn;
		echo -n "Long name: ";
		read -r lon;
		echo -e "\e[01;33mNOTICE: The system will automatically add a space to the end of PS1, PS2, PS3, and PS4.\e[00m";
		echo -n "PS1 string: ";
		read -r p1s;
		echo -n "PS2 string: ";
		read -r p2s;
		echo -n "PS3 string: ";
		read -r p3s;
		echo -n "PS4 string: ";
		read -r p4s;
		echo -n "PROMPT_COMMAND string: ";
		read -r prc;
		echo -n "Initialization code string: ";
		read -r ini;
		echo -n "Value for GIT_PS1_SHOWDIRTYSTATE: ";
		read -r gds;
		echo -n "Value for GIT_PS1_SHOWSTASHSTATE: ";
		read -r gss;
		echo -n "Value for GIT_PS1_SHOWUNTRACKEDFILES: ";
		read -r guf;
		echo -n "Value for GIT_PS1_SHOWUPSTREAM: ";
		read -r gup;
		echo -n "Value for GIT_PS1_SHOWCOLORHINTS: ";
		read -r gch;
	fi
	SEARCH_DIR="$PS1M_DIR";
	echo -n "$shn	$lon	$p1s 	$p2s 	$p3s 	$p4s 	$prc	$ini	$gds	$gss	$guf	$gup	$gch" >"$SEARCH_DIR/._X_arbcust.sh";
	ps1_custparseset "$SEARCH_DIR/._X_arbcust.sh";
	rm "$SEARCH_DIR/._X_arbcust.sh";
	echo -e "\e[01;33mUsing custom PS1 mode \"$lon\".";
}
# Look up the long name of a PS1 mode
ps1_longname () {
	local ps1fp;
	if [ "$1" == "-p" ];
	then
		ps1fp="$2";
	else
		ps1fp=$(ps1_custget "$1");
	fi
	echo $(cut -f2 -d"	" "$ps1fp");
}
# Look up the short name of a PS1 mode (Only really intended for ps1_list)
ps1_shortname () {
	local ps1fp;
	if [ "$1" == "-p" ];
	then
		ps1fp="$2";
	else
		ps1fp=$(ps1_custget "$1");
	fi
	echo $(cut -f1 -d"	" "$ps1fp");
}

# Display the help for the prompt switching system
ps1_help () {
	if [ -z "$1" ];
	then
		# If the user doesn't specify anything, display the general help
		echo -e "\

    \e[01;33m=== PS1 MODE SYSTEM HELP ===\e[00m
    This system switches between various PS1 modes defined by files.

    \e[01;33m--- COMMANDS ---\e[00m
    \e[01;37mps1 -------------- \e[00mSwitch PS1 modes
    \e[01;37mps1_list --------- \e[00mList all available PS1 modes
    \e[01;37mps1_add ---------- \e[00mAdd a new PS1 mode
    \e[01;37mps1_rm ----------- \e[00mRemove an existing PS1 mode
    \e[01;37mps1_help --------- \e[00mDisplay this help
    \e[01;37mps1_longname ----- \e[00mLook up the long name of a PS1 mode
    \e[01;37mps1_shortname ---- \e[00mLook up the short name of a PS1 mode
    \e[01;37mps1_custget ------ \e[00mResolve a PS1 mode short name into the path for its file
    \e[01;37mps1_custparseset - \e[00mRead a PS1 mode file and set PS1 and associated variables
    Type \"\e[01;33mps1_help COMMAND\e[00m\" for help on each command.
    Type \"\e[01;33mps1_help filesyntax\e[00m\" to learn about writing custom PS1 mode files.
	";
	else
		# Get the help for a command
		case "$1" in
			ps1)				echo -e "\e[01;33musage: \e[01;37mps1 MODENAME [-s]\e[00m\nSwitches to the specified PS1 mode. If -s is given, it does not echo the PS1 mode.";;
			ps1_list)			echo -e "\e[01;33musage: \e[01;37mps1_list\e[00m\nLists the available PS1 modes.";;
			ps1_help)			echo -e "\e[01;33musage: \e[01;37mps1_help [COMMAND]\e[00m\nDisplays this help. If COMMAND is given, displays the help for COMMAND.";;
			ps1_longname)		echo -e "\e[01;33musage: \e[01;37mps1_longname [-p] PS1MODE\e[00m\nGets the long name of a PS1 mode. If -p is given, PS1MODE will be used as a path to the desired PS1 mode file,\notherwise PS1MODE is the short name of the PS1 mode.";;
			ps1_shortname)		echo -e "\e[01;33musage: \e[01;37mps1_shortname [-p] PS1MODE\e[00m\nGets the short name of a PS1 mode. If -p is given, PS1MODE will be used as a path to the desired PS1 mode file,\notherwise PS1MODE is the short name of the PS1 mode.";;
			ps1_custget)		echo -e "\e[01;33musage: \e[01;37mps1_custget PS1MODE\e[00m\nResolve the given PS1 mode short name to a path to a PS1 mode file.";;
			ps1_custparseset)	echo -e "\e[01;33musage: \e[01;37mps1_custparseset PS1MPATH\e[00m\nParses a PS1 mode file and sets PS1 and associated variables accordingly. PS1MPATH is a path to a PS1 mode file.";;
			ps1_add)			echo -e "\e[01;33musage: \e[01;37mps1_add [-a ARGS...]\e[00m\nCreates a new PS1 mode. If the -a option is given, ps1_add will take the PS1 mode parameters as arguments in the following order:\nlong name, short name, PS1, PS2, PS3, PS4, PROMPT_COMMAND, initialization code, GIT_PS1_SHOWDIRTYSTATE, GIT_PS1_SHOWSTASHSTATE, GIT_PS1_SHOWUNTRACKEDFILES, GIT_PS1_SHOWUPSTREAM, GIT_PS1_SHOWCOLORHINTS\nOtherwise ps1_add will prompt for each parameter individually.";;
			ps1_rm)				echo -e "\e[01;33musage: \e[01;37mps1_rm MODENAME\e[00m\nRemoves the specified PS1 mode.";;
			filesyntax)
				echo -e "\n    \e[01;33m--- WRITING PS1 MODE FILES ---\e[00m
    PS1 modes are stored in PS1 mode files, stored in the directory specified internally by \"\$PS1M_DIR\".
    The syntax of a PS1 mode file is as follows:
    \e[01;37mLine 1   \e[00mThe short name of this PS1 mode, used from ps1 to switch to it
    \e[01;37mLine 2   \e[00mThe long name of this PS1 mode, displayed in most places
    \e[01;37mLine 3   \e[00mThe string to set PS1 to. This should be used as though you were setting PS1 directly
    \e[01;37mLine 4   \e[00mThe string to set PS2 to. This should be used as though you were setting PS2 directly
    \e[01;37mLine 5   \e[00mThe string to set PS3 to. This should be used as though you were setting PS3 directly [Substitution and escape codes are not allowed here]
    \e[01;37mLine 6   \e[00mThe string to set PS4 to. This should be used as though you were setting PS4 directly
    \e[01;37mLine 7   \e[00mThe string to set PROMPT_COMMAND to. This should be used as though you were setting PROMPT_COMMAND directly
    \e[01;37mLine 8   \e[00mA string specifying code to run once when switching to this mode
    \e[01;37mLine 8   \e[00mValue for GIT_PS1_SHOWDIRTYSTATE
    \e[01;37mLine 9   \e[00mValue for GIT_PS1_SHOWSTASHSTATE
    \e[01;37mLine 10  \e[00mValue for GIT_PS1_SHOWUNTRACKEDFILES
    \e[01;37mLine 11  \e[00mValue for GIT_PS1_SHOWUPSTREAM
    \e[01;37mLine 12  \e[00mValue for GIT_PS1_SHOWCOLORHINTS
    Once these are all entered, replace all of the line breaks with tabs. (This is due in part to an issue with newer versions of cut, where it cannot separate files along the LF character.
    Name the file \"\e[01;33m<short name of your PS1 mode here>.sh\e[00m\" and put it into the .ps1custopts.lock directory.\n";;
			*)
				echo -e "\e[01;31mThe help topic you requested was not found.\e[00m";
				return 1;;
		esac
	fi
}

# Switch PS1 modes
ps1 () {
	# Don't allow switching to modes starting with .
	if [ "${1:0:1}" == "." ];
	then
		echo -e "\e[01;31mSwitching to PS1 modes starting with . is not allowed\e[00m";
		echo -e "\e[01;31m(Files in the modes directory starting with . are usually
that way for a reason. They are not meant to be used as modes.)\e[00m";
		return 1;
	fi
	# Find the PS1 mode the user specified
	PS1FPATH=$(ps1_custget "$1");
	PS1FSUCCESS="$?";
	if [ "$PS1FSUCCESS" -ne 0 ]; then didputval=0; else didputval=1; fi;
	
	# Tell the user what they set it to, if they didn't mess up
	if [ "$didputval" -ne 0 ];
	then
		if [ "$2" == "-s" ];
		then
			# -s option given, set PS1 mode silently
			echo -ne "";
		else
			# Get the PS1 mode long name and display it
			PS1CLN=$(ps1_longname "$1");
			echo -e "\e[01;33mPS1 mode set to \e[01;31m$PS1CLN\e[01;33m.\e[00m";
		fi
		
		# Set PS1 according to the PS1 mode file
		ps1_custparseset "$PS1FPATH";
		
		# Set the last PS1 mode memory
		export PS1MODELAST="$1";
		# Also write it to a file
		echo -n "$PS1MODELAST" >"$PS1L_FIL";
	else
		# Otherwise, warn the user
		echo -e "\e[01;31mUnrecognized PS1 mode setting: $1\e[00m";
		echo -e "\e[01;31mType \"ps1_list\" for a list of available PS1 modes\e[00m";
		return 1;
	fi
}
# Resolve a short PS1 mode name to the absolute path of a PS1 mode file
ps1_custget () {
	local SEARCH_DIR SEARCH_KWD;
	SEARCH_DIR="$PS1M_DIR";
	SEARCH_KWD="$1";
	if [ -e "$SEARCH_DIR/$SEARCH_KWD.sh" ];
	then
		echo "$SEARCH_DIR/$SEARCH_KWD.sh";
		return 0;
	else
		return 1;
	fi
	return 1;
}
# Parse a PS1 mode file and set PS1 and associated variables accordingly
ps1_custparseset () {
	local ps1cp ps1n ps1ln ps1str ps2str ps3str ps4str pcstr initstr gitshds gitshss gitshuf gitshup gitshch;
	ps1cp="$1";
	
	ps1n=$(cut -f1 -d"	" "$ps1cp");
	ps1ln=$(cut -f2 -d"	" "$ps1cp");
	ps1str=$(cut -f3 -d"	" "$ps1cp");
	ps2str=$(cut -f4 -d"	" "$ps1cp");
	ps3str=$(cut -f5 -d"	" "$ps1cp");
	ps4str=$(cut -f6 -d"	" "$ps1cp");
	pcstr=$(cut -f7 -d"	" "$ps1cp");
	initstr=$(cut -f8 -d"	" "$ps1cp");
	gitshds=$(cut -f9 -d"	" "$ps1cp");
	gitshss=$(cut -f10 -d"	" "$ps1cp");
	gitshuf=$(cut -f11 -d"	" "$ps1cp");
	gitshup=$(cut -f12 -d"	" "$ps1cp");
	gitshch=$(cut -f13 -d"	" "$ps1cp");
	PS1="$ps1str";
	PS2="$ps2str";
	PS3="$ps3str";
	PS4="$ps4str";
	PROMPT_COMMAND="$pcstr";
	echo "$PS1MODELAST" >"$PS1L_FIL"
	GIT_PS1_SHOWDIRTYSTATE="$gitshds";
	GIT_PS1_SHOWSTASHSTATE="$gitshss";
	GIT_PS1_SHOWUNTRACKEDFILES="$gitshuf";
	GIT_PS1_SHOWUPSTREAM="$gitshup";
	GIT_PS1_SHOWCOLORHINTS="$gitshch";
	# Run the specified initialization code
	eval "$initstr";
}

# Display something with an error level
disperr () {
	case "$1" in
	info)	echo -e "\e[01;32m[INFO]\e[01;37m  $2\e[00m";;
	warn)	echo -e "\e[01;34m[WARN]\e[01;37m  $2\e[00m";;
	error)	echo -e "\e[01;33m[ERROR]\e[01;37m $2\e[00m";;
	fatal)	echo -e "\e[01;31m[FATAL]\e[01;37m $2\e[00m";;
	# Default error level is INFO, so use that if an invalid level is supplied
	*)		echo -e "\e[01;32m[INFO]\e[01;37m  $2\e[00m";;
	esac
}

# For the PS1 gitstring: Get the SHA-1's of the HEAD and the upstream
__git_ps1_show_sha () {
	local shead supst shastr;
	shead="$(git rev-parse --short HEAD 2>/dev/null)";
	supst="$(git rev-parse --short @{upstream} 2>/dev/null)";
	if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ];
	then
		shastr="$shead..$supst"
	else
		shastr="$shead";
	fi
	echo "$shastr";
}
# Load the PS1 last mode file
export PS1MODELAST=$(cat "$PS1L_FIL");
# Start in whatever PS1 mode I left it in, otherwise start it in full mode
if [ -z "$PS1MODELAST" ];
then
	# Start in full mode
	ps1 "full" -s;
else
	# Otherwise, start in whatever PS1 mode was saved last
	ps1 "$PS1MODELAST" -s;
fi

# Show the startup message
echo -e "\n\
    \e[01;33mLogged on to \e[01;31m$HOSTNAME\e[01;33m as \e[01;31m$USER\e[01;33m from \e[01;31m$(if [ -z $SSH_IP ]; then echo 'console'; else echo $SSH_IP; fi;) (${TTY:5})\n\
    \e[01;33mType \"\e[01;31mps1_help\e[01;33m\" for help with the PS1 mode system\n\
    \e[01;33mYou are using the \e[01;31m$(ps1_longname $PS1MODELAST)\e[01;33m PS1 mode\n\e[00m";

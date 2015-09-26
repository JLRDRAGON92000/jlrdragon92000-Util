#!/bin/bash

# logdump: Dump out all log entries in a more readable format

# Back up current value of IFS, so that we can change it later
ifsbak=$IFS;

# Set IFS to just \n, to load the log file one line at a time
IFS="
";
# Load the log file
let lindex=0;
lines=();
for lfline in $(cat "$UTIL_LOGPATH");
do
	lines[lindex]="$lfline";
	let lindex+=1;
done

# Parse each line and write results to stdout
for lfline in ${lines[*]};
do
	lluser=$(echo "$lfline" | cut -f1 -d"|");
	llhost=$(echo "$lfline" | cut -f2 -d"|");
	llyear=$(echo "$lfline" | cut -f3 -d"|");
	llmonth=$(echo "$lfline" | cut -f4 -d"|");
	llday=$(echo "$lfline" | cut -f5 -d"|");
	llhour=$(echo "$lfline" | cut -f6 -d"|");
	llmin=$(echo "$lfline" | cut -f7 -d"|");
	llssh=$(echo "$lfline" | cut -f8 -d"|");
	lltty=$(echo "$lfline" | cut -f9 -d"|");
	echo -e "\e[01;32m${lluser}@${llhost}\e[01;37m logged in \e[01;36m${llyear}-${llmonth}-${llday}\e[01;37m at \e[01;36m${llhour}:${llmin}\e[01;37m from \e[01;33m${llssh}\e[01;37m on \e[01;34m${lltty}\e[00m";
done

# Restore IFS
IFS=$ifsbak;


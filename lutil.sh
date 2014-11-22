#!/bin/bash

# List all scripts in Util/, using similar format to ps1_list
# (In fact, this is taken directly from ps1_list, right down to the variable names, which I did not feel like changing.)

echo -e "\033[01;33m[Loading]\033[00m";
let lngst=0;

SEARCH_DIR="$UTIL_DIR";

for FN in $SEARCH_DIR/*.sh;
do
	shbase=$(basename $FN);
	if [ "${#shbase}" -gt "$lngst" ]; then
		let lngst=${#shbase};
	fi;
done
if [ -n "$USE_LINEDRAW_ESCS" ]; then
	fil="qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq";
else
	fil="-----------------------------------------------------------------------------------------------";
fi

let llng=$lngst+3;
finout="";
ps1lnx="Name";
let flngx=$llng-${#ps1lnx};
let flng=$flngx-2;
finout=$finout$(echo "\033[A\033[01;33m$ps1lnx" "\033(0${fil:0:flng}\033(B" "\033[01;33mExec?\n");
for FN in $SEARCH_DIR/*.sh;
do
	ps1lnx="$(basename $FN)";
	let flngx=$llng-${#ps1lnx};
	let flng=$flngx-2;
	finout=$finout$(echo "\033[01;37m"$(basename $FN) "\033(0${fil:0:flng}\033(B" "\033[00m"$( if [ -x "$FN" ]; then echo 'Yes'; else echo 'No'; fi; )"\n");
done
echo -e "$finout"

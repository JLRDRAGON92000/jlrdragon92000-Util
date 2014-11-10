#!/bin/bash

DEF_INST_DIR="$HOME/bin/crun";

if [ "$#" -lt 1 ];
then
	echo -e "\e[01;33musage: crun <-a|-c|-r> <sourcename>\e[00m";
	exit 2;
fi

if [ -e "$2.c" ] || [ "$1" == "-i" ] || [ "$1" == "-if" ];
then
	case "$1" in
		-c)
			echo -e "\e[01;34mCompiling ${2}...\e[00m";
			gcc -Wall -g "${2}.c" -o "${2}.exe";
			gccexttmp="$?";
			if [ "$gccexttmp" -eq 0 ];
			then
				echo -e "\e[01;32mCompilation successful.\e[00m";
				echo $(date "+%d %b %Y, %H:%M")"|${2}|SUCCESS" >"./.cproj.lock";
				exit 0;
			else
				echo -e "\e[01;31mCompilation failed with status $gccexttmp.\e[00m";
				echo $(date "+%d %b %Y, %H:%M")"|${2}|FAILURE" >"./.cproj.lock";
				exit $gccexttmp;
			fi;;
		-r)
			args="";
			let argi=1;
			for arg in $*;
			do
				if [ $argi -gt 2 ];
				then
					args="$args $arg";
				fi
				let argi+=1;
			done
			echo -e "\e[01;34mRunning ${2}\e[00m"
			./"${2}.exe" $args;
			pxt="$?";
			if [ "$pxt" -eq 0 ];
			then
				echo -e "\e[01;32m${2} completed with status $pxt\e[00m";
			else
				echo -e "\e[01;31m${2} failed with status $pxt\e[00m";
			fi
			exit $pxt;;
		-a)
			echo -e "\e[01;34mCompiling ${2}...\e[00m";
			gcc -Wall -g "${2}.c" -o "${2}.exe";
			gccexttmp="$?";
			if [ "$gccexttmp" -eq 0 ];
			then
				echo -e "\e[01;32mCompilation successful.\e[00m";
				echo $(date "+%d %b %Y, %H:%M")"|${2}|SUCCESS" >"./.cproj.lock";
				
				args="";
				let argi=1;
				for arg in $*;
				do
					if [ $argi -gt 2 ];
					then
						args="$args $arg";
					fi
					let argi+=1;
				done
				echo -e "\e[01;34mRunning ${2}\e[00m"
				./"${2}.exe" $args;
				prgexttmp="$?";
				if [ "$prgexttmp" -eq 0 ];
				then
					echo -e "\e[01;32m${2} completed with status $prgexttmp\e[00m";
				else
					echo -e "\e[01;31m${2} failed with status $prgexttmp\e[00m";
				fi
				exit $prgexttmp;
			else
				echo -e "\e[01;31mCompilation failed with status $gccexttmp.\e[00m";
				echo $(date "+%d %b %Y, %H:%M")"|${2}|FAILURE" >"./.cproj.lock";
				exit $gccexttmp;
			fi;;
		-us)
			echo $(date "+%d %b %Y, %H:%M")"|${2}|SUCCESS" >"./.cproj.lock";
			echo -e "\e[01;34mFalsified .cproj.lock: $2 \"built\" at $(date "+%d %b %Y, %H:%M") with successful result";;
		-uf)
			echo $(date "+%d %b %Y, %H:%M")"|${2}|FAILURE" >"./.cproj.lock";
			echo -e "\e[01;34mFalsified .cproj.lock: $2 \"built\" at $(date "+%d %b %Y, %H:%M") with failed result";;
		-i)
			cp "$PWD/$0" "$DEF_INST_DIR";
			cpresult="$?";
			chmod 755 "$DEF_INST_DIR";
			chmodresult="$?";
			if [ $cpresult -ne 0 ] || [ $chmodresult -ne 0 ];
			then
				echo -e "\e[01;31mcrun: An error occured during installation. Check that you have write permission in the default installation directory ${DEF_INST_DIR}.";
				exit 1;
			else
				echo -e "\e[01;34mcrun installed successfully at ${DEF_INST_DIR}.";
			fi;;
		-if)
			cp "$PWD/$0" "$2";
			cpresult="$?";
			chmod 755 "$2";
			chmodresult="$?";
			if [ $cpresult -ne 0 ] || [ $chmodresult -ne 0 ];
			then
				echo -e "\e[01;31mcrun: An error occured during installation. Check that you have write permission in your requested installation directory ${2}.";
				exit 1;
			else
				echo -e "\e[01;34mcrun installed successfully at ${2}.";
			fi;;
	esac
else
	echo -e "\e[01;33mSource ${2} not found.\e[00m";
fi

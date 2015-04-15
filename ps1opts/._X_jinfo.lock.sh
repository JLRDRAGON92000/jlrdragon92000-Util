# WARNING: Not valid as PS1 mode
# WARNING: This file is not intended for use with the PS1 mode system. It is used by the ainfo prompt to set the Java info prompt.
dirbase="\\w";
if [ -n "$USE_TITLEBAR" ]; then
	if [ $(id -u) -eq 0 ]; then
		if [ -n "$SSH_CLIENT" ] && [ "$PROMPT_SHOW_SSH_UH" == "1" ]; then
			titleb="\[\e]0;[#] \${USER}@\${HOSTNAME} : ${dirbase}\007\]\[\e[01;37m\][\[\e[01;31m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
		elif [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
			titleb="\[\e]0;[#] \${USER}@\${HOSTNAME} : ${dirbase}\007\]\[\e[01;37m\][\[\e[01;31m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
		else
			titleb="\[\e]0;[#] ${dirbase}\007\]\[\e[01;37m\][\[\e[01;31m\]-ROOT-\[\e[01;37m\]]";
		fi
	elif [ -z "$PROMPT_SHOW_SSH_UH" ]; then
		titleb="\[\e]0;${dirbase}\007\]";
	elif [ -n "$SSH_CLIENT" ] && [ "$PROMPT_SHOW_SSH_UH" == "1" ]; then
		titleb="\[\e]0;\${USER}@\${HOSTNAME} : ${dirbase}\007\]\[\e[01;37m\][\[\e[01;32m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
	elif [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
		titleb="\[\e]0;\${USER}@\${HOSTNAME} : ${dirbase}\007\]\[\e[01;37m\][\[\e[01;32m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
	else
		titleb="\[\e]0;${dirbase}\007\]";
	fi
else
	if [ $(id -u) -eq 0 ]; then
		if [ -n "$SSH_CLIENT" ] && [ "$PROMPT_SHOW_SSH_UH" == "1" ]; then
			titleb="\[\e[01;37m\][\[\e[01;31m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
		elif [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
			titleb="\[\e[01;37m\][\[\e[01;31m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
		else
			titleb="\[\e[01;37m\][\[\e[01;31m\]-ROOT-\[\e[01;37m\]]";
		fi
	elif [ -z "$PROMPT_SHOW_SSH_UH" ]; then
		titleb="";
	elif [ -n "$SSH_CLIENT" ] && [ "$PROMPT_SHOW_SSH_UH" == "1" ]; then
		titleb="\[\e[01;37m\][\[\e[01;32m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
	elif [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
		titleb="\[\e[01;37m\][\[\e[01;32m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
	else
		titleb="";
	fi
fi

export promptcmd='
	statshow="[$pstattmp] ";
	dirbase="\\w";
	if [ -e "./.javaproj.lock" ]; then
		lastbuild_time=$(cut -f1 -d"|" "./.javaproj.lock");
		lastbuild_fil=$(cut -f2 -d"|" "./.javaproj.lock");
		lastbuild_res=$(cut -f3 -d"|" "./.javaproj.lock");
		csrcs=$(ls -a1 2>/dev/null | grep -c "\.java\$");
		cclss=$(ls -a1 2>/dev/null | grep -c "\.class\$");
		cfils=$(ls -al 2>/dev/null | grep -c "^-");
		let cothr="cfils-(csrcs+cclss)";
		cdirs=$(ls -Al 2>/dev/null | grep -c "^d");
	fi;
	if [ "$lastbuild_res" == "SUCCESS" ]; then
		lastbuild_success="SUCCESS";
		lastbuild_failure="";
	else
		lastbuild_success="";
		lastbuild_failure="FAILURE";
	fi;
	PS1="$titleb\[\e[01;37m\][\[\e[01;34m\]\${debian_chroot:+(\$debian_chroot) }${dirbase}\[\e[01;37m\]][\[\e[01;33m\]\${csrcs}s \${cclss}c \${cothr}o \${cdirs}d\[\e[01;37m\]][\[\e[01;36m\]\$(date \"+%a %Y-%m-%d %H:%M\")\[\e[01;37m\]][\[\e[01;36m\]\${lastbuild_time} ${lastbuild_fil} \[\e[01;32m\]\${lastbuild_success}\[\e[01;31m\]\${lastbuild_failure}\[\e[01;37m\]]\$(__git_ps1 \"[\[\e[01;35m\]%s \$(__git_ps1_show_sha)\[\e[01;37m\]]\")\n\[\e[01;37m\]\$(if [ -z \"\$SSH_IP\" ]; then echo \"LOCAL\"; else echo \$SSH_IP; fi;) -> \${TTY:5} \${statshow}\\\$ \[\e[00m\]";';
eval "$promptcmd";

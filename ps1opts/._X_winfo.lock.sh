# WARNING: Not valid as PS1 mode
# WARNING: This file is not intended for use with the PS1 mode system. It is used by the ainfo prompt to set the web files prompt. (Which is why you are getting such weird values for the PS1 mode system variables.)
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

if [ -n "$VIM" ]; then
	vimsh="[\[\e[01;31m\]VIM\[\e[01;37m\]] ";
else
	vimsh="";
fi

export promptcmd='
	ttytmp=$(tty);
	statshow="[$pstattmp] ";
	chtml=$(ls -a1 | grep -c "\.html\$");
	cphp=$(ls -a1 | grep -c "\.php\$");
	ccss=$(ls -a1 | grep -c "\.css\$");
	let cwebf=$chtml+$cphp+$ccss;
	ishtaccess=$(if [ -e "./.htaccess" ] && (grep "AuthType" "./.htaccess" | grep -qv "None"); then echo "protected "; elif [ -e "./.htaccess" ]; then echo "htaccess "; else echo ""; fi;);
	cfils=$(ls -al | grep -c "^-");
	let cothr=$cfils-$cwebf;
	cdirs=$(ls -Al | grep -c "^d");
	PS1="$titleb\[\e[01;37m\][\[\e[01;34m\]\${debian_chroot:+(\$debian_chroot) }${dirbase}\[\e[01;37m\]][\[\e[01;33m\]\${ishtaccess}\${cwebf}w \${cothr}o \${cdirs}d\[\e[01;37m\]][\[\e[01;36m\]\$(date \"+%a %Y-%m-%d %H:%M\")\[\e[01;37m\]]\$(__git_ps1 \"[\[\e[01;35m\]%s \$(__git_ps1_show_sha)\[\e[01;37m\]]\")\n\[\e[01;37m\]$vimsh\$(if [ -z \"\$SSH_IP\" ]; then echo \"LOCAL\"; else echo \$SSH_IP; fi;) -> \${ttytmp:5} \${statshow}\\\$ \[\e[00m\]";';

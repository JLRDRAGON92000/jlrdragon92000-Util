# Don't feel like going back and changing all of those instances of $dirbase, so it is set to \w (substituted with ${PWD/#$HOME/~})
dirbase='\w';
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
export titleb;

export AINFO_BB_GIT=$(__git_ps1 "\[\e[01;37m\][\[\e[01;35m\]%s $(__git_ps1_show_sha)\[\e[01;37m\]]");

source "$PS1M_DIR/._X_showsshuh.sh";
if [ -e "./.webproj.lock" ]; then
	source "$PS1M_DIR/._X_winfo.sh";
elif [ -e "./.javaproj.lock" ]; then
	source "$PS1M_DIR/._X_jinfo.sh";
elif [ -e "./.cproj.lock" ]; then
	source "$PS1M_DIR/._X_cinfo.sh";
else
	source "$PS1M_DIR/._X_ginfo.sh";
fi
eval "$promptcmd";


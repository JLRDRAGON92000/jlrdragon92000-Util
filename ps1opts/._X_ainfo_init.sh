# A function to safely check whether all values of $PIPESTATUS are 0
statcheck () {
	for STAT in $pstattmp;
	do
		if [ $STAT -ne 0 ]; then
			return 1;
		fi
	done
	return 0;
}

# Export building blocks
# Empty
export AINFO_BB_EMPTY='\[\033[01;37m\][\[\033[01;37m\]]';

# Basic (user@host, directory, time and date, etc...)
export AINFO_BB_USER='\[\033[01;32m\]${USER}@${HOSTNAME}\[\033[01;37m\]';
export AINFO_BB_ROOT='\[\033[01;31m\]-ROOT-\[\033[01;37m\]';
export AINFO_BB_CWD='\[\033[01;34m\]${debian_chroot:+($debian_chroot) }\w\[\033[01;37m\]';
export AINFO_BB_CWDFULL='\[\033[01;34m\]${debian_chroot:+($debian_chroot) }${PWD}\[\033[01;37m\]';
export AINFO_BB_DATE='\[\033[01;36m\]$(date "+%a %Y-%m-%d %H:%M")\[\033[01;37m\]';

# File/directory counter (Basic, only files and directories)
AINFO_BB_FDCOUNT_BASIC () {
	let cfiles=$(ls -al 2>/dev/null | grep -c "^-" 2>/dev/null);
	let cdirs=$(ls -Al 2>/dev/null | grep -c "^d" 2>/dev/null);
	echo "${cfiles}f ${cdirs}d";
}
export AINFO_BB_FDCOUNT='\[\033[01;33m\]$(AINFO_BB_FDCOUNT_BASIC)\[\033[01;37m\]';

# Git PS1 module
export AINFO_BB_GIT='$(__git_ps1 "\[\033[01;37m\][\[\033[01;35m\]%s \$(__git_ps1_show_sha)\[\033[01;37m\]]")'

# Subshell indicator
if [ $SHLVL -gt 1 ]; then
	export AINFO_BB_SUBSH='\[\033[01;37m\][\[\033[01;31m\]SUB $SHLVL\[\033[01;37m\]]';
else
	export AINFO_BB_SUBSH='';
fi

# IP indicator
if [ -z "$SSH_IP" ]; then
	export AINFO_BB_SSHIP='LOCAL';
else
	export AINFO_BB_SSHIP='$SSH_IP';
fi

# TTY indicator
export AINFO_BB_TTY='${TTY:5}';

# Import additional files here


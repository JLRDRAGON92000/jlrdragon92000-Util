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
export AINFO_BB_EMPTY='\[\e[01;37m\][\[\e[01;37m\]]';

# Basic (user@host, directory, time and date, etc...)
export AINFO_BB_USER='\[\e[01;32m\]${USER}@${HOSTNAME}\[\e[01;37m\]';
export AINFO_BB_ROOT='\[\e[01;31m\]-ROOT-\[\e[01;37m\]';
export AINFO_BB_CWD='\[\e[01;34m\]${debian_chroot:+($debian_chroot) }\w\[\e[01;37m\]';
export AINFO_BB_CWDFULL='\[\e[01;34m\]${debian_chroot:+($debian_chroot) }${PWD}\[\e[01;37m\]';
export AINFO_BB_DATE='\[\e[01;36m\]$(date "+%a %Y-%m-%d %H:%M")\[\e[01;37m\]';

# File/directory counter (Basic, only files and directories)
AINFO_BB_FDCOUNT_BASIC () {
	let cfiles=$(ls -al 2>/dev/null | grep -c "^-" 2>/dev/null);
	let cdirs=$(ls -Al 2>/dev/null | grep -c "^d" 2>/dev/null);
	echo "${cfiles}f ${cdirs}d";
}
export AINFO_BB_FDCOUNT='\[\e[01;33m\]$(AINFO_BB_FDCOUNT_BASIC)\[\e[01;37m\]';

# Git PS1 module
export AINFO_BB_GIT='$(__git_ps1 "\[\e[01;37m\][\[\e[01;35m\]%s \$(__git_ps1_show_sha)\[\e[01;37m\]]")'

# Subshell indicator
if [ $SHLVL -gt 1 ]; then
	export AINFO_BB_SUBSH='\[\e[01;37m\][\[\e[01;31m\]SUB $SHLVL\[\e[01;37m\]]';
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


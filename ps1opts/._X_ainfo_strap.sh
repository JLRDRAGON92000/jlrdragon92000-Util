# ainfo strap (executed each time the prompt is displayed)

if [ $UID -eq 0 ]; then
	# Special conditions for root follow
	if [[ -n "$SSH_CLIENT" && "$PROMPT_SHOW_SSH_UH" == "1" ]] || [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
		# Display username/hostname
		titlebar="[#] \${USER}@\${HOSTNAME} : \w";
		pprefix="\[\e[01;37m\][\[\e[01;31m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
	else
		# Don't display username/hostname (just display [-ROOT-])
		titlebar="[#] \w";
		pprefix="\[\e[01;37m\][\[\e[01;31m\]-ROOT-\[\e[01;37m\]]";
	fi
	export TBDECAL="[#] ";
elif [[ -n "$SSH_CLIENT" && "$PROMPT_SHOW_SSH_UH" == "1" ]] || [ "$PROMPT_SHOW_SSH_UH" == "2" ]; then
	# Display username/hostname
	titlebar="\${USER}@\${HOSTNAME} : \w";
	pprefix="\[\e[01;37m\][\[\e[01;32m\]\${USER}@\${HOSTNAME}\[\e[01;37m\]]";
else
	# Don't display username/hostname
	titlebar="\w";
	pprefix="";
fi
if ! statcheck; then
	# If last command exited with nonzero status, show error in title bar
	titlebar="[E ${pstattmp}] ${titlebar}";
fi

if [ -n "$USE_TITLEBAR" ]; then
	# If titles are allowed, use titlebar and prompt prefix
	titleb="\[\e]0;${titlebar}\a\]${pprefix}";
else
	# Otherwise just use prompt prefix
	titleb="${pprefix}";
fi
export titleb;

# Update git prompt
export AINFO_BB_GIT=$(__git_ps1 "\[\e[01;37m\][\[\e[01;35m\]%s $(__git_ps1_show_sha)\[\e[01;37m\]]");
# Update stat block
if ! statcheck; then
	export AINFO_BB_STAT="\[\e[01;31m\]\$pstattmp\[\e[01;37m\]";
else
	export AINFO_BB_STAT="\$pstattmp";
fi

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

if [ -n "$USE_TITLEBAR" ]; then
	# Set up the show command in titlebar trap
	# (After it's done executing, the trap removes itself, until this sets it again)
	trap 'echo -ne "\e]0;${TBDECAL}${BASH_COMMAND} ...\a"; trap DEBUG;' DEBUG;
fi


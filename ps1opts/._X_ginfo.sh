# WARNING: Not valid as PS1 mode
# WARNING: This file is not intended for use with the PS1 mode system. It is used by the ainfo prompt to set the generic prompt.
export promptcmd='
	PS1="$titleb\[\033[01;37m\][${AINFO_BB_CWD}][${AINFO_BB_FDCOUNT}][${AINFO_BB_DATE}]${AINFO_BB_GIT}\n\[\033[01;37m\]${AINFO_BB_SUBSH:+$AINFO_BB_SUBSH }${AINFO_BB_SSHIP} -> ${AINFO_BB_TTY} [${AINFO_BB_STAT}] #\$HISTCMD \\\$ \[\033[00m\]";';

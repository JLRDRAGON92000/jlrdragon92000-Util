# WARNING: Not valid as PS1 mode
# WARNING: This file is not intended for use with the PS1 mode system. It is used by the ainfo prompt to set the Java info prompt.
AINFO_BB_FDCOUNT_J () {
	if [ -e "./.javaproj.lock" ]; then
		lastbuild_time=$(cut -f1 -d"|" "./.javaproj.lock");
		lastbuild_fil=$(cut -f2 -d"|" "./.javaproj.lock");
		lastbuild_res=$(cut -f3 -d"|" "./.javaproj.lock");
		csrcs=$(ls -a1 2>/dev/null | grep -c "\.java\$");
		cclss=$(ls -a1 2>/dev/null | grep -c "\.class\$");
		cfils=$(ls -al 2>/dev/null | grep -c "^-");
		let cothr="cfils-(csrcs+cclss)";
		cdirs=$(ls -Al 2>/dev/null | grep -c "^d");
		echo -n "\[\e[01;33m\]${csrcs}s ${cclss}c ${cothr}o ${cdirs}d\[\e[01;37m\]][";
	fi;
	if [ "$lastbuild_res" == "SUCCESS" ]; then
		lastbuild_success="SUCCESS";
		lastbuild_failure="";
	else
		lastbuild_success="";
		lastbuild_failure="FAILURE";
	fi;
	echo "\[\e[01;36m\]${lastbuild_time} ${lastbuild_fil} \[\e[01;32m\]${lastbuild_success}\[\e[01;31m\]${lastbuild_failure}\[\e[01;37m\]";
}

export promptcmd='
	PS1="$titleb\[\e[01;37m\][${AINFO_BB_CWD}][$(AINFO_BB_FDCOUNT_J)][${AINFO_BB_DATE}]${AINFO_BB_GIT}\n\[\e[01;37m\]${AINFO_BB_SUBSH:+$AINFO_BB_SUBSH }${AINFO_BB_SSHIP} -> ${AINFO_BB_TTY} [\$pstattmp] \\\$ \[\e[00m\]";
';

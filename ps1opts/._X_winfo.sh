# WARNING: Not valid as PS1 mode
# WARNING: This file is not intended for use with the PS1 mode system. It is used by the ainfo prompt to set the web files prompt. (Which is why you are getting such weird values for the PS1 mode system variables.)
AINFO_BB_FDCOUNT_W () {
	chtml=$(ls -a1 | grep -c "\.html\$");
	ccss=$(ls -a1 | grep -c "\.css\$");
	let cwebf=$chtml+$ccss;
	cphp=$(ls -a1 | grep -c "\.php\$");
	ccgi=$(ls -a1 | grep -c "\.cgi\$");
	cpy=$(ls -a1 | grep -c "\.py[w]{0,1}\$");
	cperl=$(ls -a1 | grep -c "\.pl\$");
	let cscr=$cphp+$ccgi+$cpy+$cperl;
	ishtaccess=$(if [ -e "./.htaccess" ] && (grep "AuthType" "./.htaccess" | grep -qv "None"); then echo "protected "; elif [ -e "./.htaccess" ]; then echo "htaccess "; else echo ""; fi;);
	cfils=$(ls -al | grep -c "^-");
	let cothr=$cfils-$cwebf-$cscr;
	cdirs=$(ls -Al | grep -c "^d");
	echo "\[\e[01;33m\]${cwebf}w ${cscr}s ${cothr}o ${cdirs}d\[\e[01;37m\]";
}

export promptcmd='
	PS1="$titleb\[\e[01;37m\][${AINFO_BB_CWD}][$(AINFO_BB_FDCOUNT_W)][${AINFO_BB_DATE}]${AINFO_BB_GIT}\n\[\e[01;37m\]${AINFO_BB_SUBSH:+$AINFO_BB_SUBSH }${AINFO_BB_SSHIP} -> ${AINFO_BB_TTY} [${AINFO_BB_STAT}] \\\$ \[\e[00m\]";
';


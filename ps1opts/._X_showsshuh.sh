SSHUH_LOCK_FPATH="$PS1M_DIR/._X_sshuh.lock";

# Set sshuh from the lock file when we switch modes
export PROMPT_SHOW_SSH_UH=$(cat "$SSHUH_LOCK_FPATH");

# sshuh - Allows the user to change this from the command line
sshuh () {
	sshuhmod="$1";
	case $sshuhmod in
		always)
			export PROMPT_SHOW_SSH_UH="2";;
		ssh)
			export PROMPT_SHOW_SSH_UH="1";;
		never)
			unset PROMPT_SHOW_SSH_UH;;
		*)
			echo -e "\e[01;31mAvailable options are: always, ssh, never\e[00m";;
	esac
	echo -n "$PROMPT_SHOW_SSH_UH" >$SSHUH_LOCK_FPATH;
}


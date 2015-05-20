jlrdragon92000-Util
===================
A suite of various shell scripts common to all of my development environments.
Also includes methods to edit the scripts and copy them to the user's private bin

If a shell script is specific to the particular environment it resides on, I will not include it on this repository.

### Installation
1. Download its contents to `$HOME/Util`.
2. In `$HOME/.bashrc`, source `$HOME/Util/.emerdefaults.util` and `$HOME/Util/prompt.util` in that order.
3. If it does not exist already, create `$HOME/bin`.
4. Run `$HOME/Util/updutil.util` to copy the Util shell scripts to `$HOME/bin`.

### Adding and editing scripts
For writing new scripts and editing existing ones, I recommend using the `eutil` script included with the download, as it will automatically manage placing the new script into the bin directory.
`eutil`'s default editor can be set by changing the value of the `EUTIL_EDITOR` variable inside of eutil.util.

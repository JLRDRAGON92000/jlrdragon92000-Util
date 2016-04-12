jlrdragon92000-Util
===================
A suite of various shell scripts common to all of my development environments.
Also includes methods to edit the scripts and copy them to the user's private bin

If a shell script is specific to the particular environment it resides on, I will not include it on this repository.

### Installation
1. Download its contents to `$HOME/Util`.
2. `cd $HOME/Util`
3. `./first-time-setup`

### Adding and editing scripts
For writing new scripts and editing existing ones, I recommend using the `eutil` script included with the download, as it will automatically manage placing the new script into the bin directory.
`eutil`'s default editor can be set by changing the value of the `EUTIL_EDITOR` variable inside of eutil.util.

If there are changes you want to make to Util on a single machine, I recommend keeping them in another branch, separate from the master.


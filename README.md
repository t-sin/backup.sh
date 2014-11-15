# backup.sh

some scripts for backing up data.
it runs on both *nix and windows (required MSYS.)

## requirements
required commands of backup.sh is below:

* bash
* rsync
* shasum

## NOTES for Windows
if you use it on Windows, requires MSYS.


---


## usage
### 1. set up
download backup.sh scripts, and edit **backup.conf**.

* **tmp_dir**
it's a directory that temporary files are created at.

* **log**
it's a file that backup log is wrote in.

* **src, dest**
backup.sh do back up all file in **src** directory, to **dest**.
number of elements **src** and **dest** must be *same number*.


#### NOTE for Windows
if you run it on windows, you need installing MSYS.
and, additionally, you need to edit backup-win.bat.

* **BASH_CMD**
it's a path to *bash* command.


### 2. run
run **backup.sh**.

**NOTE**
if you run it on *windows*, run **backup-win.bat**.

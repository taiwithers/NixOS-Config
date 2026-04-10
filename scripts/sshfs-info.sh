#!/usr/bin/env bash

#--------------------------------------------------------------------#
#              Not used as an actual script, just notes              #
#--------------------------------------------------------------------#

echo hi

nixshell sshfs

mkdir mountpoint
sshfs [user@]hostname:[directory] mountpoint

# do stuff

fusermount -u mountpoint
rmdir mountpoint

#!/bin/bash
# Written by Max.Chudnovsky
# script cleans up directory from files older then number of days as long files not locked by process

#FUNC
usage(){
        echo "  usage:  $0 <dir> <days>"
}
cleanup(){
        # before removing a file, make sure its not locked by process
        [ "$(fuser $id 2>/dev/null | cut -d ' ' -f 2)" = "" ] && {
                rm -rf $id
        }
}

#INIT
# lets check arguments for obvious issues and set our vars
[ "$#" != 2 ] && {
        echo "$0: ERROR.  Missing argument."
        usage
        exit
}
[ ! -d "$1" ] && {
        echo "$0: ERROR.  Directory $1 does not exist."
        usage
        exit
}
[[ ! "$2"  =~ ^[0-9]+$ ]] && {
        echo "$0: ERROR.  Number of days set to $2.  They are supposed to be a number."
        usage
        exit
}
DIR="$1"
DAYS="$2"

#MAIN
# lets find list of files and do clean up on them
cd "$DIR"
LIST="$(find . -depth -maxdepth 1 -mtime +"$DAYS" | sort)"

echo -e "Cleaning up ${DIR}.\nFound $(echo "$LIST" | wc -l) files.\nDelete files that are not locked by processes."

for id in $LIST; do
        cleanup $id
done

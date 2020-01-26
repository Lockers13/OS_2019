#!/bin/bash

read_input() {
    read input
    if [ "$input" == 'n' ]; then
        exit 0
    elif [ "$input" == 'y' ]; then
        if [ ! -d "$1" ]; then
            echo "Error: User $1 does not exist"
            exit 2
        else
            rm -r "$1"
            echo "OK: User $1 was removed successfully"
        fi
    else
        echo "Please enter only either 'y' or 'n'"
        read_input "$1"
    fi
}



if [ ! "$#" -eq 1 ]; then
    echo "Error: problem with parameters."
    exit 1
fi
 

user="$1"
echo "del_user.sh will remove all directories and files associated with $user"
echo "Are you sure you wish to continue? - y/n"
read_input "$user"


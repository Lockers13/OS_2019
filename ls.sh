#!/bin/bash

lock_dir="lock_dir"

check_user() {
    if [ ! -d "$1" ]; then
        if [ ! -f "$1" ]; then
            echo "Error: User $1 does not exist"
	    rmdir "$lock_dir">/dev/null
            exit 2
	else
	    echo "$1 is a file path"
	    rmdir "$lock_dir" 2>/dev/null
	    exit 5
	fi
    fi
}

check_folder() {
    if [ ! -d "$1/$2" ]; then
        echo "Error: Folder $1/$2 does not exist or is not a folder"
	rmdir "$lock_dir" 2>/dev/null
        exit 2
    fi
}

if [ "$#" -lt 1  ] || [ "$#" -gt 2  ]; then
    echo "Error: parameters problem"
    exit 1
fi


if [ "$#" -eq 1 ]; then
    user="$1"
    while true
    do
    if mkdir "$lock_dir" 2> /dev/null; then
        break
    fi
    sleep .05
    done
    
    check_user "$user"
    echo "OK: "
    tree "$user"
    rmdir "$lock_dir" 2>/dev/null	
elif [ "$#" -eq 2 ]; then
    user="$1"
    folder="$2"
    while true
    do
    if mkdir "$lock_dir" 2> /dev/null; then
        break
    fi
    sleep .05
    done

    check_user "$user"    
    check_folder "$user" "$folder"
    echo "OK: "
    tree "$1/$2"
    rmdir "$lock_dir" 2> /dev/null
fi


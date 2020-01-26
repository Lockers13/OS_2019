#!/bin/bash

lock_dir="lock_dir"
user="$1"


if [ ! "$#" -eq 1 ]; then
 echo "Error: parameters problem"
 exit 1
fi


while true
do
    if mkdir "$lock_dir" 2> /dev/null; then
        break
    fi
    sleep .05
done
if [ -d "./$user" ]; then
 echo "Error: User $1 already exists!"
 rmdir "$lock_dir" 2>/dev/null
 exit 2
fi
mkdir "./$user"
echo "OK: User $user has been successfully created"

rmdir "$lock_dir" 2>/dev/null

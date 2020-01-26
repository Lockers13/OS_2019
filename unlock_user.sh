#!/bin/bash

username="$1"
if [ ! "$#" -eq 1 ]; then
    echo "Error: parameter problem"
    exit 1
fi
if [ ! "$(grep "$username" lock_pwords.txt | wc -l)" -eq 1 ]; then
    echo "User: $username is not locked"
    exit 1
else
    read -p "Please enter global password: " password
    hashed_pword="$(perl -e "print crypt("$password", 'll');")"
    hash_cut=$(grep "$username" lock_pwords.txt | cut -d':' -f2)
    if [ "$hashed_pword" == "$hash_cut" ]; then
	for i in $(find "./$username" -type f -name '*'); do chmod u+r "$i"; done
	echo "OK: user $username unlocked"
	while read -r line
	do
  	    [[ ! "$line" == *"$username"* ]] && echo "$line"
	done <lock_pwords.txt > o
	mv o lock_pwords.txt
    else
	echo "Sorry: password is incorrect"
	exit 2
    fi
fi


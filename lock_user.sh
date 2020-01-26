#!/bin/bash
username="$1"
if [ `grep "$username" lock_pwords.txt | wc -l` -eq 0 ]; then
    read -p "Please enter global password (you must remember this password, it will not be stored on disk): " password
    hashed_pword=`perl -e "print crypt($password, 'll')"`
    printf "$username:$hashed_pword\n" >> lock_pwords.txt
    for i in `find "./$username" -type f -name '*'`; do chmod u-r $i; done
    echo "OK: user $username locked"
else
    echo "User: $username has already been locked"
    exit 5
fi
 

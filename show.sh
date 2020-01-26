#!/bin/bash

lock_dir="lock_dir"
user="$1"
service="$2"

if [ ! "$#" -eq 2 ]; then
 echo "Error: parameters problem"
 exit 1
fi

while true
do
    if mkdir "$lock_dir" 2> /dev/null; then
        break;
    fi
    sleep .05
done

if [ ! -d "$user" ]; then
 echo "Error: User $user does not exist"
 rmdir "$lock_dir" 2>/dev/null
 exit 2
elif [ ! -f "$user/$service" ]; then
 if [ -d "$user/$service" ]; then
  echo "$user/$service is a folder: consider refining your search"
  echo
  tree "$user/$service"
  rmdir "$lock_dir" 2>/dev/null
  exit 3
 else
  echo "Error: Service $service does not exist"
  rmdir "$lock_dir" 2>/dev/null
  exit 4
 fi
fi

cat "$user/$service"
sleep .5
echo ""
rmdir "$lock_dir" 2> /dev/null

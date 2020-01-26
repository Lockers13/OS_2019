#!/bin/bash

lock_dir="lock_dir"

check_user() {
    if [ ! -d "$1" ]; then
        echo "Error: User $1 does not exist"
	rmdir "$lock_dir" 2>/dev/null
        exit 2
    fi
}
check_service_del() {
    if [ ! -f "$1/$2" -a ! -d "$1/$2" ]; then
        echo "Error: Service $service does not exist"
	rmdir "$lock_dir" >/dev/null
        exit 3
    fi
}


if [ ! "$#" -eq 2 ]; then
	echo "Error: parameter problem"
	exit 1
fi

user="$1"
service="$2"

while true
do
    if mkdir "$lock_dir" 2> /dev/null; then
        break
    fi
    sleep .05
done

check_user "$user"
check_service_del "$user" "$service"

if [ -d "$user/$service" ]; then
        rm -r "$user/$service"
elif [ -f "$user/$service" ]; then
	rm "$user/$service"
fi
echo "OK: Service $service Removed"
rmdir "$lock_dir" 2>/dev/null

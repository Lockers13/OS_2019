#!/bin/bash

lock_dir="lock_dir"

touchy() {
        mkdir -p "$(dirname "$1")" && printf "$2" > "$1"
}

check_user() {
    if [ ! -d "$1" ]; then
        echo "Error: User $1 does not exist"
	rmdir "$lock_dir" 2>/dev/null
        exit 2
    fi
}
check_service() {
    if [ -f "$1/$2" ] || [ -d "$1/$2" ]; then
        echo "Error: Service $2 already exists"
	rmdir "$lock_dir" 2>/dev/null
        exit 3
    fi
}


if [ "$#" -eq 3 ]; then
    user="$1"
    service="$2"
    payload="$3"
    while true
    do
        if mkdir "$lock_dir" 2> /dev/null; then
            break
        fi
        sleep .05
    done
    check_user "$user"
    check_service "$user" "$service"
    touchy "$user/$service" "$payload" 
    echo "OK: service created"
    rmdir "$lock_dir" 2> /dev/null
elif [ "$#" -eq 4 ]; then
    user="$1"
    service="$2"
    update="$3"
    payload="$4"
    while true
    do
        if mkdir "$lock_dir" 2> /dev/null; then
            break
        fi
        sleep .05
    done
    if [ "$update" == "f" ]; then
        check_user "$user"
	check_service "$user/$service" 
	if [ ! -f "$user/$service" ]; then
	    new_serv=1
	else
	    new_serv=0
	fi
	touchy "$user/$service" "$payload" 

	if [ "$new_serv" -eq 1 ]; then
	    echo "OK: service created"
	else
            echo "OK: service updated"
	fi
    elif [ "$update" == "" ]; then
        check_user "$user"
        check_service "$user" "$service"
        touchy "$user/$service" "$payload" 
        echo "OK: service created"
    else
	echo "Error: parameters problem"
    fi
    rmdir "$lock_dir" 2> /dev/null
else
    echo "Error: parameters problem"
    exit 1
fi


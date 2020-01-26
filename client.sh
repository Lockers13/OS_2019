



#!/bin/bash

get_response() {
        read response < "${client_id}.pipe"
        while [ "$?" -eq 0 ]
        do
            echo "$response"
            read response < "${client_id}.pipe"
        done 
        rm "${client_id}.pipe"
} 

int_unlock() {
	trap SIGINT
	rmdir lock_dir 2>/dev/null
	rm "${client_id}.pipe" 2>/dev/null
	echo "process $$ interrupted: $lock_dir and ${client_id}.pipe removed"
	exit
}

trap "int_unlock" INT

rmdir lock_dir 2>/dev/null
extra=""


if [ "$#" -lt 2 ]; then
 echo "Error: insufficient number of parameters"
 exit 1
fi

client_id="$1"
command="$2"
mkfifo "${client_id}.pipe" 2>/dev/null
case "$command" in
init)
	if [ ! "$#" -eq 3 ]; then
	    echo "Error: parameter problem"
	    rm "${client_id}.pipe" 2>/dev/null
	    exit 1
	else
	    username="$3"
	    echo "$client_id $command $username" >  server.pipe
	fi
	;;
insert)
	if [ ! "$#" -eq 4 ]; then
	    echo "Error: parameter problem"
            rm "${client_id}.pipe"
	    exit 1
	else 
	    username="$3"
	    service="$4"
	    read -p "Please enter login: " login
	    read -p "Please enter password: " password
	    payload="login: $login\npassword: $password"
	    echo "$client_id $command $username $service $payload" > server.pipe  
	fi
	;;
show)
	if [ ! "$#" -eq 4 ]; then
	    echo "Error: parameter problem"
            rm "${client_id}.pipe"
	    exit 1
	else
	    username="$3"
	    service="$4"
	    echo "$client_id $command $username $service" > server.pipe
	fi
	;;
edit)
	if [ ! "$#" -eq 4 ]; then
	    echo "Error: parameter problem"
	    rm "${client_id}.pipe"
	    exit 1
	else
	    username="$3"
	    service="$4"
	    echo "$client_id show $username $service" > server.pipe
	    read edit_resp < "${client_id}.pipe"
	    edit_resp+='\n'
	    while [ "$?" -eq 0 ]
	    do
		edit_resp+="$extra"
	        read extra < "${client_id}.pipe"
	    done
	    if [[ "$edit_resp" == *"Permission"* ]] || [[ "$edit_resp" == *"Error"* ]] || [[ "$edit_resp" == *"parameter"* ]]; then 
	        echo -e "$edit_resp"
                exit 1
	    else
		if [ ! -d "$username" ]; then
		    echo "Error: user  $username does not exist"
		    exit 1
		fi
	        touch edit.temp
		echo -e "$edit_resp" > edit.temp
		nano edit.temp
		sleep 1
		new_edit=`sed '1q;d' edit.temp`
                new_edit+='\n'
		new_edit+=`sed '2q;d' edit.temp`
		echo "$client_id update $username $service $new_edit" > server.pipe		
		sleep .5
	 	rm edit.temp
	    fi
	fi
	;;
rm)
	if [ ! "$#" -eq 4 ]; then
	    echo "Error: parameter problem"
	    rm "${client_id}.pipe"
            exit 1
	else
	    username="$3"
	    service="$4"
	    echo "$client_id $command $username $service" > server.pipe
	fi
	;;
shutdown)
	if [ ! "$#" -eq 2 ];then
	    echo "Error:parameter problem"
	    rm "${client_id}.pipe"
            exit 1
	else
	    echo "$client_id $command" > server.pipe
	fi
	;;
*)
	echo "$client_id $command" > server.pipe
	;;
esac
get_response 


trap SIGINT


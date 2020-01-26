

#!/bin/bash

int_unlock() {
        trap SIGINT
        rm "server.pipe" 2>/dev/null
        echo "Server process $$ interrupted: server.pipe removed"
        exit
}

trap "int_unlock" INT



while true
do
mkfifo server.pipe 2>/dev/null
read -r client com user service logpass < server.pipe

client_pipe="${client}.pipe"
    case "$com" in
    init)
	./init.sh "$user" >& "$client_pipe" &
        ;;
    insert)
        ./insert.sh "$user" "$service" "$logpass" >& "$client_pipe" &
        ;;
    show)
        ./show.sh "$user" "$service" >& "$client_pipe" &
        ;;
    update)
        ./insert.sh "$user" "$service" f "$logpass" >& "$client_pipe" &
        ;;
    rm)
        ./rm.sh "$user" "$service" >& "$client_pipe" &
        ;;
    ls)
        ./ls.sh "$user" "$service" >& "$client_pipe" &
        ;;
    shutdown)
        echo "Server shutting down..." > "$client_pipe" &
	rm lock_dir 2>/dev/null
	rm server.pipe
	exit 0
        ;;
    *)
        echo "Error: bad request" > "$client_pipe" &
        ;;
    esac

rm server.pipe 2>/dev/null
done


trap SIGINT

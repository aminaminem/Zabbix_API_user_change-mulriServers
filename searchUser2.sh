#!/bin/bash

CURL_JASON='Content-Type: application/json'
ZABBIX_SERVERS="zabbixservers.txt"
USER_NAME="AllUserDeletePrevention"

while getopts u: flag
do
    case "${flag}" in
        u) USER_NAME=${OPTARG};;
    esac
done

echo
echo
echo '======================================================='
echo ' _   _               _____                     _     '
echo '| | | |             /  ___|                   | |    '
echo '| | | |___  ___ _ __\ `--.  ___  __ _ _ __ ___| |__  '
echo '| | | / __|/ _ \ .__|`--. \/ _ \/ _` |  __/ __|  _ \ '
echo '| |_| \__ \  __/ |  /\__/ /  __/ (_| | | | (__| | | |'
echo ' \___/|___/\___|_|  \____/ \___|\__,_|_|  \___|_| |_|'
echo '======================================================='
echo
echo

while IFS= read -r line
do
	ZABBIX_URL=( $(echo "$line" | sed 's/,.*//') )
	ZABBIX_TOKEN=( $(echo "$line"  | sed 's/.*,//') )

#JSON Function for user name get :
USER_NAME_GET='{
    "jsonrpc": "2.0",
    "method": "user.get",
    "params":{
        "search": {
            "username": "'$USER_NAME'"
        		},
        "output": ["username"]
    },
    "auth": "'$ZABBIX_TOKEN'",
    "id": 1
}'

#these commands serach and show a user from part of username/name/surname :
	echo "Searching for username: <<"$USER_NAME">> on zabbix server: <<"$ZABBIX_URL">>"
	ZABBIX_URL=$ZABBIX_URL"/api_jsonrpc.php"
	curl -i -X POST -H "$CURL_JASON" -d "$USER_NAME_GET" $ZABBIX_URL 2>&1 | grep result | jq '.' | grep username
	echo
done < "$ZABBIX_SERVERS"
echo
echo

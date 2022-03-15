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
echo '=============================================='
echo ' _   _              ______     _      _       '
echo '| | | |             |  _  \   | |    | |      '
echo '| | | |___  ___ _ __| | | |___| | ___| |_ ___ '
echo '| | | / __|/ _ \  __| | | / _ \ |/ _ \ __/ _ \'
echo '| |_| \__ \  __/ |  | |/ /  __/ |  __/ ||  __/'
echo ' \___/|___/\___|_|  |___/ \___|_|\___|\__\___|'
echo '=============================================='
echo
echo

#this part reas Zabbix servers/tokens file
#file format must be like this :
#[ZABBIX Server URL(without /api_jsonrpc.php)],[TOKEN]
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

#JSON Function for user ID get :
USER_ID_GET='{
    "jsonrpc": "2.0",
    "method": "user.get",
    "params":{
        "search": {
            "username": "'$USER_NAME'"
        		},
        "output": ["userid"]
    },
    "auth": "'$ZABBIX_TOKEN'",
    "id": 1
}'


	echo "Deleting user/s: <<"$USER_NAME">> on zabbix server: <<"$ZABBIX_URL">>"
	ZABBIX_URL=$ZABBIX_URL"/api_jsonrpc.php"
	USERIDs_DELETE=( $(curl -i -X POST -H "$CURL_JASON" -d "$USER_ID_GET" $ZABBIX_URL 2>&1 | grep result |  jq '.result|map(.userid)' ))
	USERIDs_DELETE="${USERIDs_DELETE[@]}"

#JSON Function for user name Delete :
USER_NAME_DELETE='{
    "jsonrpc": "2.0",
	"method": "user.delete",
    "params":
    '$USERIDs_DELETE',
    "auth": "'$ZABBIX_TOKEN'",
    "id": 1
}'

#these commands show and delete searched user/s
	curl -i -X POST -H "$CURL_JASON" -d "$USER_NAME_GET" $ZABBIX_URL 2>&1 | grep result | jq '.' | grep username
	curl -s -X POST -H "$CURL_JASON" -d "$USER_NAME_DELETE" $ZABBIX_URL
	echo
done < "$ZABBIX_SERVERS"
echo
echo

# off-boarding scripts
# Zabbix_API_user_change-mulriServers

This Script is for search and delete user/s in multi servers
there is two different script for this job : 

searchUser2.sh :
this script search user by part of it's username,name,surname ,then show all related username in all server/s

deleteUser2.sh :
this script search and delete user/s by part of it's username,name,surname ,then show and delete all related username in all server/s


both of script need a file "zabbixservers.txt" for access to servers.
this file must include Zabbix servers URL and token with this format :
[ZABBIX Server URL(full API URL without '/api_jsonrpc.php)'],[API_TOKEN]

zabbixservers.txt sample data :
```http://test-frontend1.net,b375e3e0cf8adaea84c1c66f826435e5
http://test-frontend2.net,b375e3e0cf8adaea84c1c66f826435e5
http://test-frontend3.net,b375e3e0cf8adaea84c1c66f826435e5
```

for both script need to pass username(full or part of it) by -u switch ,for example :
```./searchUser2.sh -u "smith"
./deleteUser2.sh -u "smith"
```



sample output  for searchUser2 :
```% ./searchUser2.sh -u power


=======================================================
 _   _               _____                     _     
| | | |             /  ___|                   | |    
| | | |___  ___ _ __\ `--.  ___  __ _ _ __ ___| |__  
| | | / __|/ _ \ .__|`--. \/ _ \/ _` |  __/ __|  _ \ 
| |_| \__ \  __/ |  /\__/ /  __/ (_| | | | (__| | | |
 \___/|___/\___|_|  \____/ \___|\__,_|_|  \___|_| |_|
=======================================================


Searching for username: <<power>> on zabbix server: <<http://192.168.0.77>>
      "username": "Bob Power",
      "username": "Max power",
      "username": "m_power",
``` 
      
      
      
      
      
      
      
sample output  for deleteUser2 :
```% ./deleteUser2.sh -u "power"


==============================================
 _   _              ______     _      _       
| | | |             |  _  \   | |    | |      
| | | |___  ___ _ __| | | |___| | ___| |_ ___ 
| | | / __|/ _ \  __| | | / _ \ |/ _ \ __/ _ \
| |_| \__ \  __/ |  | |/ /  __/ |  __/ ||  __/
 \___/|___/\___|_|  |___/ \___|_|\___|\__\___|
==============================================


Deleting user/s: <<power>> on zabbix server: <<http://192.168.0.77>>
      "username": "Max power"
      "username": "m_power"
```

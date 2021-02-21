#!/usr/bin/env bash

# AUTHOR:   Steve Ward [steve at tech-otaku dot com]
# URL:      https://github.com/tech-otaku/start-mamp-servers.git
# README:   https://github.com/tech-otaku/start-mamp-servers/blob/main/README.md

# USAGE:    ./start-mamp-servers.sh -k KEY_CHAIN_ITEM
# EXAMPLE:  ./start-mamp-servers.sh -k "MAMP"

if ! security find-generic-password -l "$1" > /dev/null 2>&1; then
    printf "ERROR: Can't find password for service '%s'.\n" "$1"
    exit 1
fi

USERNAME=$(security find-generic-password -l "$1" | grep "acct" | cut -d '=' -f2 | tr -d \")
PASSWORD=$(security find-generic-password -wl "$1")

WEB_SERVER=$(defaults read de.appsolute.MAMP selectedServer)

if [ $WEB_SERVER -eq 5 ]; then
    # Apache
    WEB_SERVER_PORT=$(defaults read de.appsolute.MAMP apachePort)
elif [ $WEB_SERVER -eq 6 ]; then
    # Nginx
    WEB_SERVER_PORT=$(defaults read de.appsolute.MAMP nginxPort)
fi 


if [ $WEB_SERVER -eq 5 ]; then
    if [[ $(ps -acwx -o command | grep -ix httpd || echo false) == *"false"* ]]; then
        if [ $WEB_SERVER_PORT -lt 1024 ]; then
            osascript -e "do shell script \"sudo /Applications/MAMP/bin/startApache.sh &\" user name \"$USERNAME\" password \"$PASSWORD\" with administrator privileges" > /dev/null 2>&1
        else
            /Applications/MAMP/bin/startApache.sh
        fi
        echo "Apache (httpd) is listening on port $WEB_SERVER_PORT."
    else
        echo "ERROR: Apache (httpd) is already running on port $(lsof -i -n -P | grep httpd | grep "(LISTEN)" | head -1 | cut -d ':' -f 2 |  cut -d ' ' -f 1)."
#        exit 1
    fi
fi

if [ $WEB_SERVER -eq 6 ]; then
    if [[ $(ps -acwx -o command | grep -ix nginx || echo false) == *"false"* ]]; then
        if [ $WEB_SERVER_PORT -lt 1024 ]; then
            osascript -e "do shell script \"sudo /Applications/MAMP/bin/startNginx.sh &\" user name \"$USERNAME\" password \"$PASSWORD\" with administrator privileges" > /dev/null 2>&1
        else
            /Applications/MAMP/bin/startNginx.sh
        fi
        echo "Nginx (nginx) is listening on port $WEB_SERVER_PORT."
    else
        echo "ERROR: Nginx (nginx) is already running on port $(lsof -i -n -P | grep nginx | grep "(LISTEN)" | head -1 | cut -d ':' -f 2 |  cut -d ' ' -f 1)."
#        exit 1
    fi
fi

MYSQL_SERVER_PORT=$(defaults read de.appsolute.MAMP mySqlPort)

if [[ $(ps -acwx -o command | grep -ix mysqld || echo false) == *"false"* ]]; then
    if [ $MYSQL_SERVER_PORT -lt 1024 ]; then
        osascript -e "do shell script \"sudo /Applications/MAMP/bin/startMySQL.sh &\" user name \"$USERNAME\" password \"$PASSWORD\" with administrator privileges" > /dev/null 2>&1
    else
        /Applications/MAMP/bin/startMysql.sh > /dev/null 2>&1
    fi
    echo "MySQL (mysqld) is listening on port $MYSQL_SERVER_PORT."
else
    echo "ERROR: MySQL is already running on port $(lsof -i -n -P | grep mysqld | grep "(LISTEN)" | head -1 | cut -d ':' -f 2 |  cut -d ' ' -f 1)."
#    exit 1
fi



#echo $WEB_SERVER
#echo $WEB_SERVER_PORT
#echo $MYSQL_PORT
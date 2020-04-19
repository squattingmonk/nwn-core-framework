# NB - you will need to Unixify the line endings of this file. 
# Test server setup instructions.
# Assumes the server home location is /nwn/server.
# Tested by:
# - installing Oracle VirtualBox
# - creating a new Debian VM with default settings.
# - configuring the VM to boot from debian-9.4.0-amd64-netinst (downloaded from Debian-cd)
# - configuring the VM network to map TCP port 22 on host to TCP port 22 on guest
# - configuring the VM network to map UDP port 5121 on host to UDP port 5121 on guest
# - installing a basic Debian install with no GUI, just SSH server and command line
# - creating /nwn/server and subdirectories modules, override, hak and tlk with relevant files
# - installing MariaDB (MySQL): apt-get -y install mariadb-server mariadb-client
# - configuring the database as follows
#   - mysql
#   - create user 'YOUR_DB_USER'@'localhost' identified by 'YOUR_DB_PASSWORD'; [same PW below]
#   - create database YOUR_DB;
#   - grant all privileges on YOUR_DB.* to 'YOUR_DB_USER'@'localhost'
#   - \q
#   - mysql YOUR_DB < schema_mysql.sql
# - installing ruby/rubygems: apt-get install ruby
# - installing the NWN library for ruby: gem install nwn-lib (may take a while)
# NOTE: need to get this working within the container!
# - installing Docker CE (https://docs.docker.com/install/linux/docker-ce/debian/)
# - running the script below to start the server. 
#
# - Other useful utilities
#   - apt-get install dos2unix (for converting dos line endings to unix)
#   - apt-get install php php-mbstring php-xml php-mysql(for running PHP enabled websites)
#  Hey there ho there
cd /home/nwn/server
sudo docker stop DarkSunNWN
sudo docker rm DarkSunNWN
sudo docker run --restart unless-stopped -dit \
    --net host -e NWN_PORT=5121 \
    --name DarkSunNWN \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE='ds-core-framework' \
    -e NWN_PUBLICSERVER=1 \
    -e NWN_SERVERNAME='Dark Sun Development' \
    -e NWN_PLAYERPASSWORD='r' \
    -e NWN_DMPASSWORD='r' \
    -e NWN_ELC=0 \
    -e NWN_ILR=0 \
    -e NWN_MAXLEVEL=40 \
    -e NWN_GAMETYPE=10 \
    -e NWN_PAUSEANDPLAY=0 \
    -e NWNX_ADMINISTRATION_SKIP=y \
    -e NWNX_APPEARANCE_SKIP=y \
    -e NWNX_AREA_SKIP=y \
    -e NWNX_CHAT_SKIP=y \
    -e NWNX_COMBATMODES_SKIP=y \
    -e NWNX_CREATURE_SKIP=y \
    -e NWNX_DAMAGE_SKIP=y \
    -e NWNX_DATA_SKIP=y \
    -e NWNX_DIALOG_SKIP=y \
    -e NWNX_DOTNET_SKIP=y \
    -e NWNX_ELC_SKIP=y \
    -e NWNX_EFFECT_SKIP=y \
    -e NWNX_ENCOUNTER_SKIP=y \
    -e NWNX_EVENTS_SKIP=y \
    -e NWNX_FEEDBACK_SKIP=y \
    -e NWNX_ITEM_SKIP=y \
    -e NWNX_ITEMPROPERTY_SKIP=y \
    -e NWNX_MAXLEVEL_SKIP=y \
    -e NWNX_METRICS_INFLUXDB_SKIP=y \
    -e NWNX_OBJECT_SKIP=y \
    -e NWNX_OPTIMIZATIONS_SKIP=y \
    -e NWNX_PLAYER_SKIP=y \
    -e NWNX_PROFILER_SKIP=y \
    -e NWNX_RACE_SKIP=y \
    -e NWNX_REDIS_SKIP=y \
    -e NWNX_RENAME_SKIP=y \
    -e NWNX_SQL_SKIP=n \
    -e NWNX_SERVERLOGREDIRECTOR_SKIP=y \
    -e NWNX_SKILLRANKS_SKIP=y \
    -e NWNX_SPELLCHECKER_SKIP=y \
    -e NWNX_THREADWATCHDOG_SKIP=y \
    -e NWNX_TIME_SKIP=y \
    -e NWNX_TRACKING_SKIP=y \
    -e NWNX_TWEAKS_SKIP=y \
    -e NWNX_UTIL_SKIP=y \
    -e NWNX_VISIBILITY_SKIP=y \
    -e NWNX_WEBHOOK_SKIP=y \
    -e NWNX_EVENTS_SKIP=y \
    -e NWNX_EVENTS_SKIP=y \
    -e NWNX_SQL_TYPE=SQLITE \
    -e NWNX_SQL_HOST=localhost \
    -e NWNX_SQL_DATABASE=core_framework \
    -e NWNX_SQL_QUERY_METRICS=true \
    -e NWNX_CORE_LOG_LEVEL=6 \
    nwnxee/unified:latest


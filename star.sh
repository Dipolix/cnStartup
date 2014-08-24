#!/bin/bash 

# Name of server SCREEN
	SCREENNAME=SERVER
	PORT=00000
	
# RAM SETTINGS
	MINRAM=8G
	MAXRAM=10G
	PERMGEN=768m
	
# SERVER JAR FILE and PATH to server dir
	SERVERJAR='server.jar'
	SERVERPATH='/home/admin/servers/server'
	
# SERVER LOG DIRECTORIES
	LOGDIRMAIN="$SERVERPATH/cnLogs"
	LOGDIRMC="$LOGDIRMAIN/minecraft"
	LOGDIRFORGE="$LOGDIRMAIN/forge"
	
# SERVER LOG FILES
	MINECRAFTLOG="$SERVERPATH/server.log"
	FORGELOG0="$SERVERPATH/ForgeModLoader-server-0.log"
	FORGELOG1="$SERVERPATH/ForgeModLoader-server-1.log"
	FORGELOG2="$SERVERPATH/ForgeModLoader-server-2.log"
	
# MC JAVA parameters
JAVAPARAM="java -Xmx${MAXRAM} -Xms${MINRAM} -XX:PermSize=${PERMGEN} \
-XX:NewRatio=3 \
-XX:SurvivorRatio=3 \
-XX:TargetSurvivorRatio=80 \
-XX:MaxTenuringThreshold=8 \
-XX:+UseParNewGC \
-XX:+UseConcMarkSweepGC \
-XX:MaxGCPauseMillis=10 \
-XX:GCPauseIntervalMillis=50 \
-XX:MaxGCMinorPauseMillis=7 \
-XX:+ExplicitGCInvokesConcurrent \
-XX:+UseCMSInitiatingOccupancyOnly \
-XX:CMSInitiatingOccupancyFraction=60 \
-XX:+BindGCTaskThreadsToCPUs \
-jar $SERVERJAR nogui"

# log directories
log_dir() {
	# create main log directory if it does not exists
	if [ ! -d "$LOGDIRMAIN" ]; then
		bash -c "mkdir -p $LOGDIRMAIN"
		echo -e "\e[92m\e[1m Created new LOG directory @ $LOGDIRMAIN"
		sleep 1
	fi
	# create minecraft log directory if it does not exists
	if [ ! -d "$LOGDIRMC" ]; then
		bash -c "mkdir -p $LOGDIRMC"
		echo -e "\e[92m\e[1m Created new LOG directory @ $LOGDIRMC"
		sleep 1
	fi
	# create forge log directory if it does not exists
	if [ ! -d "$LOGDIRFORGE" ]; then
		bash -c "mkdir -p $LOGDIRFORGE"
		echo -e "\e[92m\e[1m Created new LOG directory @ $LOGDIRFORGE"
		sleep 1
	fi
}

# archive server.log
archive_log() {
	# get current date - time for naming of log files
	TIME=`date +"%b-%d-%y--%T"`
	
	# archive minecraft log file and empty the original
	bash -c "cp $MINECRAFTLOG $LOGDIRMC/$SCREENNAME-MC-$TIME.log"
	echo -n "" > $MINECRAFTLOG
	echo -e "\e[92m\e[1m LOG backup done for $MINECRAFTLOG  \e[0m"
	sleep 1
	
	# archive forge1 log file and empty the original
	bash -c "cp $FORGELOG0 $LOGDIRFORGE/$SCREENNAME-Forge0-$TIME.log"
	echo -n "" > $FORGELOG0
	echo -e "\e[92m\e[1m LOG backup done for $FORGELOG0  \e[0m"
	sleep 1
	
	# archive forge2 log file and empty the original
	bash -c "cp $FORGELOG1 $LOGDIRFORGE/$SCREENNAME-Forge1-$TIME.log"
	echo -n "" > $FORGELOG1
	echo -e "\e[92m\e[1m LOG backup done for $FORGELOG1  \e[0m"
	sleep 1
	
	# archive forge3 log file and empty the original
	bash -c "cp $FORGELOG2 $LOGDIRFORGE/$SCREENNAME-Forge2-$TIME.log"
	echo -n "" > $FORGELOG2
	echo -e "\e[92m\e[1m LOG backup done for $FORGELOG2  \e[0m"
	sleep 1
}

# header
build_header() {
	echo -e "\e[0m"
	echo -e "\e[36m\e[1m=================================================================\e[0m"
	echo -e "\e[0m"
	echo -e " \e[93mServer name	:\e[96m\e[1m $SCREENNAME @ $PORT \e[0m"
	echo -e " \e[93mMin ram        :\e[96m\e[1m $MINRAM \e[0m"
	echo -e " \e[93mMax ram        :\e[96m\e[1m $MAXRAM \e[0m"
	echo -e " \e[93mPermSize	:\e[96m\e[1m $PERMGEN \e[0m"
	echo -e " \e[93mServerPath	:\e[96m\e[1m $SERVERPATH \e[0m"
	echo -e "\e[0m"
	echo -e " \e[97mstep 1] 00 sec :\e[92m\e[1m Archive server.log \e[0m"
	echo -e " \e[97mstep 2] 15 sec :\e[92m\e[1m Old session gets terminated \e[0m"
	echo -e " \e[97mstep 3] 20 sec :\e[92m\e[1m New session + server boot \e[0m"
	echo -e " \e[97mstep 4] XXXXXX :\e[92m\e[1m Server running \e[0m"
	echo -e " \e[97mstep 5] 20 sec :\e[92m\e[1m Wait before returning to step 1 \e[0m"
	echo -e "\e[0m"
	echo -e " \e[31mCraftNetwork | Start/Restart script | Version: 1.0 \e[0m"
	echo -e "\e[0m"
	echo -e "\e[36m\e[1m=================================================================\e[0m"
	echo -e "\e[0m"
}

while true
	do
		# server / script info
		echo -e "\e[0m"
		build_header
		sleep 1
		
		# test for all log directories
		log_dir
		
		# archive all server log files
		archive_log
		
		# kill process on PORT
		# echo -e "\e[0m"
		# echo -e "\e[97m\e[1m=> Terminating old $SCREENNAME session!  \e[0m"
		# 
		# 	bash -c "kill -15 $( lsof -i:${PORT} -t )"
		# 
		# echo -e "\e[97m\e[1m=> Waiting 10 seconds!  \e[0m"
		# echo -e "\e[0m"
		# sleep 10
		
		# countdown for server start
		for i in 16 14 12 10 8 6 4 2
		do
			echo -e "\e[96m\e[1m Starting server $SCREENNAME in $i seconds! \e[0m"
			sleep 2
		done	
		
		# start server
		echo -e "\e[0m"
		echo -e "\e[97m\e[1m=> Booting up $SCREENNAME server! \e[0m"
		
			bash -c "cd $SERVERPATH && $JAVAPARAM"
						
		# wait before restarting server 
		for i in 30 25 20 15 10 5
		do
			echo -e "\e[93m\e[1m Session restart in $i seconds! \e[31m[ use CTRL+C to force terminate $SCREENNAME server ] \e[0m"
			sleep 5
		done
done
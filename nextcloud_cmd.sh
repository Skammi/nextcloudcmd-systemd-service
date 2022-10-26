#!/bin/bash
#
# file:		~/.nextcloud/nextcloud_cmd.sh
# host:		a.example.com
# testhost:	a.example.com
#
# date		version	comment
# ----		-------	-------
# 221017	v005	Added Variables to simplify change
# 221016	v004	Added trap of sigint
# 221016	v003	Added loop with sleep time
# 221016	v002	Added test on running instance
# 221015	v001	First version from man nextcloudcmd info
#
# Activity	Done	Date
# --------	----	----
# Last edit	jacob	221017 16:54
# Tested	jacob	221017 16:59
#
# Purpose:	This script is called by the nextcloudsync service to start nextcloudcmd
#
###

ME=`basename "$0"`

NC_USERCMD_DIR="/home/[USERNAME]/.nextcloud"
source $NC_USERCMD_DIR/nc_sync_env 1>/dev/null

# main program
echo "`date` $ME: start v005" >>$NC_LOGFILE 2>&1

while true
do
	# Is there an instance of the process running
	LAUNCH_PID=`pgrep -f -u "$NC_LINUX_UNAME" "$NC_CMD"`

	# if not Start the process
	if [ -z "$LAUNCH_PID" ]
	then
		echo "$ME: start $PROCES"
		$NC_CMD >>$NC_LOGFILE 2>&1
	fi
	sleep $NC_SLEEPTIME &
	wait $1 
	
done
### eof nextcloud_cmd.sh ###

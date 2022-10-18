#!/bin/bash
#
# file:		~/.nextcloud/nextcloud_sync_stop.sh
# host:		a.example.com
# testhost:	b.example.com
#
# date		version	comment
# ----		-------	-------
# 221017	v002	Added Variables to simplify change
# 221015	v001	initial
#
# Activity	Done	Date
# --------	----	----
# Last edit	jacob	221017 16:54
# Tested	jacob	221017 16:59
#
# Purpose:	This script is called by the nextcloudsync service to stop
#			nextcloudcmd
#
###

ME=`basename "$0"`

NC_USERCMD_DIR="/home/[USERNAME]/.nextcloud"
source $NC_USERCMD_DIR/nc_sync_env 1>/dev/null
##echo "`date` $ME: $NC_LOGFILE"

echo "`date` $ME: Started." >>$NC_LOGFILE 2>&1


# Kill command_file if running
LAUNCH_PID=`pgrep -f -u "$NC_LINUX_UNAME" "$NC_USER_CMD"` >>$NC_LOGFILE 2>&1
echo "Launch PID user cmd = $LAUNCH_PID" >>$NC_LOGFILE 2>&1
if [ "$LAUNCH_PID" ]
then
	kill -INT $LAUNCH_PID >>$NC_LOGFILE 2>&1
fi

# Kill program if running
LAUNCH_PID=`pgrep -f -u "$NC_LINUX_UNAME" "$NC_CMD"` >>$NC_LOGFILE 2>&1
echo "Launch PID bin = $LAUNCH_PID" >>$NC_LOGFILE 2>&1
if [ "$LAUNCH_PID" ]
then
	kill -INT $LAUNCH_PID >>$NC_LOGFILE 2>&1
fi

echo "`date` $ME: Completed." >>$NC_LOGFILE 2>&1
exit 0

### eof nextcloud_sync.sh ###

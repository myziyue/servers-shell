#!/bin/bash

CONFIG=/etc/rsyncd/rsyncd.conf
RSYNC=/usr/bin/rsync
RSYNC_PID=/var/run/rsyncd.pid

case "$1" in
	start)
		echo -n "Starting rsyncd "

		rm -rf $RSYNC_PID
		$RSYNC --daemon --config=$CONFIG

		if [ "$?" != 0 ] ; then
			echo " failed"
			exit 1
		fi
		echo "success"
		exit 1
	;;

	stop)
		echo -n "Gracefully shutting down rsyncd "

		kill -9 `ps -fe | grep "rsync" | grep -v "grep" | awk '{print $2}'` > /dev/null
		rm -rf $RSYNC_PID

		if [ "$?" != 0 ] ; then
			echo " failed. Use force-quit"
			exit 1
		else
			echo " done"
			exit 1
		fi
	;;

	restart)
		$0 stop
		$0 start
	;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
	;;

esac
#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

CONFIG_FILE=/etc/nginx/nginx.conf
DAEMON=/usr/local/sbin/nginx
DAEMON_OPTS="-c $CONFIG_FILE"
NAME="nginx"
DESC="Nginx Web Server"
PIDFILE=/var/run/nginx.pid
SCRIPTNAME=/etc/init.d/$NAME

#only run if binary can be found
test -x $DAEMON || exit 0

set -e

#import init function
. /lib/lsb/init-functions

case "$1" in
start)
	log_daemon_msg "Starting $DESC"
	if ! start-stop-daemon --start --quiet \
		--pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS ; then
		log_end_msg 1
	else
		log_end_msg 0
	fi
;;
stop)
	log_daemon_msg "Stopping $DESC" $NAME
	if start-stop-daemon --stop --quiet --oknodo --retry 30 \
		--pidfile $PIDFILE --exec $DAEMON; then
		rm -f $PIDFILE
		log_end_msg 0
	else
		log_end_msg 1
	fi
;;
reload)
	log_daemon_msg "Reloading $DESC Configuration" $NAME
	if start-stop-daemon --stop --signal 2 --oknodo --retry 30 \
		--quiet --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS ; then
		if start-stop-daemon --start --quiet \
			--pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS ; then
			log_end_msg 0
		else
			log_end_msg 1
		fi
	else
		log_end_msg 1
	fi
;;
force-reload)
	$0 stop
	sleep 1
	$0 start
;;
*)
	echo "Usage: $SCRIPTNAME {start|stop|reload|force-reload}" >&2
;;
esac

exit 0

#!/bin/bash
### BEGIN INIT INFO
# Provides:          openerp-server
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start openerp daemon at boot time
# Description:       Enable service provided by daemon.
# X-Interactive:     true
### END INIT INFO
## more info: http://wiki.debian.org/LSBInitScripts

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DAEMON=/opt/odoo/server/openerp-server
NAME=odoo
DESC=odoo
CONFIG=/etc/odoo-server.conf
LOGFILE=/var/log/odoo/odoo-server.log
PIDFILE=/var/run/${NAME}.pid
USER=odoo
export LOGNAME=$USER

test -x $DAEMON || exit 0
set -e

function _start() {
    start-stop-daemon --start --quiet --pidfile $PIDFILE --chuid $USER:$USER --background --make-pidfile --exec $DAEMON -- --config $CONFIG --logfile $LOGFILE
}

function _stop() {
    start-stop-daemon --stop --quiet --pidfile $PIDFILE --oknodo --retry 3
    rm -f $PIDFILE
}

function _status() {
    start-stop-daemon --status --quiet --pidfile $PIDFILE
    return $?
}


case "$1" in
        start)
                echo -n "Starting $DESC: "
                _start
                echo "ok"
                ;;
        stop)
                echo -n "Stopping $DESC: "
                _stop
                echo "ok"
                ;;
        restart|force-reload)
                echo -n "Restarting $DESC: "
                _stop
                sleep 1
                _start
                echo "ok"
                ;;
        status)
                echo -n "Status of $DESC: "
                _status && echo "running" || echo "stopped"
                ;;
        *)
                N=/etc/init.d/$NAME
                echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
                exit 1
                ;;
esac

exit 0

#!/bin/bash
# Performance data collection using nmon

# CONFIGURATION

NMON=/usr/bin/nmon
LOGDIR=/var/log/nmon
PIDFILE=/var/run/nmon.pid

# interval between snaphots in seconds
INTERVAL=60

# will be renamed by logrotate
FILENAME=$(hostname)_$(date +"%Y%m%d").nmon

# start
start() {

  if [ -f $PIDFILE ]; then
    echo "already running .."
    return 0
  fi
  
  # run nmon data collection
  $NMON -F $FILENAME -T -s $INTERVAL -m $LOGDIR -p -c -1> $PIDFILE
  return 0
}

stop() {
  if [ -f $PIDFILE ]; then
    kill -s USR2 `cat /var/run/nmon.pid` 2> /dev/null
  else
    killall -s USR2 $NMON 2> /dev/null
  fi
  
  rm -f $PIDFILE
  
  return 0
}

status() {
  if [ -f $PIDFILE ]; then
    ps -o pid,%cpu,%mem,start,args -p $( cat /var/run/nmon.pid )
  fi
  echo -e "\nDISK USAGE"
  du -sh /var/log/nmon
  return 0
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: nmon {start|stop|restart|status}"
    exit 1
    ;;
esac
exit $?



#!/bin/sh

PRG="$0"
BASEDIR=`dirname "$PRG"`
BASEDIR=`cd "$BASEDIR/.."; pwd -P`
PID_FILE="$BASEDIR/logs/tcserver.pid"

#returns 0 if the process is running
#returns 1 if the process is not running
#returns 2 if the process state is unknown
if [ -f "$PID_FILE" ]; then
  # The process file exists, make sure the process is not running
  PID=`cat "$PID_FILE"`
  if [ -z $PID ]; then
      exit 2;
  fi
  LINES=`ps -p $PID`
  PIDRET=$?
  if [ $PIDRET -eq 0 ];
  then
      exit 0;
  fi
  rm -f "$PID_FILE"
fi
exit 1

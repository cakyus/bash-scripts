#!/bin/bash
# Purpose: Terminate clip process

# Configuration
#  * Process timeout ( in seconds )
PROCESS_TIMEOUT=120

for PROCESS in $( pgrep xclip ) ; do

  CURRENT_TIME=$( date +%s )
  PROCESS_STATUS=$( awk '{print $3}' /proc/$PROCESS/stat )
  PROCESS_START=$( date -r /proc/$PROCESS/stat +%s )
  PROCESS_TIME=$(( $CURRENT_TIME - $PROCESS_START ))

  echo PROCESS $PROCESS PROCESS_STATUS $PROCESS_STATUS \
    PROCESS_START $PROCESS_START PROCESS_TIME $PROCESS_TIME

  # do not process status other than Sleeping
  [ "$PROCESS_STATUS" != "S" ] && continue
  # do not process recently started process
  [ $PROCESS_TIME -lt $PROCESS_TIMEOUT ] && continue
  
  # kill the process
  kill $PROCESS
done

#!/bin/bash
#
# Guakinator: Script to make Terminator have a dropdown functionality
#
# Dependencies: wmctrl, xdotool
#
# To install: Copy this script somewhere. I use ~/.guakinator.
# Then use system settings to bind it to F12.

# Use home to allow an install to /opt without running into ownership issues
BASE=$HOME/.guakinator
PID=$(cat $BASE/.pid)

if [ ! -d $BASE ]
then
	mkdir $BASE
fi

if [[ "$PID" != "" && $(pgrep -f terminator) =~ "$PID" ]]
then
        # Do I need to hide or unhide it?
        if [[ $(cat $BASE/.wid) == "-1" ]]
        then
                # Store WID; won't have it later otherwise
                WID=$(wmctrl -p -l | grep $PID | grep -o "0x[0-9a-fA-F]*")
                xdotool windowunmap $WID
                echo $WID > "$BASE/.wid"
        else
                # Grab the WID from before
                WID=$(cat $BASE/.wid)
                xdotool windowmap $WID
                wmctrl -i -r $WID -b add,maximized_horz
                wmctrl -i -a $WID
                echo -1 > "$BASE/.wid"
        fi
else
        # Terminator isn't active. We'll need to start it
        terminator -b -m & echo $! > "$BASE/.pid"
        WID=$(wmctrl -p -l | grep $PID | grep -o "0x[0-9a-fA-F]*")
        wmctrl -i -a $WID
        echo -1 > "$BASE/.wid"
fi

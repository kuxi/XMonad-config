#!/bin/sh

lang() {
    ~/.xmonad/xkblayout-state/xkblayout-state print "%s"
}

while [ -n "$(ps p $PPID o ppid | tail -n 1 | xargs ps p | grep xmobar)" ]; 
do
    lang
    sleep 1
    #TODO I want this event based instead of polling...
done

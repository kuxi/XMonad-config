#!/bin/sh

SOUND_DEV="/dev/snd/controlC0"

volume() {
    amixer -D default sget Master,0 \
        | grep dB \
        | head -n 1 \
        | cut -f 6 -d " " \
        | sed -e "s/\[\(.*\)\]/\1/g"
}
volume

while [ $? -eq 0 ] && [ -n "$(ps p $PPID o ppid | tail -n 1 | xargs ps p | grep xmobar)" ];
do
    #TODO display mute
    inotifywait $SOUND_DEV -e ACCESS -e CLOSE_WRITE > /dev/null 2> /dev/null
    volume
done

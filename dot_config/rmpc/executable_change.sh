#!/bin/zsh

source ~/.env/RMPC_DEFAULT_ART_DIR
source ~/.env/USR_MUSIC_DIR

magick "$(shuf -n 1 -e $RMPC_DEFAULT_ART_DIR/*)" -gravity center -crop 1:1+0+0 +repage ~/.config/rmpc/default.png

ffmpeg -loglevel quiet -y -i "$USR_MUSIC_DIR/$(mpc current -f %file%)" -an -c:v copy /tmp/cover.jpg && notify-send -t 2000 -u low -e -i /tmp/cover.jpg "$(mpc current)"

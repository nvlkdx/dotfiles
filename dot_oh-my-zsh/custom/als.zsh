# convenience
alias py='python'
alias nvm='nvim'
alias e='$EDITOR'
alias ff='fastfetch'
alias rsync-exfat='sudo rsync -rltDv --delete --modify-window=1 --progress'
alias yz='yazi'
alias start='./start.sh'
alias aster='astroterm -Cubcl 2.5 -r $(( (0.0+COLUMNS) / (0.0+LINES) ))'
alias bcdl='bandcamp-dl --base-dir "$USR_MUSIC_DIR" -er -c "-" -s "-" -x lower --template "$BCDL_TEMPLATE" --cover-quality 0'
alias musformat=$'perl-rename \'s/_/-/g; s/(.*)/\\L$1/\''
ytdl() {
  read "YTDL_WORKING_DIR?DIR: "
  yt-dlp -x --audio-format mp3 -f bestaudio --embed-metadata --parse-metadata "%(track_number,playlist_index)s:track_number" --parse-metadata "%(album_artist,artist)s:album_artist" --parse-metadata " :genre" --parse-metadata " :comment" --parse-metadata " :disc" -i --min-sleep-interval 6 --max-sleep-interval 18 --sleep-requests 1 --restrict-filenames -P "${YTDL_DIR}/${YTDL_WORKING_DIR}/" -o "$YTDL_FORMAT" "$@"
  musformat "${YTDL_DIR}"/"${YTDL_WORKING_DIR}"/*
}
cdgame() {
  cd $USR_GAME_DIR/$@
}
rl() {
  if [[ $1 == 'color' ]]; then
    cat ~/.cache/wallust/sequences
  else
    kill -SIGUSR1 $(pgrep $@)
  fi
}

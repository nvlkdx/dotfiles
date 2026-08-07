if [[ $(niri msg -j focused-output | jq -r .name) == "DP-4" ]]; then
	kitten @ load-config -o font_size=12
fi

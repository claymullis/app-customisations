function maybesource {
	[ -f "$1" ] && . "$1"
}
maybesource ~/.pathrc
maybesource ~/.aliasrc

maybesource /etc/profile.d/net.gfxmonk.profile.sh

source "$TBASE"/profile.d/net.gfxmonk.profile.sh "$TBASE/net.gfxmonk"
export PATH="$PATH:$(0launch http://gfxmonk.net/dist/0install/0find.xml http://gfxmonk.net/dist/0install/misc-scripts.xml)/bin"

#. $(0launch -c http://gfxmonk.net/dist/0install/bashcomplete.xml __init | tail -n 1)
function 0path { eval `0launch http://gfxmonk.net/dist/0install/0path.xml $@` }

_mkdir() {
	\mkdir -vp "$@"
}
_pushd() {
	[ "$1" ] && d=$(realpath "$1") || d="$HOME"
	current=$(dirs +0 | sed "s|\~|$HOME|g")

	[ "$current" = "$d" ] && dirs || \pushd "$d"
}
mkcdir() {
	_mkdir "$1" &&
	_pushd "$1"
}
python_format(){
	uvx black "$@"  && uvx isort "$@"  && uvx autoflake --in-place --remove-all-unused-imports -v "$@"
}

merge_dirs(){
	mkdir -p "${1}"
	rclone mount :union: "${1}" --union-upstreams "$(printf '%s ' "${@:2}")" --vfs-cache-mode writes
}

set_terminal_title() {
	echo -ne "\033]0;${*}\007"
}

_trash() {
	/usr/bin/trash "$@" 2> >(grep -v '^trash: volume of file: /' | grep -v '^trash: trying trash dir')
}

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

passphrase(){
	shuf /usr/share/dict/words | ([ "${special_characters}" = true ] && cat || grep -v '[^[:alnum:]]') | head -n "${2:-4}" | paste -sd "${delimiter:-" "}" | ([ -n "${1}" ] && pass insert -m "${1}" || cat)
}

alias \
	lg=lazygit \
	npm=bun \
	npx=bunx \
	pushd=_pushd \
	cd=pushd \
	youtube-dl-mp3='yt-dlp -cwix --audio-format=mp3' \
	no-proxy='http_proxy= https_proxy= HTTP_PROXY= HTTPS_PROXY=' \
    	rccp="rclone copy" \
    	rcmv="rclone move" \
	rgrep="grep -rHIn" \
	speed-test="curl http://ipv4.download.thinkbroadband.com/1GB.zip -o /dev/null" \
	mv="mv -vi" \
	rm="rm -vi" \
	cp="cp -vi" \
	mkdir=_mkdir \
	chmod="chmod -v" \
	ln="ln -v" \
	htop="htop -t" \
	watch="watch -c" \
    tar='tar -pv --backup' \
    internal-ip="python3 -c 'import socket
with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
    s.connect((\"8.8.8.8\", 80))
    print(s.getsockname()[0])
'" \
    i='pikaur -S' \
    fm=yazi \
    u='pikaur --remove --recursive' \
    sandbox='firejail --seccomp --nonewprivs --private --private-dev --private-tmp' \
    vlc-no-spoilers='vlc --no-osd --fullscreen' \
    trash='_trash -v' \
    t='copilot --model gpt-4.1 --available-tools _ -p' \
    offline-run='firejail --net=none' \
    yt-dlp-sd="yt-dlp --format='worst[height>=360][format_note*=original]/worstvideo[height>=360]+bestaudio[format_note*=original][ext=m4a]/worstvideo[height>=360]+bestaudio[format_note*=original]/best[ext=mp4][format_note*=original]/best'" \
    yt-dlp-sd-by-uploader-and-date-and-chapter="yt-dlp-sd --split-chapters -o '%(upload_date)s/%(uploader)s/%(title)s-%(id)s.%(ext)s' -o chapter:'%(upload_date)s/%(uploader)s/%(title)s-%(id)s/%(section_number)s-%(section_title)s.%(ext)s' --exec 'set -eo pipefail -o nounset; unsplit={}; split_dir=\"\${unsplit%.*}\"; if [ -d \"\${split_dir}\" ]; then truncate -cs 0 \"\${unsplit}\"; fi'"

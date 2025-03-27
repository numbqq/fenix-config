module_options+=(
	["see_monitoring,author"]="Joey Turner"
	["see_monitoring,ref_link"]=""
	["see_monitoring,feature"]="see_monitoring"
	["see_monitoring,desc"]="Menu for armbianmonitor features"
	["see_monitoring,example"]="see_monitoring"
	["see_monitoring,status"]="review"
	["see_monitoring,doc_link"]=""
)
#
# @decription generate a menu for armbianmonitor
#
function see_monitoring() {
	if [ -f /usr/bin/htop ]; then
		choice=$(armbianmonitor -h | grep -Ev '^\s*-c\s|^\s*-M\s' | show_menu)

		armbianmonitor -$choice

	else
		echo "htop is not installed"
	fi
}

module_options+=(
	["update_skel,author"]="Kat Schwarz"
	["update_skel,ref_link"]=""
	["update_skel,feature"]="install_plexmediaserver"
	["update_skel,desc"]="Install plexmediaserver from repo using apt"
	["update_skel,example"]="install_plexmediaserver"
	["update_skel,status"]="Active"
)
#
# Install plexmediaserver using apt
#
install_plexmediaserver() {
	if [ ! -f /etc/apt/sources.list.d/plexmediaserver.list ]; then
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/plexmediaserver.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list > /dev/null 2>&1
	else
		sed -i "/downloads.plex.tv/s/^#//g" /etc/apt/sources.list.d/plexmediaserver.list > /dev/null 2>&1
	fi
	# Note: for compatibility with existing source file in some builds format must be gpg not asc
	# and location must be /usr/share/keyrings
	wget -qO- https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plexmediaserver.gpg > /dev/null 2>&1
	apt_install_wrapper apt-get update
	apt_install_wrapper apt-get -y install plexmediaserver
	$DIALOG --title "$TITLE" --msgbox "To test that Plex Media Server has installed successfully\nIn a web browser go to http://localhost:32400/web or \nhttp://127.0.0.1:32400/web on this computer." 9 70
}

module_options+=(
	["update_skel,author"]="Kat Schwarz"
	["update_skel,ref_link"]=""
	["update_skel,feature"]="install_embyserver"
	["update_skel,desc"]="Download a embyserver deb file from a URL and install using apt"
	["update_skel,example"]="install_embyserver"
	["update_skel,status"]="Active"
)
#
# Download a deb file from a URL and install using wget and apt with dialog progress bars
#
install_embyserver() {
	URL=$(curl -s https://api.github.com/repos/MediaBrowser/Emby.Releases/releases/latest |
		grep "/emby-server-deb.*$(dpkg --print-architecture).deb" | cut -d : -f 2,3 | tr -d '"')
	cd ~/
	wget -O "/tmp/emby-server.deb" $URL 2>&1 | stdbuf -oL awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' |
		$DIALOG --title "$TITLE" --gauge "Please wait\nDownloading ${URL##*/}" 8 70 0
	apt_install_wrapper apt-get -y install /tmp/emby-server.deb
	rm /tmp/emby-server.deb
	$DIALOG --title "$TITLE" --msgbox "To test that Emby Server has installed successfully\nIn a web browser go to http://localhost:8096 or \nhttp://127.0.0.1:8096 on this computer." 9 70
}

module_options+=(
	["install_docker,author"]="Gunjan Gupta"
	["install_docker,ref_link"]=""
	["install_docker,feature"]="install docker"
	["install_docker,desc"]="Install docker"
	["install_docker,example"]="install_docker"
	["install_docker,status"]="review"
	["install_docker,doc_link"]=""
)
#
# @decription install docker
#
install_docker() {
	if wget -q -t 1 --timeout=5 --spider https://download.docker.com/linux/${DISTRO,,}/dists/${DISTROID}/stable; then
		curl -fsSL https://download.docker.com/linux/${DISTRO,,}/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
		echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/${DISTRO,,} ${DISTROID} stable" \
			> /etc/apt/sources.list.d/docker.list
		debconf-apt-progress -- apt-get update
		debconf-apt-progress -- apt-get install -y -qq docker-ce
	else
		debconf-apt-progress -- apt-get update
		debconf-apt-progress -- apt-get install -y -qq docker.io
	fi

	if [ -n "$SUDO_USER" ]; then
		usermod -aG docker $SUDO_USER
	fi
}

module_options+=(
	["remove_docker,author"]="Gunjan Gupta"
	["remove_docker,ref_link"]=""
	["remove_docker,feature"]="remove docker"
	["remove_docker,desc"]="Remove docker"
	["remove_docker,example"]="remove_docker"
	["remove_docker,status"]="review"
	["remove_docker,doc_link"]=""
)
#
# @decription remove docker
#
remove_docker() {
	if check_if_installed docker-ce; then
		debconf-apt-progress -- apt-get autoremove --purge -y docker-ce
	else
		debconf-apt-progress -- apt-get autoremove --purge -y docker.io
	fi
}

module_options+=(
	["install_widevine,author"]="Gunjan Gupta"
	["install_widevine,ref_link"]=""
	["install_widevine,feature"]="widevine"
	["install_widevine,desc"]="Install Widevine CDM"
	["install_widevine,example"]="install_widevine"
	["install_widevine,status"]="review"
	["install_widevine,doc_link"]=""
)
#
# @decription remove docker
#
install_widevine(){
	local widevine_version="4.10.2662.3+1"
	wget -P /tmp https://archive.raspberrypi.org/debian/pool/main/w/widevine/widevine_${widevine_version}.tar.xz
	tar xf /tmp/widevine_${widevine_version}.tar.xz --strip-components=1 -C / --wildcards 'widevine-*/opt'
	mkdir /opt/WidevineCdm/gmp-widevinecdm
	ln -sf ../../_platform_specific/linux_arm64 /opt/WidevineCdm/gmp-widevinecdm/latest
	ln -sf /opt/WidevineCdm /usr/lib/chromium/WidevineCdm
}

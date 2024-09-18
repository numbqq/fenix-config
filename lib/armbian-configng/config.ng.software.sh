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
install_docker ()
{
	if wget -q -t 1 --timeout=5 --spider https://download.docker.com/linux/${DISTRO,,}/dists/${DISTROID}/stable ; then
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
remove_docker ()
{
	if check_if_installed docker-ce; then
    debconf-apt-progress -- apt-get autoremove --purge -y docker-ce
  else
    debconf-apt-progress -- apt-get autoremove --purge -y docker.io
  fi
}

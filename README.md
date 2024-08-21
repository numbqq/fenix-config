# Fenix configuration utility

Utility for configuring your board, adjusting services and installing applications.
It comes with Fenix by default.

Login as root and type:

	fenix-config

- **system**
	- install to SATA, eMMC, NAND or USB
	- freeze and unfreeze kernel and BSP upgrades
	- edit boot environment
	- reconfigure board settings with DT overlays
	- adjust SSH daemon features
	- run apt update and upgrade
	- toggle desktop and login manager (desktop builds)
	- enabling read only root filesystem (Ubuntu)
- **network**
	- select dynamic or static IP address
	- iperf3. Toggle bandwidth measuring server
	- connect to wireless
	- install IR support
	- install support, pair and connect Bluetooth devices
	- edit IFUPDOWN interfaces
- **personal**
	- change timezone, languages and hostname
	- select welcome screen items
- **software**
	- softy
		- [TV headend](https://tvheadend.org/) *(IPTV server)*
		- [Syncthing](https://syncthing.net/) *(personal cloud)*
		- [SoftEther VPN server](https://www.softether.org/) *(VPN server)*
		- [Plex](https://www.plex.tv/) *(Plex media server)*
		- [Emby](https://emby.media/) *(Emby media server)*
		- [Radarr](https://radarr.video/) *(Movie downloading server)*
		- [Sonarr](https://sonarr.tv/) *(TV shows downloading server)*
		- [Transmission](https://transmissionbt.com/) *(torrent server)*
		- [ISPConfig](https://www.ispconfig.org/) *(WEB & MAIL server)*
		- [NCP](https://nextcloudpi.com) *(Nextcloud personal cloud)*
		- [Openmediavault NAS](http://www.openmediavault.org/) *(NAS server)*
		- [OpenHab2](https://www.openhab.org) *(Smarthome suite)*
		- [Home Assistant](https://www.home-assistant.io/hassio/) *(Smarthome suite within Docker)*
		- [PI hole](https://pi-hole.net) *(ad blocker)*
		- [UrBackup](https://www.urbackup.org/) *(client/server backup system)*
		- [Docker](https://www.docker.com) *(Docker CE engine)*
		- [Mayan EDMS](https://www.mayan-edms.com/) *(Document management system within Docker)*
		- [MiniDLNA](http://minidlna.sourceforge.net/) *(media sharing)*
	- toggle kernel headers, RDP service
- **help**
	- Links to documentation, support and sources

Development version:

	# Install dependencies
	apt install git iperf3 psmisc curl bc expect dialog network-manager \
	debconf-utils unzip dirmngr software-properties-common psmisc jq

	git clone https://github.com/numbqq/fenix-config
	cd fenix-config
	bash fenix-config

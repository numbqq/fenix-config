#!/bin/bash


module_options+=(
["install_de,author"]="Igor Pecovnik"
["install_de,ref_link"]=""
["install_de,feature"]="install_de"
["install_de,desc"]="Install DE"
["install_de,example"]="install_de"
["install_de,status"]="Active"
)
#
# Install desktop
#
function install_de (){

	# get user who executed this script
	if [ $SUDO_USER ]; then local user=$SUDO_USER; else local user=`whoami`; fi

	#debconf-apt-progress -- 
	apt-get update
	#debconf-apt-progress -- 
	apt-get -o Dpkg::Options::="--force-confold" -y --install-recommends install armbian-${DISTROID}-desktop-$1 # armbian-bsp-desktop-${BOARD}-${BRANCH}

	# clean apt cache
	apt-get -y clean

	# add user to groups
	for additionalgroup in sudo netdev audio video dialout plugdev input bluetooth systemd-journal ssh; do
			usermod -aG ${additionalgroup} ${user} 2>/dev/null
	done

	# set up profile sync daemon on desktop systems
	which psd >/dev/null 2>&1
	if [[ $? -eq 0 && -z $(grep overlay-helper /etc/sudoers) ]]; then
		echo "${user} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" >> /etc/sudoers
		touch /home/${user}/.activate_psd
	fi

	# update skel
	update_skel

	# desktops has different default login managers
    case "$1" in
        gnome)
		# gdm3
		;;
    *)
		# lightdm
		mkdir -p /etc/lightdm/lightdm.conf.d
		echo "[Seat:*]" > /etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf
		echo "autologin-user=${username}" >> /etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf
		echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf
		echo "user-session=xfce" >> /etc/lightdm/lightdm.conf.d/22-armbian-autologin.conf
		ln -s /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service >/dev/null 2>&1
		service lightdm start >/dev/null 2>&1
	;;
    esac
exit
}


module_options+=(
["update_skel,author"]="Igor Pecovnik"
["update_skel,ref_link"]=""
["update_skel,feature"]="update_skel"
["update_skel,desc"]="Update the /etc/skel files in users directories"
["update_skel,example"]="update_skel"
["update_skel,status"]="Active"
)
#
# check dpkg status of $1 -- currently only 'not installed at all' case caught
#
function update_skel (){

	getent passwd |
	while IFS=: read -r username x uid gid gecos home shell
	do
	if [ ! -d "$home" ] || [ "$username" == 'root' ] || [ "$uid" -lt 1000 ]
	then
		continue
	fi
        tar -C /etc/skel/ -cf - . | su - "$username" -c "tar --skip-old-files -xf -"
	done

}


module_options+=(
["qr_code,author"]="Igor Pecovnik"
["qr_code,ref_link"]=""
["qr_code,feature"]="qr_code"
["qr_code,desc"]="Show or generate QR code for Google OTP"
["qr_code,example"]="qr_code generate"
["qr_code,status"]="Active"
)
#
# check dpkg status of $1 -- currently only 'not installed at all' case caught
#
function qr_code (){

	clear
	if [[ "$1" == "generate" ]]; then
		google-authenticator -t -d -f -r 3 -R 30 -W -q
		cp /root/.google_authenticator /etc/skel
		update_skel
	fi
	export TOP_SECRET=$(head -1 /root/.google_authenticator)
	qrencode -m 2 -d 9 -8 -t ANSI256 "otpauth://totp/test?secret=$TOP_SECRET"
	echo -e '\nScan QR code with your OTP application on mobile phone\n'
	read -n 1 -s -r -p "Press any key to continue"

}


module_options+=(
["set_stable,author"]="Tearran"
["set_stable,ref_link"]="https://github.com/armbian/config/blob/master/debian-config-jobs#L1446"
["set_stable,feature"]="set_stable"
["set_stable,desc"]="Set Armbian to stable release"
["set_stable,example"]="set_stable"
["set_stable,status"]="Active"
)
#
# @description Set Armbian to stable release
#
function set_stable () {

if ! grep -q 'apt.armbian.com' /etc/apt/sources.list.d/armbian.list; then
    sed -i "s/http:\/\/[^ ]*/http:\/\/apt.armbian.com/" /etc/apt/sources.list.d/armbian.list
	armbian_fw_manipulate "reinstall"
fi
}

module_options+=(
["set_rolling,author"]="Tearran"
["set_rolling,ref_link"]="https://github.com/armbian/config/blob/master/debian-config-jobs#L1446"
["set_rolling,feature"]="set_rolling"
["set_rolling,desc"]="Set Armbian to rolling release"
["set_rolling,example"]="set_rolling"
["set_rolling,status"]="Active"
)
#
# @description Set Armbian to rolling release
#
function set_rolling () {

if ! grep -q 'beta.armbian.com' /etc/apt/sources.list.d/armbian.list; then
	sed -i "s/http:\/\/[^ ]*/http:\/\/beta.armbian.com/" /etc/apt/sources.list.d/armbian.list
	armbian_fw_manipulate "reinstall"
fi
}

module_options+=(
["manage_overlayfs,author"]="igorpecovnik"
["manage_overlayfs,ref_link"]=""
["manage_overlayfs,feature"]="overlayfs"
["manage_overlayfs,desc"]="Set root filesystem to read only"
["manage_overlayfs,example"]="manage_overlayfs enable|disable"
["manage_overlayfs,status"]="Active"
)
#
# @description set/unset root filesystem to read only
#
function manage_overlayfs () {
	if [[ "$1" == "enable" ]]; then
		debconf-apt-progress -- apt-get -o Dpkg::Options::="--force-confold" -y install overlayroot cryptsetup cryptsetup-bin
		[[ ! -f /etc/overlayroot.conf ]] && cp /etc/overlayroot.conf.dpkg-new /etc/overlayroot.conf
		sed -i "s/^overlayroot=.*/overlayroot=\"tmpfs\"/" /etc/overlayroot.conf
		sed -i "s/^overlayroot_cfgdisk=.*/overlayroot_cfgdisk=\"enabled\"/" /etc/overlayroot.conf
	else	
		overlayroot-chroot rm /etc/overlayroot.conf > /dev/null 2>&1
		debconf-apt-progress -- apt-get -y purge overlayroot cryptsetup cryptsetup-bin
	fi

	$DIALOG --title " Reboot required " --yes-button "Reboot" \
		--no-button "Cancel" --yesno "\nA reboot is required to apply the changes. Shall we reboot now?" 7 34

	if [[ $? = 0 ]]; then
		reboot
	fi
}


module_options+=(
["set_cpufreq_option,author"]="Gunjan Gupta"
["set_cpufreq_option,ref_link"]=""
["set_cpufreq_option,feature"]="cpufreq"
["set_cpufreq_option,desc"]="Set cpufreq options like minimum/maximum speed and governor"
["set_cpufreq_option,example"]="set_cpufreq_option MIN_SPEED|MAX_SPEED|GOVERNOR"
["set_cpufreq_option,status"]="Active"
)
#
# @description set cpufreq options like minimum/maximum speed and governor
#
function set_cpufreq_option () {
	# Assuming last policy is for the big core
	local policy=$(ls /sys/devices/system/cpu/cpufreq/ | tail -n 1)
	local selected_value=""

	unset PARAMETER

	case "$1" in
		MIN_SPEED)
			generic_select "$(cat /sys/devices/system/cpu/cpufreq/$policy/scaling_available_frequencies 2>/dev/null)" "Select minimum CPU speed"
			selected_value=$PARAMETER
			;;
		MAX_SPEED)
			local min_speed=$(cat /sys/devices/system/cpu/cpufreq/$policy/cpuinfo_min_freq)
			generic_select "$(cat /sys/devices/system/cpu/cpufreq/$policy/scaling_available_frequencies 2>/dev/null)" "Select maximum CPU speed" $min_speed
			selected_value=$PARAMETER
			;;
		GOVERNOR)
			generic_select "$(cat /sys/devices/system/cpu/cpufreq/$policy/scaling_available_governors)" "Select CPU governor"
			selected_value=$PARAMETER
			;;

		*)
			;;
	esac

	if [[ -n $selected_value ]]; then
		sed -i "s/$1=.*/$1=$selected_value/" /etc/default/cpufrequtils
		systemctl restart cpufrequtils
	fi
}

module_options+=(
["set_fan_controls,author"]="Gunjan Gupta"
["set_fan_controls,ref_link"]=""
["set_fan_controls,feature"]="fan control"
["set_fan_controls,desc"]="Set fan control options"
["set_fan_controls,example"]="set_fan_controls [mode|level]"
["set_fan_controls,status"]="Active"
)
#
# @description Set fan control options
#
function set_fan_controls () {
	local selected_value=""
	unset PARAMETER

	case "$1" in
		mode)
			generic_select "on auto off" "Set fan mode"
			;;
		level)
			generic_select "low mid high" "Set fan speed"
			;;
		*)
			;;
	esac

	selected_value=$PARAMETER

	if [[ -n $selected_value ]]; then
		/usr/local/bin/fan.sh $selected_value
	fi
}


module_options+=(
["manage_dtoverlays,author"]="Gunjan Gupta"
["manage_dtoverlays,ref_link"]=""
["manage_dtoverlays,feature"]="dtoverlays"
["manage_dtoverlays,desc"]="Enable/disable device tree overlays"
["manage_dtoverlays,example"]="manage_dtoverlays"
["manage_dtoverlays,status"]="Active"
)
#
# @description Enable/disable device tree overlays
#
function manage_dtoverlays () {
	# check if user agree to enter this area
	local changes="false"
	local overlaydir=$(ls -d /boot/overlays/*${BOARD@L}.dtb.overlays)
	local overlayconf=$(ls -d /boot/overlays/*${BOARD@L}.dtb.overlay.env)
	while true; do
		local options=()
		j=0

		available_overlays=$(ls -1 ${overlaydir}/*.dtbo | sed "s#^${overlaydir}/##" | sed 's/.dtbo//g' | tr '\n' ' ')

		for overlay in ${available_overlays}; do
			local status="OFF"
			grep '^fdt_overlays' ${overlayconf} | grep -qw ${overlay} && status=ON
			options+=( "$overlay" "" "$status")
		done

		selection=$($DIALOG --title "Manage devicetree overlays" --cancel-button "Back" \
			--ok-button "Save" --checklist "\nUse <space> to toggle functions and save them.\nExit when you are done.\n " \
			0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
		exit_status=$?

		case $exit_status in
			0)
				changes="true"
				newoverlays=$(echo $selection | sed 's/"//g')
				sed -i "s/^fdt_overlays=.*/fdt_overlays=$newoverlays/" ${overlayconf}
				if ! grep -q "^fdt_overlays" ${overlayconf}; then echo "fdt_overlays=$newoverlays" >> ${overlayconf}; fi
				sync
				;;
			1)
				if [[ "$changes" == "true" ]]; then
					$DIALOG --title " Reboot required " --yes-button "Reboot" \
						--no-button "Cancel" --yesno "A reboot is required to apply the changes. Shall we reboot now?" 7 34
					if [[ $? = 0 ]]; then
						reboot
					fi

					sleep 30
				fi
				break
				;;
			255)
				;;
		esac
	done
}
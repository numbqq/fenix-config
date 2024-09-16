
# Armbian Configuration Utility
Updated: Mon Sep 16 11:33:03 AM IST 2024

Utility for configuring your board, adjusting services, and installing applications. It comes with Armbian by default.

To start the Armbian configuration utility, use the following command:
~~~
sudo armbian-configng
~~~

- ## **System** 
  - **S01** - Enable Armbian kernel/firmware upgrades
  - **S02** - Disable Armbian kernel upgrades
  - **S03** - Edit the boot environment
  - **S04** - Install Linux headers
  - **S05** - Remove Linux headers
  - **S06** - Install to internal storage
  - **S07.1** - Manage SSH login options
  - **S17** - Change shell system wide to BASH
  - **S18** - Change shell system wide to ZSH
  - **S19** - Switch to rolling release
  - **S20** - Switch to stable release
  - **S21** - Enable read only filesystem
  - **S22** - Disable read only filesystem


- ## **Network** 
  - **N01.1** - Configure network interfaces
  - **N15** - Install Bluetooth support
  - **N16** - Remove Bluetooth support
  - **N17** - Bluetooth Discover
  - **N18** - Toggle system IPv6/IPv4 internet protocol


- ## **Localisation** 
  - **L00** - Change Global timezone (WIP)
  - **L01** - Change Locales reconfigure the language and character set
  - **L02** - Change Keyboard layout
  - **L03** - Change APT mirrors


- ## **Software** 
  - **SW01.1** - Desktop Environments
  - **SW01.2** - Network tools
  - **SW01.3** - Development
  - **SW19** - Update Application Repository
  - **SW20** - System benchmaking and diagnostics


- ## **Help** 
  - **H00** - About This system. (WIP)
  - **H02** - List of Config function(WIP)

## Install 
Armbian installation 
~~~
sudo apt install armbian-config
~~~

3rd party Debian based distributions
~~~
{
    sudo wget https://apt.armbian.com/armbian.key -O key
    sudo gpg --dearmor < key | sudo tee /usr/share/keyrings/armbian.gpg > /dev/null
    sudo chmod go+r /usr/share/keyrings/armbian.gpg
    sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/armbian.gpg] http://apt.armbian.com $(lsb_release -cs) main  $(lsb_release -cs)-utils  $(lsb_release -cs)-desktop" | sudo tee /etc/apt/sources.list.d/armbian.list
    sudo apt update
    sudo apt install armbian-config
}
~~~

***

## CLI options
Command line options.

Use:
~~~
armbian-configng --help
~~~

Outputs:
~~~

  System - System wide and admin settings (aarch64)
    --cmd S01 - Enable Armbian kernel/firmware upgrades
    --cmd S02 - Disable Armbian kernel upgrades
    --cmd S03 - Edit the boot environment
    --cmd S04 - Install Linux headers
    --cmd S05 - Remove Linux headers
    --cmd S06 - Install to internal storage
    S07.1 - Manage SSH login options
	--cmd S07 - Disable root login
	--cmd S08 - Enable root login
	--cmd S09 - Disable password login
	--cmd S10 - Enable password login
	--cmd S11 - Disable Public key authentication login
	--cmd S12 - Enable Public key authentication login
	--cmd S13 - Disable OTP authentication
	--cmd S14 - Enable OTP authentication
	--cmd S15 - Generate new OTP authentication QR code
	--cmd S16 - Show OTP authentication QR code
    --cmd S17 - Change shell system wide to BASH
    --cmd S18 - Change shell system wide to ZSH
    --cmd S19 - Switch to rolling release
    --cmd S20 - Switch to stable release
    --cmd S21 - Enable read only filesystem
    --cmd S22 - Disable read only filesystem

  Network - Fixed and wireless network settings (wlan0)
    N01.1 - Configure network interfaces
      N01.1.1 - Wired
	--cmd N01 - Show configuration
	--cmd N02 - Enable DHCP on all interfaces
	--cmd N03 - Set fixed IP address
	--cmd N04 - Disable IPV6
	--cmd N05 - Enable IPV6
	--cmd N06 - Disable wired networking
      N01.1.2 - Wireless
	--cmd N07 - Show configuration
	--cmd N08 - Disable wireless networking
	--cmd N09 - Disable IPV6
	--cmd N10 - Enable IPV6
	--cmd N11 - Enable DHCP on wireless network interface
	--cmd N12 - Show common configs
	--cmd N13 - Apply common configs
	--cmd N14 - Display status
    --cmd N15 - Install Bluetooth support
    --cmd N16 - Remove Bluetooth support
    --cmd N17 - Bluetooth Discover
    --cmd N18 - Toggle system IPv6/IPv4 internet protocol

  Localisation - Localisation (en_US.UTF-8)
    --cmd L00 - Change Global timezone (WIP)
    --cmd L01 - Change Locales reconfigure the language and character set
    --cmd L02 - Change Keyboard layout
    --cmd L03 - Change APT mirrors

  Software - Run/Install 3rd party applications (02:20:15)
    SW01.1 - Desktop Environments
	--cmd SW02 - Install XFCE desktop
	--cmd SW03 - Install Gnome desktop
	--cmd SW04 - Install i3-wm desktop
	--cmd SW05 - Install Cinnamon desktop
	--cmd SW06 - Install kde-neon desktop
    SW01.2 - Network tools
	--cmd SW08 - Install realtime console network usage monitor (nload)
	--cmd SW09 - Remove realtime console network usage monitor (nload)
	--cmd SW10 - Install bandwidth measuring tool (iperf3)
	--cmd SW11 - Remove bandwidth measuring tool (iperf3)
	--cmd SW12 - Install IP LAN monitor (iptraf-ng)
	--cmd SW13 - Remove IP LAN monitor (iptraf-ng)
	--cmd SW14 - Install hostname broadcast via mDNS (avahi-daemon)
	--cmd SW15 - Remove hostname broadcast via mDNS (avahi-daemon)
    SW01.3 - Development
	--cmd SW17 - Install tools for cloning and managing repositories (git)
	--cmd SW18 - Remove tools for cloning and managing repositories (git)
    --cmd SW19 - Update Application Repository
    --cmd SW20 - System benchmaking and diagnostics

  Help - About this app
    --cmd H00 - About This system. (WIP)
    --cmd H02 - List of Config function(WIP)
~~~

## Legacy options
Backward Compatible options.

Use:
~~~
armbian-configng main=Help
~~~

Outputs:
~~~
Legacy Options (Backward Compatible)
Please use 'armbian-configng --help' for more information.

Usage:  armbian-configng main=[arguments] selection=[options]

    armbian-configng main=System selection=Headers          -  Install headers:                                        
    armbian-configng main=System selection=Headers_remove   -  Remove headers:                                 
~~~

***

## Development

Development is divided into three sections:

Click for more info:

<details>
<summary><b>Jobs / JSON Object</b></summary>

A list of the jobs defined in the Jobs file.

 ### S01

Enable Armbian kernel/firmware upgrades

Jobs:

~~~
armbian_fw_manipulate unhold
~~~

### S02

Disable Armbian kernel upgrades

Jobs:

~~~
armbian_fw_manipulate hold
~~~

### S03

Edit the boot environment

Jobs:

~~~
nano /boot/armbianEnv.txt
~~~

### S04

Install Linux headers

Jobs:

~~~
Headers_install
~~~

### S05

Remove Linux headers

Jobs:

~~~
Headers_remove
~~~

### S06

Install to internal storage

Jobs:

~~~
armbian-install
~~~

### S07.1

Manage SSH login options

Jobs:

~~~
No commands available
~~~

### S17

Change shell system wide to BASH

Jobs:

~~~
export BASHLOCATION=$(grep /bash$ /etc/shells | tail -1)
sed -i "s|^SHELL=.*|SHELL=${BASHLOCATION}|" /etc/default/useradd
sed -i "s|^DSHELL=.*|DSHELL=${BASHLOCATION}|" /etc/adduser.conf
debconf-apt-progress -- apt-get -y purge armbian-zsh
update_skel
awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534 || $3 == 0) print $1}' /etc/passwd | xargs -L1 chsh -s $(grep /bash$ /etc/shells | tail -1)
~~~

### S18

Change shell system wide to ZSH

Jobs:

~~~
export ZSHLOCATION=$(grep /zsh$ /etc/shells | tail -1)
sed -i "s|^SHELL=.*|SHELL=${ZSHLOCATION}|" /etc/default/useradd
sed -i "s|^DSHELL=.*|DSHELL=${ZSHLOCATION}|" /etc/adduser.conf
debconf-apt-progress -- apt-get -y install armbian-zsh
update_skel
awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534 || $3 == 0) print $1}' /etc/passwd | xargs -L1 chsh -s $(grep /zsh$ /etc/shells | tail -1)
~~~

### S19

Switch to rolling release

Jobs:

~~~
set_rolling
~~~

### S20

Switch to stable release

Jobs:

~~~
set_stable
~~~

### S21

Enable read only filesystem

Jobs:

~~~
manage_overlayfs enable
~~~

### S22

Disable read only filesystem

Jobs:

~~~
manage_overlayfs disable
~~~

### N01.1

Configure network interfaces

Jobs:

~~~
No commands available
~~~

### N15

Install Bluetooth support

Jobs:

~~~
see_current_apt 
debconf-apt-progress -- apt-get -y install bluetooth bluez bluez-tools
check_if_installed xserver-xorg && debconf-apt-progress -- apt-get -y --no-install-recommends install pulseaudio-module-bluetooth blueman
~~~

### N16

Remove Bluetooth support

Jobs:

~~~
see_current_apt 
debconf-apt-progress -- apt-get -y remove bluetooth bluez bluez-tools
check_if_installed xserver-xorg && debconf-apt-progress -- apt-get -y remove pulseaudio-module-bluetooth blueman
debconf-apt-progress -- apt -y -qq autoremove
~~~

### N17

Bluetooth Discover

Jobs:

~~~
connect_bt_interface
~~~

### N18

Toggle system IPv6/IPv4 internet protocol

Jobs:

~~~
toggle_ipv6 | show_infobox
~~~

### L00

Change Global timezone (WIP)

Jobs:

~~~
dpkg-reconfigure tzdata
~~~

### L01

Change Locales reconfigure the language and character set

Jobs:

~~~
dpkg-reconfigure locales
source /etc/default/locale ; sed -i "s/^LANGUAGE=.*/LANGUAGE=$LANG/" /etc/default/locale
export LANGUAGE=$LANG
~~~

### L02

Change Keyboard layout

Jobs:

~~~
dpkg-reconfigure keyboard-configuration ; setupcon 
update-initramfs -u
~~~

### L03

Change APT mirrors

Jobs:

~~~
get_user_continue "This is only a frontend test" process_input
~~~

### SW01.1

Desktop Environments

Jobs:

~~~
No commands available
~~~

### SW01.2

Network tools

Jobs:

~~~
No commands available
~~~

### SW01.3

Development

Jobs:

~~~
No commands available
~~~

### SW19

Update Application Repository

Jobs:

~~~
debconf-apt-progress -- apt update
~~~

### SW20

System benchmaking and diagnostics

Jobs:

~~~
see_monitoring
~~~

### H00

About This system. (WIP)

Jobs:

~~~
show_message <<< "This app is to help execute procedures to configure your system

Some options may not work on manually modified systems"
~~~

### H02

List of Config function(WIP)

Jobs:

~~~
show_message <<< see_use
~~~

</details>


<details>
<summary><b>Jobs API / Helper Functions</b></summary>

These helper functions facilitate various operations related to job management, such as creation, updating, deletion, and listing of jobs, acting as a practical API for developers.

| Description | Example | Credit |
|:----------- | ------- |:------:|
| Wrapping Netplan commands | netplan_wrapper | Igor Pecovnik 
| Generate a Help message legacy cli commands. | see_cli_legacy | Joey Turner 
| Run time variables Migrated procedures from Armbian config. | set_runtime_variables | Igor Pecovnik 
| Set Armbian to rolling release | set_rolling | Tearran 
| Generate this markdown table of all module_options | see_function_table_md | Joey Turner 
| Set Armbian root filesystem to read only | manage_overlayfs enable|disable | igorpecovnik 
| Display a menu from pipe | show_menu <<< armbianmonitor -h  ;  | Joey Turner 
| Build the main menu from a object | generate_top_menu 'json_data' | Joey Turner 
| Migrated procedures from Armbian config. | is_package_manager_running | Igor Pecovnik 
| Migrated procedures from Armbian config. | check_desktop | Igor Pecovnik 
| Generate Document files. | generate_readme | Joey Turner 
| Needed by generate_menu |  | Joey Turner 
| Display a Yes/No dialog box and process continue/exit | get_user_continue 'Do you wish to continue?' process_input | Joey Turner 
| Display a message box | show_message <<< 'hello world'  | Joey Turner 
| Migrated procedures from Armbian config. | connect_bt_interface | Igor Pecovnik 
| Menu for armbianmonitor features | see_monitoring | Joey Turner 
| Show or generate QR code for Google OTP | qr_code generate | Igor Pecovnik 
| Check if kernel headers are installed | are_headers_installed | Gunjan Gupta 
| Check when apt list was last updated | see_current_apt | Joey Turner 
| Migrated procedures from Armbian config. | check_if_installed nano | Igor Pecovnik 
| Generate 'Armbian CPU logo' SVG for document file. | generate_svg | Joey Turner 
| Remove Linux headers | Headers_remove | Joey Turner 
| Displays available adapters | choose_adapter | Igor Pecovnik 
| Update submenu descriptions based on conditions | update_submenu_data | Joey Turner 
| sanitize input cli | sanitize_input |  
| Check if a domain is reachable via IPv4 and IPv6 | check_ip_version google.com | Joey Turner 
| Migrated procedures from Armbian config. | set_header_remove | Igor Pecovnik 
| Generate a submenu from a parent_id | generate_menu 'parent_id' | Joey Turner 
| Generate a markdown list json objects using jq. | see_jq_menu_list | Joey Turner 
| Generate jobs from JSON file. | generate_jobs_from_json | Joey Turner 
| Install kernel headers | is_package_manager_running | Joey Turner 
| Set up a WiFi hotspot on the device | hotspot_setup | Joey Turner 
| Toggle IPv6 on or off | toggle_ipv6 | Joey Turner 
| Generate JSON-like object file. | generate_json | Joey Turner 
| Install DE | install_de | Igor Pecovnik 
| Change the background color of the terminal or dialog box | set_colors 0-7 | Joey Turner 
| Serve the edit and debug server. | serve_doc | Joey Turner 
| Update JSON data with system information | update_json_data | Joey Turner 
| pipeline strings to an infobox  | show_infobox <<< 'hello world' ;  | Joey Turner 
| Parse json to get list of desired menu or submenu items | parse_menu_items 'menu_options_array' | Gunjan Gupta 
| Show the usage of the functions. | see_use | Joey Turner 
| List and connect to wireless network | wifi_connect | Igor Pecovnik 
| Generate a Help message for cli commands. | see_cmd_list [catagory] | Joey Turner 
| freeze/unhold/reinstall armbian related packages. | armbian_fw_manipulate unhold|freeze|reinstall | Igor Pecovnik 
| Check the internet connection with fallback DNS | see_ping | Joey Turner 
| Update the /etc/skel files in users directories | update_skel | Igor Pecovnik 
| Set Armbian to stable release | set_stable | Tearran 
| Secure version of get_user_continue | get_user_continue_secure 'Do you wish to continue?' process_input | Joey Turner 


</details>


<details>
<summary><b>Runtime / Board Statuses</b></summary>

(WIP)

This section outlines the runtime environment to check configurations and statuses for dynamically managing jobs based on JSON data.

(WIP)

</details>


## Testing and contributing

<details>
<summary><b>Get Development</b></summary>

Install the dependencies:
~~~
sudo apt install git jq whiptail
~~~

Get Development and contribute:
~~~
{
    git clone https://github.com/armbian/configng
    cd configng
    ./armbian-configng --help
}
~~~

Install and test Development deb:
~~~
{
    sudo apt install whiptail
    latest_release=$(curl -s https://api.github.com/repos/armbian/configng/releases/latest)
    deb_url=$(echo "$latest_release" | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')
    curl -LO "$deb_url"
    deb_file=$(echo "$deb_url" | awk -F"/" '{print $NF}')
    sudo dpkg -i "$deb_file"
    sudo dpkg --configure -a
    sudo apt --fix-broken install
}
~~~

</details>


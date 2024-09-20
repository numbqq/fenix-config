
# Fenix Configuration Utility
Updated: Fri Sep 20 06:18:35 AM UTC 2024

Utility for configuring your board, adjusting services, and installing applications. It comes with Fenix by default.

To start the Fenix configuration utility, use the following command:
~~~
sudo fenix-config
~~~

- ## **System** 
  - **S01** - Enable Kernel/BSP upgrades
  - **S02** - Disable Kernel/BSP upgrades
  - **S03** - Edit the boot environment
  - **S04** - Install Linux headers
  - **S05** - Remove Linux headers
  - **S06** - Install to another storage
  - **S07** - Manage SSH login options
  - **S08** - Enable read only filesystem
  - **S09** - Disable read only filesystem
  - **S10** - Set CPU speed and governor
  - **S11** - Set fan control options
  - **S12** - Manage device tree overlays


- ## **Network** 
  - **N01** - Configure network interfaces
  - **N02** - Install Bluetooth support
  - **N03** - Remove Bluetooth support
  - **N04** - Bluetooth Discover
  - **N05** - Toggle system IPv6/IPv4 internet protocol


- ## **Localisation** 
  - **L01** - Change Global timezone
  - **L02** - Change Locales reconfigure the language and character set
  - **L03** - Change Keyboard layout


- ## **Software** 
  - **SW01** - Desktop Environments
  - **SW02** - Network tools
  - **SW03** - Development tools
  - **SW04** - Install system updates


- ## **Help** 

## CLI options
Command line options.

Use:
~~~
fenix-config --help
~~~

Outputs:
~~~

  System - System wide and admin settings (aarch64)
    --cmd S01 - Enable Kernel/BSP upgrades
    --cmd S02 - Disable Kernel/BSP upgrades
    --cmd S03 - Edit the boot environment
    --cmd S04 - Install Linux headers
    --cmd S05 - Remove Linux headers
    --cmd S06 - Install to another storage
    S07 - Manage SSH login options
	--cmd S0701 - Disable root login
	--cmd S0702 - Enable root login
	--cmd S0703 - Disable password login
	--cmd S0704 - Enable password login
	--cmd S0705 - Disable Public key authentication login
	--cmd S0706 - Enable Public key authentication login
	--cmd S0707 - Disable OTP authentication
	--cmd S0708 - Enable OTP authentication
	--cmd S0709 - Generate new OTP authentication QR code
	--cmd S0710 - Show OTP authentication QR code
	--cmd S0711 - Disable last login banner
	--cmd S0712 - Enable last login banner
    --cmd S08 - Enable read only filesystem
    --cmd S09 - Disable read only filesystem
    S10 - Set CPU speed and governor
	--cmd S1001 - Disable CPU frequency utilities
	--cmd S1002 - Enable CPU frequency utilities
	--cmd S1003 - Set minimum CPU speed
	--cmd S1004 - Set maximum CPU speed
	--cmd S1005 - Set CPU scaling governor
    S11 - Set fan control options
	--cmd S1101 - Set fan mode
	--cmd S1102 - Set fan level
	--cmd S1103 - Show current fan status
    --cmd S12 - Manage device tree overlays

  Network - Fixed and wireless network settings (wlan0)
    --cmd N01 - Configure network interfaces
    --cmd N02 - Install Bluetooth support
    --cmd N03 - Remove Bluetooth support
    --cmd N04 - Bluetooth Discover
    --cmd N05 - Toggle system IPv6/IPv4 internet protocol

  Localisation - Localisation (en_US.UTF-8)
    --cmd L01 - Change Global timezone
    --cmd L02 - Change Locales reconfigure the language and character set
    --cmd L03 - Change Keyboard layout

  Software - Run/Install 3rd party applications (01:21:33)
    SW01 - Desktop Environments
	--cmd SW0101 - Install XFCE desktop
	--cmd SW0102 - Install Gnome desktop
	--cmd SW0103 - Install i3-wm desktop
	--cmd SW0104 - Install Cinnamon desktop
	--cmd SW0105 - Install kde-neon desktop
    SW02 - Network tools
	--cmd SW0201 - Install realtime console network usage monitor (nload)
	--cmd SW0202 - Remove realtime console network usage monitor (nload)
	--cmd SW0203 - Install bandwidth measuring tool (iperf3)
	--cmd SW0204 - Remove bandwidth measuring tool (iperf3)
	--cmd SW0205 - Install IP LAN monitor (iptraf-ng)
	--cmd SW0206 - Remove IP LAN monitor (iptraf-ng)
	--cmd SW0207 - Install hostname broadcast via mDNS (avahi-daemon)
	--cmd SW0208 - Remove hostname broadcast via mDNS (avahi-daemon)
    SW03 - Development tools
	--cmd SW0301 - Install tools for cloning and managing repositories (git)
	--cmd SW0302 - Remove tools for cloning and managing repositories (git)
	--cmd SW0303 - Install Docker
	--cmd SW0304 - Remove Docker
    --cmd SW04 - Install system updates
  --cmd Help - About this app
~~~

## Development

Development is divided into three sections:

Click for more info:

<details>
<summary><b>Jobs / JSON Object</b></summary>

A list of the jobs defined in the Jobs file.

 ### S01

Enable Kernel/BSP upgrades

Jobs:

~~~
fw_manipulate unhold
~~~

### S02

Disable Kernel/BSP upgrades

Jobs:

~~~
fw_manipulate hold
~~~

### S03

Edit the boot environment

Jobs:

~~~
nano /boot/uEnv.txt
~~~

### S04

Install Linux headers

Jobs:

~~~
headers_install
~~~

### S05

Remove Linux headers

Jobs:

~~~
headers_remove
~~~

### S06

Install to another storage

Jobs:

~~~
/usr/sbin/emmc-install
~~~

### S07

Manage SSH login options

Jobs:

~~~
No commands available
~~~

### S08

Enable read only filesystem

Jobs:

~~~
manage_overlayfs enable
~~~

### S09

Disable read only filesystem

Jobs:

~~~
manage_overlayfs disable
~~~

### S10

Set CPU speed and governor

Jobs:

~~~
No commands available
~~~

### S11

Set fan control options

Jobs:

~~~
No commands available
~~~

### S12

Manage device tree overlays

Jobs:

~~~
manage_dtoverlays
~~~

### N01

Configure network interfaces

Jobs:

~~~
nmtui-connect
~~~

### N02

Install Bluetooth support

Jobs:

~~~
see_current_apt 
debconf-apt-progress -- apt-get -y install bluetooth bluez bluez-tools
check_if_installed xserver-xorg && debconf-apt-progress -- apt-get -y --no-install-recommends install pulseaudio-module-bluetooth blueman
~~~

### N03

Remove Bluetooth support

Jobs:

~~~
see_current_apt 
debconf-apt-progress -- apt-get -y remove bluetooth bluez bluez-tools
check_if_installed xserver-xorg && debconf-apt-progress -- apt-get -y remove pulseaudio-module-bluetooth blueman
debconf-apt-progress -- apt -y -qq autoremove
~~~

### N04

Bluetooth Discover

Jobs:

~~~
connect_bt_interface
~~~

### N05

Toggle system IPv6/IPv4 internet protocol

Jobs:

~~~
toggle_ipv6 | show_infobox
~~~

### L01

Change Global timezone

Jobs:

~~~
dpkg-reconfigure tzdata
~~~

### L02

Change Locales reconfigure the language and character set

Jobs:

~~~
dpkg-reconfigure locales
source /etc/default/locale ; sed -i "s/^LANGUAGE=.*/LANGUAGE=$LANG/" /etc/default/locale
export LANGUAGE=$LANG
~~~

### L03

Change Keyboard layout

Jobs:

~~~
dpkg-reconfigure keyboard-configuration ; setupcon 
update-initramfs -u
~~~

### SW01

Desktop Environments

Jobs:

~~~
No commands available
~~~

### SW02

Network tools

Jobs:

~~~
No commands available
~~~

### SW03

Development tools

Jobs:

~~~
No commands available
~~~

### SW04

Install system updates

Jobs:

~~~
debconf-apt-progress -- apt update
debconf-apt-progress -- apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade -y
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
| Set root filesystem to read only | manage_overlayfs enable|disable | igorpecovnik 
| Remove Linux headers | headers_remove | Joey Turner 
| Display a menu from pipe | show_menu <<< armbianmonitor -h  ;  | Joey Turner 
| Install kernel headers | headers_install | Joey Turner 
| Migrated procedures from Armbian config. | is_package_manager_running | Igor Pecovnik 
| Migrated procedures from Armbian config. | check_desktop | Igor Pecovnik 
| Generate Document files. | generate_readme | Joey Turner 
| freeze/unhold/reinstall kernel & bsp related packages. | fw_manipulate unhold|freeze|reinstall | Igor Pecovnik 
| Needed by generate_menu |  | Joey Turner 
| Display a Yes/No dialog box and process continue/exit | get_user_continue 'Do you wish to continue?' process_input | Joey Turner 
| Display a menu a given list of options with a provided prompt | generic_select "true false" "Select an option" | Gunjan Gupta 
| Migrated procedures from Armbian config. | connect_bt_interface | Igor Pecovnik 
| Display a message box | show_message <<< 'hello world'  | Joey Turner 
| Menu for armbianmonitor features | see_monitoring | Joey Turner 
| Enable/disable device tree overlays | manage_dtoverlays | Gunjan Gupta 
| Show or generate QR code for Google OTP | qr_code generate | Igor Pecovnik 
| Check if kernel headers are installed | are_headers_installed | Gunjan Gupta 
| Check when apt list was last updated | see_current_apt | Joey Turner 
| Migrated procedures from Armbian config. | check_if_installed nano | Igor Pecovnik 
| Generate 'Armbian CPU logo' SVG for document file. | generate_svg | Joey Turner 
| Displays available adapters | choose_adapter | Igor Pecovnik 
| Update submenu descriptions based on conditions | update_submenu_data | Joey Turner 
| sanitize input cli | sanitize_input |  
| Check if a domain is reachable via IPv4 and IPv6 | check_ip_version google.com | Joey Turner 
| Generate a submenu from a parent_id | generate_menu 'parent_id' | Joey Turner 
| Install docker | install_docker | Gunjan Gupta 
| Generate a markdown list json objects using jq. | see_jq_menu_list | Joey Turner 
| Generate jobs from JSON file. | generate_jobs_from_json | Joey Turner 
| Set up a WiFi hotspot on the device | hotspot_setup | Joey Turner 
| Toggle IPv6 on or off | toggle_ipv6 | Joey Turner 
| Generate JSON-like object file. | generate_json | Joey Turner 
| Install DE | install_de | Igor Pecovnik 
| Change the background color of the terminal or dialog box | set_colors 0-7 | Joey Turner 
| Serve the edit and debug server. | serve_doc | Joey Turner 
| Update JSON data with system information | update_json_data | Joey Turner 
| pipeline strings to an infobox  | show_infobox <<< 'hello world' ;  | Joey Turner 
| Remove docker | remove_docker | Gunjan Gupta 
| Parse json to get list of desired menu or submenu items | parse_menu_items 'menu_options_array' | Gunjan Gupta 
| Show the usage of the functions. | see_use | Joey Turner 
| Set cpufreq options like minimum/maximum speed and governor | set_cpufreq_option MIN_SPEED|MAX_SPEED|GOVERNOR | Gunjan Gupta 
| Set fan control options | set_fan_controls [mode|level] | Gunjan Gupta 
| List and connect to wireless network | wifi_connect | Igor Pecovnik 
| Generate a Help message for cli commands. | see_cmd_list [catagory] | Joey Turner 
| Check the internet connection with fallback DNS | see_ping | Joey Turner 
| Update the /etc/skel files in users directories | update_skel | Igor Pecovnik 
| Set Armbian to stable release | set_stable | Tearran 
| Secure version of get_user_continue | get_user_continue_secure 'Do you wish to continue?' process_input | Joey Turner 


</details>


<details>


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
    git clone https://github.com/khadas/fenix-config -b configng
    cd fenix-config
    ./fenix-config --help
}
~~~

</details>


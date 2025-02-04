#!/bin/bash




module_options+=(
["check_desktop,author"]="Igor Pecovnik"
["check_desktop,ref_link"]=""
["check_desktop,feature"]="check_desktop"
["check_desktop,desc"]="Check if a desktop manager is installed."
["check_desktop,example"]="check_desktop"
["check_desktop,status"]="Active"
["check_desktop,doc_link"]=""
)
#
# read desktop parameters
#
function check_desktop() {

	DISPLAY_MANAGER=""; DESKTOP_INSTALLED=""
	check_if_installed nodm && DESKTOP_INSTALLED="nodm";
	check_if_installed lightdm && DESKTOP_INSTALLED="lightdm";
	check_if_installed lightdm && DESKTOP_INSTALLED="gnome";
	[[ -n $(service lightdm status 2> /dev/null | grep -w active) ]] && DISPLAY_MANAGER="lightdm"
	[[ -n $(service nodm status 2> /dev/null | grep -w active) ]] && DISPLAY_MANAGER="nodm"
	[[ -n $(service gdm status 2> /dev/null | grep -w active) ]] && DISPLAY_MANAGER="gdm"

}


module_options+=(
["check_if_installed,author"]="Igor Pecovnik"
["check_if_installed,ref_link"]=""
["check_if_installed,feature"]="check_if_installed"
["check_if_installed,desc"]="Check if a given package is installed"
["check_if_installed,example"]="check_if_installed nano"
["check_if_installed,status"]="Active"
)
#
# check dpkg status of $1 -- currently only 'not installed at all' case caught
#
function check_if_installed (){

        local DPKG_Status="$(dpkg -s "$1" 2>/dev/null | awk -F": " '/^Status/ {print $2}')"
        if [[ "X${DPKG_Status}" = "X" || "${DPKG_Status}" = *deinstall* ]]; then
                return 1
        else
                return 0
        fi

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
["is_package_manager_running,author"]="Igor Pecovnik"
["is_package_manager_running,ref_link"]=""
["is_package_manager_running,feature"]="is_package_manager_running"
["is_package_manager_running,desc"]="Check if package manager is already running in the background"
["is_package_manager_running,example"]="is_package_manager_running"
["is_package_manager_running,status"]="Active"
)
#
# check if package manager is doing something
#
function is_package_manager_running() {

	if ps -C apt-get,apt,dpkg >/dev/null ; then
		[[ -z $scripted ]] && echo -e "\nPackage manager is running in the background. \n\nCan't install dependencies. Try again later." | show_infobox
		return 0
	else
		return 1
	fi

}


module_options+=(
["set_runtime_variables,author"]="Igor Pecovnik"
["set_runtime_variables,ref_link"]=""
["set_runtime_variables,feature"]="set_runtime_variables"
["set_runtime_variables,desc"]="Run time variables Migrated procedures from Armbian config."
["set_runtime_variables,example"]="set_runtime_variables"
["set_runtime_variables,status"]="Active"
)
#
# gather info about the board and start with loading menu variables
#
function set_runtime_variables(){

	missing_dependencies=()

	# Check if whiptail is available and set DIALOG
	if [[ -z "$DIALOG" ]]; then
	    missing_dependencies+=("whiptail")
	fi

	# Check if jq is available
	if ! [[ -x "$(command -v jq)" ]]; then
	    missing_dependencies+=("jq")
	fi

	# If any dependencies are missing, print a combined message and exit
	if [[ ${#missing_dependencies[@]} -ne 0 ]]; then
		if is_package_manager_running; then
			sudo apt install ${missing_dependencies[*]}
		fi
	fi

	DIALOG_CANCEL=1
	DIALOG_ESC=255

	# we have our own lsb_release which does not use Python. Others shell install it here
	if [[ ! -f /usr/bin/lsb_release ]]; then
		if is_package_manager_running; then
			sleep 3
		fi
		debconf-apt-progress -- apt-get update
		debconf-apt-progress -- apt -y -qq --allow-downgrades --no-install-recommends install lsb-release
	fi

	[[ -f /etc/fenix-release ]] && source /etc/fenix-release && BACKTITLE="Fenix $VERSION - ";
	DISTRO=$(lsb_release -is)
	DISTROID=$(lsb_release -sc)
	KERNELID=$(uname -r)
	BACKTITLE+="$DISTRO $DISTROID"
	DEFAULT_ADAPTER=$(ip -4 route ls | grep default | tail -1 | grep -Po '(?<=dev )(\S+)')
	LOCALIPADD=$(ip -4 addr show dev $DEFAULT_ADAPTER | awk '/inet/ {print $2}' | cut -d'/' -f1)
	TITLE="Fenix configuration utility"
	[[ -z "${DEFAULT_ADAPTER// }" ]] && DEFAULT_ADAPTER="lo"

	# detect desktop
	check_desktop

}


module_options+=(
["fw_manipulate,author"]="Igor Pecovnik"
["fw_manipulate,ref_link"]=""
["fw_manipulate,feature"]="fw_manipulate"
["fw_manipulate,desc"]="freeze/unhold/reinstall kernel & bsp related packages."
["fw_manipulate,example"]="fw_manipulate unhold|freeze|reinstall"
["fw_manipulate,status"]="Active"
)
#
# freeze/unhold/reinstall kernel & bsp related packages
#
fw_manipulate() {

	function=$1

	SUPPORTED_PACKAGES=(
	    "linux-u-boot-${BOARD@L}-vendor"
        "linux-u-boot-${BOARD@L}-mainline"
        "linux-image-${VENDOR@L}-${kernel_version}"
        "linux-dtb-${VENDOR@L}-${kernel_version}"
        "linux-headers-${VENDOR@L}-${kernel_version}"
        "linux-board-package-${DISTROID}-${BOARD@L}"
        "fenix-${DISTRO@L}-${DISTROID}-gnome-desktop"
        "fenix-${DISTRO@L}-${DISTROID}-lxde-desktop"
        "fenix-${DISTRO@L}-${DISTROID}-xfce-desktop"
        "linux-gpu-mali-wayland"
        "linux-gpu-mali-gbm"
        "linux-gpu-mali-fbdev"
	)

	if [[ "${function}" == reinstall ]]; then
		debconf-apt-progress -- apt-get update
	fi

	PACKAGES=""
	for PACKAGE in "${SUPPORTED_PACKAGES[@]}"
	do
			if [[ "${function}" == reinstall ]]; then
				apt search $PACKAGE 2>/dev/null | grep "^$PACKAGE" >/dev/null
				if [[ $? -eq 0 ]]; then
                    PACKAGES+="$PACKAGE ";
                fi
			else
				if check_if_installed $PACKAGE; then
				    PACKAGES+="$PACKAGE "
				fi
			fi
	done

	case $function in
		unhold)            apt-mark unhold ${PACKAGES} | show_infobox ;;
		hold)              apt-mark hold ${PACKAGES} | show_infobox ;;
		reinstall)
					debconf-apt-progress -- apt-get -y --download-only install ${PACKAGES}
					debconf-apt-progress -- apt-get -y purge ${PACKAGES}
					debconf-apt-progress -- apt-get -y install ${PACKAGES}
					debconf-apt-progress -- apt-get -y autoremove
		;;
		*) return ;;
	esac

}


# Start of config ng

module_options+=(
["set_colors,author"]="Joey Turner"
["set_colors,ref_link"]=""
["set_colors,feature"]="set_colors"
["set_colors,desc"]="Change the background color of the terminal or dialog box"
["set_colors,example"]="set_colors 0-7"
["set_colors,doc_link"]=""
["set_colors,status"]="Active"
)
#
# Function to set the tui colors
#
function set_colors() {
    local color_code=$1

    if [ "$DIALOG" = "whiptail" ]; then
        set_newt_colors "$color_code"
         #echo "color code: $color_code" | show_infobox ;
    elif [ "$DIALOG" = "dialog" ]; then
        set_term_colors "$color_code"
    else
        echo "Invalid dialog type"
        return 1
    fi
}


#
# Function to set the colors for newt
#
function set_newt_colors() {
    local color_code=$1
    case $color_code in
        0) color="black" ;;
        1) color="red" ;;
        2) color="green" ;;
        3) color="yellow" ;;
        4) color="blue" ;;
        5) color="magenta" ;;
        6) color="cyan" ;;
        7) color="white" ;;
        8) color="black" ;;
        9) color="red" ;;
        *) return ;;
    esac
    export NEWT_COLORS="root=,$color"
}


#
# Function to set the colors for terminal
#
function set_term_colors() {
    local color_code=$1
    case $color_code in
        0) color="\e[40m" ;;  # black
        1) color="\e[41m" ;;  # red
        2) color="\e[42m" ;;  # green
        3) color="\e[43m" ;;  # yellow
        4) color="\e[44m" ;;  # blue
        5) color="\e[45m" ;;  # magenta
        6) color="\e[46m" ;;  # cyan
        7) color="\e[47m" ;;  # white
        *) echo "Invalid color code"; return 1 ;;
    esac
    echo -e "$color"
}


#
# Function to reset the colors
#
function reset_colors() {
    echo -e "\e[0m"
}


module_options+=(
["parse_menu_items,author"]="Gunjan Gupta"
["parse_menu_items,ref_link"]=""
["parse_menu_items,feature"]="parse_menu_items"
["parse_menu_items,desc"]="Parse json to get list of desired menu or submenu items"
["parse_menu_items,example"]="parse_menu_items 'menu_options_array'"
["parse_menu_items,doc_link"]=""
["parse_menu_items,status"]="Active"
)
#
# Function to parse the menu items
#
parse_menu_items() {
    local -n options=$1
    while IFS= read -r id
    do
        IFS= read -r description
        IFS= read -r condition
        # If the condition field is not empty and not null, run the function specified in the condition
        if [[ -n $condition && $condition != "null" ]]; then
            # If the function returns a truthy value, add the menu item to the menu
            if eval $condition; then
                options+=("$id" "  -  $description")
            fi
        else
            # If the condition field is empty or null, add the menu item to the menu
            options+=("$id" "  -  $description ")
        fi
    done < <(echo "$json_data" | jq -r '.menu[] | '${parent_id:+".. | objects | select(.id==\"$parent_id\") | .sub[]? |"}' select(.disabled|not) | "\(.id)\n\(.description)\n\(.condition)"' || exit 1 )
}


module_options+=(
["generate_menu,author"]="Joey Turner"
["generate_menu,ref_link"]=""
["generate_menu,feature"]="generate_menu"
["generate_menu,desc"]="Generate a submenu from a parent_id"
["generate_menu,example"]="generate_menu 'parent_id'"
["generate_menu,doc_link"]=""
["generate_menu,status"]="Active"
)
#
# Function to generate the submenu
#
function generate_menu() {
    [ $# -eq 1 ] && local parent_id=$1

    while true; do
        # Get the submenu options for the current parent_id
        local menu_options=()
        local back_btn_text="Back"
        [ $# -eq 0 ] && back_btn_text="Exit"

        parse_menu_items menu_options

        local OPTION=$($DIALOG --title "$TITLE" --menu "" 0 80 9 "${menu_options[@]}" \
                                --ok-button Select --cancel-button $back_btn_text 3>&1 1>&2 2>&3)

        local exitstatus=$?

        if [ $exitstatus = 0 ]; then
            [ -z "$OPTION" ] && break

            # Check if the selected option has a submenu
            local submenu_count=$(jq -r --arg id "$OPTION" '.menu[] | .. | objects | select(.id==$id) | .sub? | length' "$json_file")
            submenu_count=${submenu_count:-0}  # If submenu_count is null or empty, set it to 0
            if [ "$submenu_count" -gt 0 ]; then
                # If it does, generate a new menu for the submenu
                [[ -n "$debug" ]] && echo "$OPTION"
                generate_menu "$OPTION"
            else
                # If it doesn't, execute the command
                [[ -n "$debug" ]] &&  echo "$OPTION"
                execute_command "$OPTION"
            fi
        fi
    done
}


module_options+=(
["execute_command,author"]="Joey Turner"
["execute_command,ref_link"]=""
["execute_command,feature"]="execute_command"
["execute_command,desc"]="Needed by generate_menu"
["execute_command,example"]=""
["execute_command,doc_link"]=""
["execute_command,status"]="Active"
)
#
# Function to execute the command
#
function execute_command() {
    local id=$1

    # Extract commands
    local commands=$(jq -r --arg id "$id" '
      .menu[] | 
      .. | 
      objects | 
      select(.id == $id) | 
      .command[]?' "$json_file")

    # Check if a prompt exists
    local prompt=$(jq -r --arg id "$id" '
      .menu[] | 
      .. | 
      objects | 
      select(.id == $id) | 
      .prompt?' "$json_file")

    # If a prompt exists, display it and wait for user confirmation
    if [[ "$prompt" != "null" && $INPUTMODE != "cmd" ]]; then
        if ! get_user_continue "$prompt"; then
            return
        fi
    fi

    # Execute each command
    for command in "${commands[@]}"; do
        [[ -n "$debug" ]] && echo "$command"
        eval "$command"
    done
}

module_options+=(
["show_message,author"]="Joey Turner"
["show_message,ref_link"]=""
["show_message,feature"]="show_message"
["show_message,desc"]="Display a message box"
["show_message,example"]="show_message <<< 'hello world' "
["show_message,doc_link"]=""
["show_message,status"]="Active"
)
#
# Function to display a message box
#
function show_message() {
    # Read the input from the pipe
    input=$(cat)

    # Display the "OK" message box with the input data
    if [[ $DIALOG != "bash" ]]; then
        $DIALOG  --title "$TITLE"  --msgbox "$input" 0 0
    else
        echo -e "$input"
        read -p -r "Press [Enter] to continue..."
    fi
}


module_options+=(
["show_infobox,author"]="Joey Turner"
["show_infobox,ref_link"]=""
["show_infobox,feature"]="show_infobox"
["show_infobox,desc"]="pipeline strings to an infobox "
["show_infobox,example"]="show_infobox <<< 'hello world' ; "
["show_infobox,doc_link"]=""
["show_infobox,status"]="Active"
)
#
# Function to display an infobox with a message
#
function show_infobox() {
    export TERM=ansi
    local input
    local -a buffer  # Declare buffer as an array
    if [ -p /dev/stdin ]; then
        while IFS= read -r line; do
            buffer+=("$line")  # Add the line to the buffer
            # If the buffer has more than 10 lines, remove the oldest line
            if (( ${#buffer[@]} > 18 )); then
                buffer=("${buffer[@]:1}")
            fi
            # Display the lines in the buffer in the infobox

            TERM=ansi $DIALOG --title "$TITLE" --infobox "$(printf "%s\n" "${buffer[@]}" )" 16 90
            sleep 0.5
        done
    else

        input="$1"
        TERM=ansi $DIALOG --title "$TITLE" --infobox "$input" 6 80
    fi
        echo -ne '\033[3J' # clear the screen
}


module_options+=(
["show_menu,author"]="Joey Turner"
["show_menu,ref_link"]=""
["show_menu,feature"]="show_menu"
["show_menu,desc"]="Display a menu from pipe"
["show_menu,example"]="show_menu <<< armbianmonitor -h  ; "
["show_menu,doc_link"]=""
["show_menu,status"]="Active"
)
#
#
#
show_menu(){

    # Get the input and convert it into an array of options
    inpu_raw=$(cat)
    # Remove the lines before -h 
	input=$(echo "$inpu_raw" | sed 's/-\([a-zA-Z]\)/\1/' | grep '^  [a-zA-Z] ' | grep -v '\[')
    options=()
    while read -r line; do
        package=$(echo "$line" | awk '{print $1}')
        description=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ *//')
        options+=("$package" "$description")
    done <<< "$input"

    # Display the menu and get the user's choice
    [[ $DIALOG != "bash" ]] && choice=$($DIALOG --title "Menu" --menu "Choose an option:" 0 0 9 "${options[@]}" 3>&1 1>&2 2>&3)

	# Check if the user made a choice
	if [ $? -eq 0 ]; then
	    echo "$choice"
	else
	    exit 0
	fi 

}


module_options+=(
["generic_select,author"]="Gunjan Gupta"
["generic_select,ref_link"]=""
["generic_select,feature"]="generic_select"
["generic_select,desc"]="Display a menu a given list of options with a provided prompt"
["generic_select,example"]="generic_select \"true false\" \"Select an option\""
["generic_select,doc_link"]=""
["generic_select,status"]="Active"
)
#
#  Display a menu a given list of options with a provided prompt
#
function generic_select()
{
	IFS=$' '
	PARAMETER=($1)
	local LIST=()
	for i in "${PARAMETER[@]}"
	do
		if [[ -n $3 ]]; then
			[[ ${i[0]} -ge $3 ]] && \
			LIST+=( "${i[0]//[[:blank:]]/}" "" )
		else
			LIST+=( "${i[0]//[[:blank:]]/}" "" )
		fi
	done
	LIST_LENGTH=$((${#LIST[@]}/2));
	if [ "$LIST_LENGTH" -eq 1 ]; then
		PARAMETER=${LIST[0]}
	else
		PARAMETER=$($DIALOG --title "$2" --menu "" 0 0 9 "${LIST[@]}" 3>&1 1>&2 2>&3)
	fi
}


module_options+=(
["get_user_continue,author"]="Joey Turner"
["get_user_continue,ref_link"]=""
["get_user_continue,feature"]="get_user_continue"
["get_user_continue,desc"]="Display a Yes/No dialog box. Returns 0 or 1 depending on the user choice"
["get_user_continue,example"]="get_user_continue 'Do you wish to continue?'"
["get_user_continue,doc_link"]=""
["get_user_continue,status"]="Active"
)
#
# Function to display a Yes/No dialog box
#
function get_user_continue() {
    local message="$1"
    local next_action="$2"

    if $($DIALOG --yesno "$message" 10 80 3>&1 1>&2 2>&3); then
        return 0
    else
        return 1
    fi
}


module_options+=(
["see_ping,author"]="Joey Turner"
["see_ping,ref_link"]=""
["see_ping,feature"]="see_ping"
["see_ping,desc"]="Check the internet connection with fallback DNS"
["see_ping,example"]="see_ping"
["see_ping,doc_link"]=""
["see_ping,status"]="Active"
)
#
# Function to check the internet connection
#
function see_ping() {
	# List of servers to ping
	servers=("1.1.1.1" "8.8.8.8")

	# Check for internet connection
	for server in "${servers[@]}"; do
	    if ping -q -c 1 -W 1 $server >/dev/null; then
	        echo "Internet connection: Present"
			break
	    else
	        echo "Internet connection: Failed"
			sleep 1
	    fi
	done

	if [[ $? -ne 0 ]]; then
		read -n -r 1 -s -p "Warning: Configuration cannot work properly without a working internet connection. \
		Press CTRL C to stop or any key to ignore and continue."
	fi

}


module_options+=(
["see_current_apt,author"]="Joey Turner"
["see_current_apt,ref_link"]=""
["see_current_apt,feature"]="see_current_apt"
["see_current_apt,desc"]="Check when apt list was last updated"
["see_current_apt,example"]="see_current_apt"
["see_current_apt,doc_link"]=""
["see_current_apt,status"]="Active"
)
#
# Function to check when the package list was last updated
#
see_current_apt() {
    # Number of seconds in a day
    local day=86400

    # Get the current date as a Unix timestamp
    local now=$(date +%s)

    # Get the timestamp of the most recently updated file in /var/lib/apt/lists/
    local update=$(stat -c %Y /var/lib/apt/lists/* | sort -n | tail -1)

    # Calculate the number of seconds since the last update
    local elapsed=$(( now - update ))

    if ps -C apt-get,apt,dpkg >/dev/null; then
        echo "A pkg is running."
        export running_pkg="true"
        return 1  # The processes are running
    else
        export running_pkg="false"
        #echo "apt, apt-get, or dpkg is not currently running"
    fi
    # Check if the package list is up-to-date
    if (( elapsed < day )); then
        #echo "Checking for apt-daily.service"
        echo "$(date -u -d @${elapsed} +"%T")"
        return 0  # The package lists are up-to-date
    else
        #echo "Checking for apt-daily.service"
        echo "Update the package lists"
        return 1  # The package lists are not up-to-date
    fi
}

module_options+=(
["are_headers_installed,author"]="Gunjan Gupta"
["are_headers_installed,ref_link"]=""
["are_headers_installed,feature"]="are_headers_installed"
["are_headers_installed,desc"]="Check if kernel headers are installed"
["are_headers_installed,example"]="are_headers_installed"
["are_headers_installed,status"]="Pending Review"
["are_headers_installed,doc_link"]=""
)
#
# @description Install kernel headers
#
function are_headers_installed () {
    if [[ -f /etc/fenix-release ]]; then
        local kernel_version=$(uname -r | cut -f 1-2 -d.)
        PKG_NAME="linux-headers-${VENDOR@L}-${kernel_version}";
    else
        PKG_NAME="linux-headers-$(uname -r | sed 's/'-$(dpkg --print-architecture)'//')";
    fi

    check_if_installed ${PKG_NAME}
    return $?
}


module_options+=(
["headers_install,author"]="Joey Turner"
["headers_install,ref_link"]=""
["headers_install,feature"]="headers_install"
["headers_install,desc"]="Install kernel headers"
["headers_install,example"]="headers_install"
["headers_install,status"]="Pending Review"
["headers_install,doc_link"]=""
)
#
# @description Install kernel headers
#
function headers_install () {
	if ! is_package_manager_running; then
	  if [[ -f /etc/fenix-release ]]; then
	    INSTALL_PKG="linux-headers-${VENDOR@L}-${kernel_version}";
	    else
	    INSTALL_PKG="linux-headers-$(uname -r | sed 's/'-$(dpkg --print-architecture)'//')";
	  fi
	  debconf-apt-progress -- apt-get -y install ${INSTALL_PKG}
	fi
}

module_options+=(
["headers_remove,author"]="Joey Turner"
["headers_remove,ref_link"]="https://github.com/armbian/config/blob/master/debian-config-jobs#L160"
["headers_remove,feature"]="headers_remove"
["headers_remove,desc"]="Remove Linux headers"
["headers_remove,example"]="headers_remove"
["headers_remove,status"]="Pending Review"
["headers_remove,doc_link"]="https://github.com/armbian/config/wiki#System"
)
#
# @description Remove Linux headers
#
function headers_remove () {
	if ! is_package_manager_running; then
		REMOVE_PKG="linux-headers-*"
		if [[ -n $(dpkg -l | grep linux-headers) ]]; then
			debconf-apt-progress -- apt-get -y purge ${REMOVE_PKG}
			rm -rf /usr/src/linux-headers*
		fi
		# cleanup
		apt clean
		debconf-apt-progress -- apt -y autoremove
	fi
}

module_options+=(
["sanitize_input,author"]=""
["sanitize_input,ref_link"]=""
["sanitize_input,feature"]="sanitize_input"
["sanitize_input,desc"]="sanitize input cli"
["sanitize_input,example"]="sanitize_input"
["sanitize_input,status"]="Pending Review"
["sanitize_input,doc_link"]=""
)
#
# sanitize input cli
#
sanitize_input() {
    local sanitized_input=()
    for arg in "$@"; do
        if [[ $arg =~ ^[a-zA-Z0-9_=]+$ ]]; then
            sanitized_input+=("$arg")
        else
            echo "Invalid argument: $arg"
            exit 1
        fi
    done
    echo "${sanitized_input[@]}"
}

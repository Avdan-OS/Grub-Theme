#!/bin/bash
ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME="AvdanOS-Grub-Theme"


# Colors
CDEF=" \033[0m"      # Default color
CCIN=" \033[0;36m"   # Info color
CGSC=" \033[0;32m"   # Success color
CRER=" \033[0;31m"   # Error color
CWAR=" \033[0;33m"   # Warning color
b_CDEF=" \033[1;37m" # Bold default color
b_CCIN=" \033[1;36m" # Bold info color
b_CGSC=" \033[1;32m" # Bold success color
b_CRER=" \033[1;31m" # Bold error color
b_CWAR=" \033[1;33m"

prompt () {
    case ${1} in
        "-s"|"--success")
        echo -e "${b_CGSC}${@/-s/}${CDEF}";; # Print success message
        "-e"|"--error")
        echo -e "${b_CRER}${@/-e/}${CDEF}";; # Print error message
        "-w"|"--warning")
        echo -e "${b_CWAR}${@/-w/}${CDEF}";; # Print warning message
        "-i"|"--info")
        echo -e "${b_CCIN}${@/-i/}${CDEF}";; # Print info message
        *)
            echo -e "$@"
        ;;
    esac
}


# Checking command availability
function has_command() {
    command -v $1 > /dev/null
}

# Checking for root access
prompt -w "\nChecking for root access...\n"

if [ "$UID" -eq "$ROOT_UID" ]; then

    # Create themes directory if not exists
    [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
    mkdir -p "${THEME_DIR}/${THEME_NAME}"
    prompt -i "\nChecking for the existence of themes directory...\n"
    
    # Copy theme   
    cp -a ../src/* ${THEME_DIR}/${THEME_NAME}
    prompt -i "\nInstalling the theme...\n"
    
    # Set theme
    prompt -i "\nSetting ${THEME_NAME} as default...\n"
    
    # Backup grub config
    cp -an /etc/default/grub /etc/default/grub.bak
    
    grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub

    # Set kernel parameters for quiet boot
    sed -i 's/.*GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vt.global_cursor_default=0 loglevel=2 rd.systemd.show_status=false rd.udev.log-priority=3 sysrq_always_enabled=1 fbcon=nodefer"/' /etc/default/grub
    
    # Disable grub kernel loading text
    sed -i 's/.*$message.*/#/' /etc/grub.d/10_linux

        
    prompt -i "\n Finalizing your installation .......\n \n."
    # Update grub config
    echo -e "Updating grub config..."
    grub-mkconfig -o /boot/grub/grub.cfg
    
    
    # Success message
    prompt -s "\n\t          ****************************\n\t          * Grub theme successfully installed!  *\n\t          ****************************\n" 
else
    # Error message
    prompt -e "\n [ Error! ] -> For installing the grub theme you have to be root! \n \n " 
fi

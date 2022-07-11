#!/bin/bash
ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME="AvdanOS-Grub-Theme"



#colors

CDEF=" \033[0m"     # default color
CCIN=" \033[0;36m"  # info color
CGSC=" \033[0;32m"  # success color
CRER=" \033[0;31m"  # error color
CWAR=" \033[0;33m"  # warning color
b_CDEF=" \033[1;37m"# bold default color
b_CCIN=" \033[1;36m"# bold info color
b_CGSC=" \033[1;32m"# bold success color
b_CRER=" \033[1;31m"# bold error color
b_CWAR=" \033[1;33m"

prompt () {
    case ${1} in
        "-s"|"--success")
        echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # print success message
        "-e"|"--error")
        echo -e "${b_CRER}${@/-e/}${CDEF}";;          # print error message
        "-w"|"--warning")
        echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # print warning message
        "-i"|"--info")
        echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # print info message
        *)
            echo -e "$@"
        ;;
    esac
}


# checking command availability
function has_command() {
    command -v $1 > /dev/null
}

#checking for root access
prompt -w "\nChecking for root access...\n"
if [ "$UID" -eq "$ROOT_UID" ]; then
    # Create themes directory if not exists
    prompt -i "\nChecking for the existence of themes directory...\n"
    [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
    mkdir -p "${THEME_DIR}/${THEME_NAME}"
    
    
    #copy theme
    prompt -i "\nInstalling the theme...\n"
    cp -a ../src/* ${THEME_DIR}/${THEME_NAME}
    
    
    #set theme
    prompt -i "\nSetting ${THEME_NAME} as default...\n"
    
    # Backup grub config
    cp -an /etc/default/grub /etc/default/grub.bak
    
    grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
    
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
    
    
    
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


#!/usr/bin/env bash 

# Variables 

USER_NAME=$(who am i | awk {'print $1'})
VIMRC_LOC=$(find /home/$USER_NAME -iname ".vimrc")
START_PWD=$PWD

# Vimrc installer function
function vimrc_installer(){
    echo "$(tput setaf 2)[+] Installing 'vim-plug' ..."
    sleep 1
    curl -fLo /home/$USER_NAME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp vimrc_file .vimrc
    mv .vimrc $VIMRC_LOC
    sed -i 's/iman/'"$USER_NAME"'/g' $VIMRC_LOC
    echo "$(tput setaf 2)[+] Adding 'molokai' colorscheme ..."
    if [ ! -d /home/$USER_NAME/.vim/colors ];then
        mkdir /home/$USER_NAME/.vim/colors 
    fi
    mv molokai.vim /home/$USER_NAME/.vim/colors
    echo "$(tput setaf 2)[+] Opening tmp.file for Plugin Installer ..."
    sleep 1.5
    vim +'PlugInstall' tmp.file
    
    echo "$(tput setaf 2)[✔] Vimrc installed successfully!"
} 

# C-support plugin installer function 
function cvim_installer(){ 
    if [ ! -d /home/$USER_NAME/.vim/c-support ];then
        wget -O cvim.zip https://www.vim.org/scripts/download_script.php?src_id=21803 
        cd /home/$USER_NAME/.vim
        echo "$(tput setaf 2)[+] Extracting cvim.zip ..."
        unzip $START_PWD/cvim.zip
        if [ "$?" = 0 ];then 
            echo "$(tput setaf 2)[✔] C-support installation done !"
        else 
            echo -e "$(tput setaf 1)[✗] Unzip package not found ...\nInstall unzip from your repo and try 'fix_cvim' Option." 
            exit -1
        fi
    else 
        echo "$(tput setaf 1)[✗] C-support plugin exist !"
    fi
}

# for unzip package missing
function fix_cvim(){
    cd /home/$USER_NAME/.vim
    unzip $START_PWD/cvim.zip
        if [ "$?" = 0 ];then 
            echo "$(tput setaf 2)[✔] C-support installation done !"
        else 
            echo -e "$(tput setaf 1)[✗] Unzip package not found ...\nInstall unzip from your repo and try 'fix_cvim' Option." 
        fi
}

# Help function
function help(){
    echo "Usage: ./installer [OPTION]

      all         Install vimrc plugins and setup configurations,add c-support plugin too
      only-vim    Install vimrc plugins and setup configurations only
      only-cvim   Install c-support file and add plugin only
      help        display this help and exit"
}

# Main

# Creating directory ~/.vim directory  

if [ "$1" != "help" ];then
    if [ ! -d /home/$USER_NAME/.vim ];then
        mkdir /home/$USER_NAME/.vim 
    fi
fi

case "$1" in 
   only-vimrc)
        vimrc_installer
        ;;
   only-cvim)
        cvim_installer 
        echo "$(tput setaf 1)[!] Add this line in ~/.vimrc file if not exist 
        :filetype plugin on"
        ;;
   fix_cvim)
        fix_cvim
        ;;
    all)
        vimrc_installer
        cvim_installer
        ;;
    help)
        help
        ;;
    *)
        echo "installer.sh: missing operand
Try './installer.sh help' for more information."
            exit -1
esac

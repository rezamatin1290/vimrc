#!/usr/bin/env bash 

# Variables 
START_PWD=$PWD
VIMRC_LOC=$(find /home -iname ".vimrc" 2> /dev/null)

# Check root function 
function checkRoot(){
    if [ "$EUID" = "0" ];then
        echo "$(tput setaf 1)Run script as your privilage.(without sudo)"
        exit -1
    fi
}

# Vimrc installer function
function vimrc_installer(){
    if [ ! -d ~/.vim ];then
        mkdir ~/.vim 
    fi
    echo "$(tput setaf 2)[+] Installing 'vim-plug' ..."
    sleep 1
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp vimrc $VIMRC_LOC
    sed -i 's/iman/'"$USER"'/g' ~/.vimrc
    echo "$(tput setaf 2)[+] Adding 'molokai' colorscheme ..."
    if [ ! -d ~/.vim/colors ];then
        mkdir ~/.vim/colors 
    fi
    cp molokai.vim ~/.vim/colors
    echo "$(tput setaf 2)[+] Opening tmp.file for Plugin Installer ..."
    sleep 1.5
    vim +'PlugInstall' tmp.file
    if [ "$?" = 0 ];then 
        echo "$(tput setaf 2)[✔] Vimrc installed successfully!"
    else 
        echo "$(tput setaf 1)[✗] Vimrc installation falied!"
    fi
} 

# C-support plugin installer function 
function cvim_installer(){ 
    if [ ! -d ~/.vim ];then
        mkdir ~/.vim 
    fi
    
    if [ ! -d ~/.vim/c-support ];then
        wget -O cvim.zip https://www.vim.org/scripts/download_script.php?src_id=21803 
        cd ~/.vim
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
        exit -1
    fi
}

# for unzip package missing
function fix_cvim(){
    cd ~/.vim
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

# Checking user privilage
checkRoot

# Switch case for ./installer argument 
case "$1" in 
   only-vimrc)
        vimrc_installer
        ;;
   only-cvim)
        cvim_installer 
        if [ "$?" = "0" ];then
            echo "$(tput setaf 1)[!] Add this line in $VIMRC_LOC file if is not exist 
            :filetype plugin on"
        fi
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

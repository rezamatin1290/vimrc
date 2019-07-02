#!/usr/bin/env bash 

USER_NAME=$(who am i | awk {'print $1'})

if [ "$1" != "help" ];then
    if [ ! -d /home/$USER_NAME/.vim ];then
        mkdir /home/$USER_NAME/.vim 
    fi
fi

function vimrc_installer(){
    echo "$(tput setaf 2)[+] Installing 'vim-plug' ..."
    sleep 1
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mv vimrc_file /home/$USER_NAME/.vimrc
    echo "$(tput setaf 2)[+] Opening tmp.file for Plugin Installer ..."
    sleep 1.5
    vim +'PlugInstall' tmp.file
    echo "$(tput setaf 2)[✔] Vimrc installed successfully!"
}
function cvim_installer(){ 
    wget -O cvim.zip https://www.vim.org/scripts/download_script.php?src_id=21803 
    OLD_PWD=$PWD
    cd /home/$USER_NAME/.vim
    echo "$(tput setaf 2)[+] Extracting cvim.zip ..."
    unzip $OLD_PWD/cvim.zip
    echo "$(tput setaf 2)[✔] C-support installation done !"
}
function help(){
    echo "Usage: ./installer [OPTION]

      all         Install vimrc plugins and setup configurations,add c-support plugin too
      only-vim    Install vimrc plugins and setup configurations only
      only-cvim   Install c-support file and add plugin only"
}

function main(){
    case $1 in 
        only-vimrc)
            vimrc_installer
            ;;

        only-cvim)
            cvim_installer
            grep ':filetype plugin on' /home/$USER_NAME/.vimrc | sed '1d'
            echo ":filetype plugin on" >>  /home/$USER_NAME/.vimrc
            ;;

        all)
            vimrc_installer
            cvim_installer
            ;;
        *)
            help 
            ;;
    esac
}
main

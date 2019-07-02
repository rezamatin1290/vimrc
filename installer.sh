#!/usr/bin/env bash 

USER_NAME=$(who am i | awk {'print $1'})
START_PWD=$PWD
if [ "$1" != "help" ];then
    if [ ! -d /home/$USER_NAME/.vim ];then
        mkdir /home/$USER_NAME/.vim 
    fi
fi

function vimrc_installer(){
    echo "$(tput setaf 2)[+] Installing 'vim-plug' ..."
    sleep 1
    curl -fLo /home/$USER_NAME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mv vimrc_file /home/$USER_NAME/.vimrc
    sed -i 's/iman/'"$USER_NAME"'/g' vimrc_file
    echo "$(tput setaf 2)[+] Opening tmp.file for Plugin Installer ..."
    sleep 1.5
    vim +'PlugInstall' tmp.file
    
    echo "$(tput setaf 2)[✔] Vimrc installed successfully!"
}
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
function fix_cvim(){
    unzip $START_PWD/cvim.zip
        if [ "$?" = 0 ];then 
            echo "$(tput setaf 2)[✔] C-support installation done !"
        else 
            echo -e "$(tput setaf 1)[✗] Unzip package not found ...\nInstall unzip from your repo and try 'fix_cvim' Option." 
        fi
}
function help(){
    echo "Usage: ./installer [OPTION]

      all         Install vimrc plugins and setup configurations,add c-support plugin too
      only-vim    Install vimrc plugins and setup configurations only
      only-cvim   Install c-support file and add plugin only
      help        display this help and exit"
}


 case "$1" in 
     only-vimrc)
          vimrc_installer
          ;;
     only-cvim)
          cvim_installer
          sed "s/:filetype plugin on//g" /home/$USER_NAME/.vimrc
          echo ":filetype plugin on" >>  /home/$USER_NAME/.vimrc
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
 

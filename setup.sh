#!/bin/bash

# All-in-one bash script to perform various setup activities

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
UNSET="\e[0m"

function showHelp() {
    echo
    echo "Usage:"
    echo "   $0 [OPTION]"
    echo
    echo "Options are intended to be run one-at-a-time; they are listed here in "
    echo "recommended order."
    echo
    echo "  --apt-get-installs    (installs a bunch of useful Ubuntu packages)"
    echo "  --docker              (installs docker and adds current user to new docker group)"
    echo "  --download-miniconda  (downloads latest Miniconda to current directory)"
    echo "  --install-miniconda   (install downloaded Miniconda to ~/miniconda3)"
    echo "  --set-up-bioconda     (add channels for bioconda in proper order and make recommended speed-ups)"
    echo "  --conda-env           (install requirements.txt into root conda env)"
    echo "  --download-neovim-appimage (download appimage instead of compiling)"
    echo "  --download-macos-nvim (download binary nvim for MacOS)"
    echo "  --powerline           (installs powerline fonts)"
    echo "  --set-up-nvim-plugins (manually add vim-plug)"
    echo "  --nih-lablinux        (install repo for LabLinux and LabLinux itself)"
    echo "  --set-up-lablinux     (print out recommended scripts to run from LabLinux)"
    echo "  --centos7-installs    (compilers; recent tmux)"
    echo "  --install-fzf         (installs fzf)"
    echo "  --install-ag          (installs ag)"
    echo "  --install-autojump    (installs autojump)"
    echo "  --install-hub         (installs hub and sets alias)"
    echo "  --install-fd          (installs fd and sets alias)"
    echo "  --install-vd          (installs visidata and sets alias)"
    echo "  --install-black       (installs black and sets alias)"
    echo "  --install-tabview     (installs tabview and sets alias)"
    echo "  --install-radian      (installs radian and sets alias)"
    echo "  --alacritty           (installs alacritty, a GPU-accelerated terminal emulator)"
    echo "  --diffs               (inspect differences between repo and home)"
    echo "  --dotfiles            (update dotfiles)"
    echo
    echo "paths to miniconda and neovim will be prepended to PATH in the"
    echo "~/.path file; that file will then be sourced"
    echo
    exit 0
}

if [ -z $1 ]; then
    showHelp
fi

set -eou pipefail
task=$1


# Depending on the system, we may have curl or wget but not both -- so try to
# figure it out.

try_curl() {
    url=$1
    dest=$2
    command -v curl > /dev/null && curl -fL $url > $dest
}


try_wget() {
    url=$1
    dest=$2
    command -v wget > /dev/null && wget -O- $url > $dest
}


download() {
    echo "Downloading $1 to $2"
    if ! (try_curl $1 $2 || try_wget $1 $2); then
        echo "Could not download $1"
    fi
}


# Append a line to the end of a file, but only if the line isn't already there
add_line_to_file () {
    line=$1
    file=$2
    if grep -vq "$line" $file; then
        echo "$line" >> $file
    fi
}


# Only exits cleanly if the named conda env does not already exist
can_make_conda_env () {
    check_for_conda
    if conda env list | grep -q "/$1\$"; then
        echo -e "${RED}conda env $1 already exists! Exiting.${UNSET}"
        return 1
    fi
}


ok () {
    echo -e ${GREEN}$1${UNSET}
    read -p "Continue? (y/[n]) " -n 1 REPLY;
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    echo -e ${RED}exiting${UNSET}
    return 1
}



if [ $task == "--apt-get-installs" ]; then
    ok "Installs packages from the file apt-installs.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs.txt | grep -v "^#")

elif [ $task == "--docker" ]; then
    ok "Adds the docker repo, installs docker-ce, adds user to the docker group"
    sudo apt-get update
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    echo "OK!"
    sudo apt-key fingerprint 0EBFCD88
    echo
    echo "should say:"
    echo
    echo "pub   4096R/0EBFCD88 2017-02-22"
    echo "      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"
    echo "uid                  Docker Release (CE deb) <docker@docker.com>"
    echo "sub   4096R/F273FCD8 2017-02-22"

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo
    echo
    echo "Please log out and then log back in again to be able to use docker as $USER instead of root"

elif [ $task == "--download-miniconda" ]; then
    ok "Downloads (but does not install) the latest Miniconda"
    download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh

elif [ $task == "--install-miniconda" ]; then
    ok "Install Miniconda to $HOME/miniconda3/bin and then add $HOME/miniconda3/bin to the \$PATH by adding it to the end of ~/.path"
    bash miniconda.sh -b
    echo "# Added `date`:"
    echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-bioconda" ]; then
    ok "Set up Bioconda by adding the dependent channels in the correct order"
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

elif [ $task == "--conda-env" ]; then
    ok "Install dependencies in 'requirements.txt' into the base conda environment"
    conda install --file requirements.txt


elif [ $task == "--powerline" ]; then
    ok "Install patched powerline fonts from https://github.com/powerline/fonts"
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    echo "Change your terminal's config to use the new powerline patched fonts"
    echo

elif [ $task == "--download-neovim-appimage" ]; then
    ok "Download AppImage for neovim, install into $HOME/opt/neovim/bin/nvim, and add that to the \$PATH via the ~/.path file"
    dest="$HOME/opt/neovim/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage $dest
    chmod u+x $dest
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-macos-nvim" ]; then
    ok "Download neovim tarball from https://github.com/neovim/neovim, install
    into $HOME/opt/neovim, and add that to the \$PATH via the ~/.path file"
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt"
    mv nvim-osx64 "$HOME/opt/neovim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-nvim-plugins" ]; then
    ok "Download plug.vim into ~/.local/share/nvim/site/autoload/plug.vim"
    dest=~/.local/share/nvim/site/autoload/plug.vim
    mkdir -p $(dirname $dest)
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $dest
    echo
    echo "Open nvim and run :PlugInstall"
    echo

elif [ $task == "--diffs" ]; then
    ok "Show the diffs between this repo and what's in your home directory"
    cmd="diff --recursive --exclude .git --exclude setup.sh --exclude README.md --exclude Miniconda3-latest-Linux-x86_64.sh --exclude LICENSE-MIT.txt"
    $cmd ~ . | grep -v "Only in $HOME" | sed "s|$cmd||g"


elif [ $task == "--nih-lablinux" ]; then
    ok "Assumes CentOS 7. Install lablinux repo, but don't run any commands"
    set -ex
    sudo yum install redhat-lsb-core
    sudo yum  install \
        http://mirror.nih.gov/nih/extras/$(lsb_release -is)/$(lsb_release -rs|sed -e 's/\..*//')/$(uname -m)/nih-extras-release.rpm
    sudo yum install nih-lablinux
    set +ex

elif [ $task == "--set-up-lablinux" ]; then
    ok "Just print the commands to run manually after installing lablinux"
    echo
    echo "Run the following commands:"
    echo "---------------------------"
    echo
    echo "sudo lablinux install-packages"
    echo "sudo lablinux configure-piv"
    echo "sudo lablinux configure-piv-login"
    echo "sudo lablinux configure-piv-gdm"
    echo "sudo lablinux configure-sshd"
    echo

elif [ $task == "--centos7-installs" ]; then
    ok "Install packages on CentOS 7 (includes compiling a recent-ish tmux)"
    set -ex
    sudo yum install epel-release
    sudo yum groupinstall "GNOME Desktop"
    sudo yum groupinstall 'Development Tools'
    sudo yum install \
        git \
        libevent \
        libevent-devel \
        ncurses-devel \
        glibc-static \
        xclip \
        htop

    TMUX_VERSION=2.7

    (

        cd /tmp
        download https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz tmux-${TMUX_VERSION}.tar.gz
        tar xzf tmux-${TMUX_VERSION}.tar.gz
        cd tmux-${TMUX_VERSION}
        ./configure && make -j8
        sudo make install
    )
    set +ex

elif [ $task == "--install-fzf" ]; then
    ok "Install fzf (https://github.com/junegunn/fzf)"
    (
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --no-update-rc --completion --key-bindings
      )

elif [ $task == "--install-ag" ]; then
    ok "Install ag into $HOME/opt (https://github.com/ggreer/the_silver_searcher)"
    (
        agdir=$HOME/tmp/ag
        rm -rf $agdir
        git clone https://github.com/ggreer/the_silver_searcher.git $agdir
        cd $agdir
        sh ./autogen.sh
        sh ./configure --prefix=$HOME/opt/
        make
        make install
        rm -rf $agdir
    )

elif [ $task == "--install-autojump" ]; then
    ok "Install autojump (https://github.com/wting/autojump)"
    (
        git clone https://github.com/wting/autojump.git
        cd autojump
        python install.py
    )
    rm -rf autojump

elif [ $task == "--install-hub" ]; then
    ok "Install hub to $HOME/opt (https://github.com/github/hub)"
    HUB_VERSION=2.11.2
    (
        download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
        cd /tmp
        tar -xf hub.tar.gz
        cd hub-linux-amd64-${HUB_VERSION}
        prefix=$HOME/opt ./install
    )
    add_line_to_file "export PATH=\"$HOME/opt/bin:\$PATH\"" ~/.path
    source ~/.path

elif [ $task == "--install-fd" ]; then
    ok "Install fd (https://github.com/sharkdp/fd) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "fd" \
        && conda create -n fd fd-find \
        && add_line_to_file 'alias fd=$HOME/miniconda3/envs/fd/bin/fd' ~/.aliases \
        && source ~/.aliases

elif [ $task == "--install-vd" ]; then
    ok "Install visidata (https://visidata.org/) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "vd" \
        && conda create -n vd visidata \
        && add_line_to_file 'alias vd=$HOME/miniconda3/envs/vd/bin/vd' ~/.aliases \
        && source ~/.aliases

elif [ $task == "--install-tabview" ]; then
    ok "Install tabview (https://github.com/TabViewer/tabview) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "tabview" \
        && conda create -n tabview tabview \
        && add_line_to_file 'alias tabview=$HOME/miniconda3/envs/tabview/bin/tabview' ~/.aliases \
        && source ~/.aliases

elif [ $task == "--install-black" ]; then
    ok "Install black (https://black.readthedocs.io) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "black" \
        && conda create -n black black \
        && add_line_to_file 'alias black=$HOME/miniconda3/envs/black/bin/black' ~/.aliases \
        && source ~/.aliases

elif [ $task == "--install-radian" ]; then
    ok "Install radian (https://github.com/randy3k/radian) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "radian" \
        && conda create -n radian python=3 \
        && source activate radian \
        && pip install radian \
        && add_line_to_file 'alias radian=$HOME/miniconda3/envs/radian/bin/radian' ~/.aliases \
        && source ~/.aliases

elif [ $task == "--dotfiles" ]; then
    ok "Copies over all the dotfiles here to your home directory. Prompts again before actually running to make sure!"
    cd "$(dirname "${BASH_SOURCE}")";


    function doIt() {
        rsync --exclude ".git/" \
            --exclude "setup.sh" \
            --exclude "README.md" \
            --exclude "Miniconda3-latest-Linux-x86_64.sh" \
            --exclude "LICENSE-MIT.txt" \
            -avh --no-perms . ~
        source ~/.bash_profile
    }

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        doIt
    else
        read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            doIt
        fi
    fi
    unset doIt

elif [ $task == "--alacritty" ]; then
    ok "Install alacritty terminal. Also needs to install rust"
    (
        set -eoux
        SRC=/tmp/alacritty
        rm -rf $SRC
        git clone https://github.com/jwilm/alacritty.git $SRC

        if [ ! `test "cargo"` ]; then
            curl https://sh.rustup.rs -sSf | sh
            source ~/.cargo/env
        fi
        rustup override set stable
        rustup update stable
        (
            cd $SRC;
            cargo install cargo-deb --force
            cargo deb --install
        )
    )

else
    showHelp

fi

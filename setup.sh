#!/bin/bash

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
    echo "  --install-tabview     (installs tabview and sets alias)"
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

if [ $task == "--apt-get-installs" ]; then
    sudo apt-get update && \
    sudo apt-get install \
        apt-transport-https \
        automake \
        build-essential \
        ca-certificates \
        cifs-utils \
        cmake \
        curl \
        default-jdk \
        gimp \
        git-cola \
        gnome-tweak-tool \
        gnupg2 \
        gnupg-agent \
        gparted \
        htop \
        icedtea-netx \
        indicator-multiload \
        inkscape \
        iotop \
        libfontconfig1-dev \
        libfreetype6-dev \
        liblzma-dev \
        libpcre3-dev \
        meld \
        nfs-common \
        openssh-server \
        pinentry-qt \
        pkg-config \
        pkg-config \
        shutter \
        software-properties-common \
        tcllib \
        texlive \
        tmux \
        uuid \
        xclip \
        zlib1g-dev

elif [ $task == "--docker" ]; then
    sudo apt-get update
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
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
    download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh

elif [ $task == "--install-miniconda" ]; then
    bash miniconda.sh -b
    echo "# Added `date`:"
    echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-bioconda" ]; then
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    conda config --set channel_priority strict


elif [ $task == "--conda-env" ]; then
    conda install --file requirements.txt


elif [ $task == "--powerline" ]; then
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    echo "Change your terminal's config to use the new powerline patched fonts"
    echo

elif [ $task == "--download-neovim-appimage" ]; then
    dest="$HOME/opt/neovim/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage $dest
    chmod u+x $dest
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-macos-nvim" ]; then
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt"
    mv nvim-osx64 "$HOME/opt/neovim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-nvim-plugins" ]; then
    dest=~/.local/share/nvim/site/autoload/plug.vim
    mkdir -p $(dirname $dest)
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $dest
    echo
    echo "Open nvim and run :PlugInstall"
    echo

elif [ $task == "--diffs" ]; then

    cmd="diff --recursive --exclude .git --exclude setup.sh --exclude README.md --exclude Miniconda3-latest-Linux-x86_64.sh --exclude LICENSE-MIT.txt"
    $cmd ~ . | grep -v "Only in $HOME" | sed "s|$cmd||g"


elif [ $task == "--nih-lablinux" ]; then
    set -ex
    sudo yum install redhat-lsb-core
    sudo yum  install \
        http://mirror.nih.gov/nih/extras/$(lsb_release -is)/$(lsb_release -rs|sed -e 's/\..*//')/$(uname -m)/nih-extras-release.rpm
    sudo yum install nih-lablinux
    set +ex

elif [ $task == "--set-up-lablinux" ]; then
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
    (
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --no-update-rc --completion --key-bindings
      )

elif [ $task == "--install-ag" ]; then
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
    (
        git clone git://github.com/wting/autojump.git
        cd autojump
        python install.py
    )
    rm -rf autojump

elif [ $task == "--install-hub" ]; then

    HUB_VERSION=2.11.2
    (
        download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
        cd /tmp
        tar -xf hub.tar.gz
        cd hub-linux-amd64-${HUB_VERSION}
        prefix=$HOME/opt ./install
    )
    echo "export PATH=\"$HOME/opt/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--install-fd" ]; then
    if conda env list | grep -q "fd"; then
        echo "Conda env 'fd' already exists, skipping!"
    else
        conda create -n fd fd-find
        echo 'alias fd=$HOME/miniconda3/envs/fd/bin/fd' >> ~/.aliases
    fi

elif [ $task == "--install-vd" ]; then
    if conda env list | grep -q "vd"; then
        echo "Conda env 'vd' already exists, skipping!"
    else
        conda create -n vd visidata
        echo 'alias vd=$HOME/miniconda3/envs/vd/bin/vd' >> ~/.aliases
    fi

elif [ $task == "--install-tabview" ]; then
    if conda env list | grep -q "tabview"; then
        echo "Conda env 'tabview' already exists, skipping!"
    else
        conda create -n tabview tabview
        echo 'alias tabview=$HOME/miniconda3/envs/tabview/bin/tabview' >> ~/.aliases
    fi

elif [ $task == "--dotfiles" ]; then
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

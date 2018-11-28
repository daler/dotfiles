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
    echo "  --set-up-bioconda     (add channels for bioconda in proper order)"
    echo "  --conda-env           (install requirements.txt into root conda env)"
    echo "  --download-neovim-appimage (download appimage instead of compiling)"
    echo "  --download-macos-nvim (download binary nvim for MacOS)"
    echo "  --neovim-prereqs      (apt-get install prereqs to compile neovim)"
    echo "  --powerline           (installs powerline fonts)"
    echo "  --compile-neovim      (compile and install neovim to ~/opt/neovim)"
    echo "  --set-up-nvim-plugins (manually add vim-plug)"
    echo "  --nih-lablinux        (install repo for LabLinux and LabLinux itself)"
    echo "  --set-up-lablinux     (print out recommended scripts to run from LabLinux)"
    echo "  --centos7-installs    (compilers; recent tmux)"
    echo "  --install-fzf         (installs fzf)"
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
        build-essential \
        htop \
        tmux \
        iotop \
        shutter \
        inkscape \
        gimp \
        cifs-utils \
        nfs-common \
        tcllib \
        gnome-tweak-tool \
        indicator-multiload \
        curl \
        openssh-server \
        zlib1g-dev \
        default-jdk \
        icedtea-netx \
        git-cola \
        texlive \
        meld \
        uuid \
        gparted \
        gnupg2 \
        gnupg-agent \
        pinentry-qt \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        automake \
        pkg-config \
        libpcre3-dev \
        liblzma-dev

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
    download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

elif [ $task == "--install-miniconda" ]; then
    bash Miniconda3-latest-Linux-x86_64.sh -b
    echo "# Added `date`:"
    echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-bioconda" ]; then
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

elif [ $task == "--conda-env" ]; then
    conda install --file requirements.txt

elif [ $task == "--neovim-prereqs" ]; then
    sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

elif [ $task == "--powerline" ]; then
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts

elif [ $task == "--compile-neovim" ]; then
    cd /tmp
    if [ ! -e neovim ]; then
        git clone https://github.com/neovim/neovim.git
    fi
    cd neovim
    git checkout master
    git pull
    git checkout master
    rm -rf build
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/opt/neovim"
    make install
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-neovim-appimage" ]; then
    dest="$HOME/opt/neovim/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.2.2/nvim.appimage $dest
    chmod u+x $dest
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-macos-nvim" ]; then
    download https://github.com/neovim/neovim/releases/download/v0.3.0/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt"
    mv nvim-osx64 "$HOME/opt/neovim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-nvim-plugins" ]; then
    dest=~/.local/share/nvim/site/autoload/plug.vim 
    mkdir -p $(dirname $dest)
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $dest

    #curl -fLo /tmp/nvim-r.zip \
    #    https://github.com/jalvesaq/Nvim-R/releases/download/v0.9.8/Nvim-R_0.9.8.zip
    #
    #mkdir -p ~/.local/share/nvim/site/pack/R
    #(cd ~/.local/share/nvim/site/pack/R && unzip /tmp/nvim-r.zip)


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

elif [ $task == "--install-fasd" ]; then
    mkdir -p ~/opt
    (
        download https://raw.githubusercontent.com/clvv/fasd/master/fasd ~/opt/fasd
        chmod +x ~/opt/fasd
    )

elif [ $task == "--install-ag" ]; then
    (
        rm -rf /tmp/ag
        git clone https://github.com/ggreer/the_silver_searcher.git /tmp/ag
        cd /tmp/ag
        ./build.sh
        sudo make install
    )

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
else
    showHelp
fi

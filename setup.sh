#!/bin/bash

function showHelp() {
    echo
    echo "Usage:"
    echo "   $0 [OPTION]"
    echo
    echo "Options are intended to be run one-at-a-time; they are listed here in "
    echo "recommended order."
    echo
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

if [ $task == "--download-miniconda" ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

elif [ $task == "--install-miniconda" ]; then
    bash Miniconda3-latest-Linux-x86_64.sh -b
    echo "# Added `date`:"
    echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-bioconda" ]; then
    conda config --add channels conda-forge
    conda config --add channels defaults
    conda config --add channels r
    conda config --add channels bioconda

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
    curl -LO https://github.com/neovim/neovim/releases/download/v0.2.2/nvim.appimage
    mkdir -p "$HOME/opt/neovim/bin"
    chmod u+x nvim.appimage
    mv nvim.appimage "$HOME/opt/neovim/bin/nvim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-macos-nvim" ]; then
    curl -LO https://github.com/neovim/neovim/releases/download/v0.3.0/nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt"
    mv nvim-osx64 "$HOME/opt/neovim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-nvim-plugins" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    curl -fLo /tmp/nvim-r.zip \
        https://github.com/jalvesaq/Nvim-R/releases/download/v0.9.8/Nvim-R_0.9.8.zip

    mkdir -p ~/.local/share/nvim/site/pack/R
    (cd ~/.local/share/nvim/site/pack/R && unzip /tmp/nvim-r.zip)

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
    sudo yum gropus install "GNOME Desktop"
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
        wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
        tar xzf tmux-${TMUX_VERSION}.tar.gz
        cd tmux-${TMUX_VERSION}
        ./configure && make -j8
        sudo make install
    )
    set +ex

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

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
    echo "  --neovim-prereqs      (apt-get install prereqs to compile neovim)"
    echo "  --compile-neovim      (compile and install neovim to ~/opt/neovim)"
    echo "  --set-up-vim-plug     (manually add vim-plug)"
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


elif [ $task == "--neovim-prereqs" ]; then
    sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

elif [ $task == "--compile-neovim" ]; then
    cd /tmp
    if [ ! -e neovim ]; then
        git clone https://github.com/neovim/neovim.git
    fi
    cd neovim
    git checkout master
    git pull
    git checkout v0.1.7
    rm -rf build
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/opt/neovim"
    make install
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-vim-plug" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

elif [ $task == "--dotfiles" ]; then
    cd "$(dirname "${BASH_SOURCE}")";


    function doIt() {
        rsync --exclude ".git/" \
            --exclude "setup.sh" \
            --exclude "README.md" \
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

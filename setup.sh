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
    echo "Initial setup:"
    echo -e "  ${GREEN} --apt-get-installs        [local only]  ${UNSET}(installs a bunch of useful Ubuntu packages)"
    echo -e "  ${GREEN} --download-nvim-appimage  [local only]  ${UNSET}(download nvim AppImage)"
    echo -e "  ${GREEN} --download-macos-nvim     [local only]  ${UNSET}(download binary nvim for MacOS)"
    echo -e "  ${GREEN} --powerline               [local only]  ${UNSET}(installs powerline fonts)"
    echo -e "  ${GREEN} --set-up-nvim-plugins                   ${UNSET}(manually add vim-plug)"
    echo
    echo "conda:"
    echo -e "  ${GREEN} --download-miniconda                    ${UNSET}(downloads latest Miniconda to current directory)"
    echo -e "  ${GREEN} --install-miniconda                     ${UNSET}(install downloaded Miniconda to ~/miniconda3)"
    echo -e "  ${GREEN} --set-up-bioconda                       ${UNSET}(add channels for bioconda in proper order and make recommended speed-ups)"
    echo -e "  ${GREEN} --conda-env                             ${UNSET}(install requirements.txt into root conda env)"
    echo
    echo "CentOS 7:"
    echo -e "  ${GREEN} --nih-lablinux            [local only]  ${UNSET}(install repo for LabLinux and LabLinux itself)"
    echo -e "  ${GREEN} --set-up-lablinux         [local only]  ${UNSET}(print out recommended scripts to run from LabLinux)"
    echo -e "  ${GREEN} --centos7-installs        [local only]  ${UNSET}(compilers; recent tmux)"
    echo
    echo "Installations:"
    echo -e "  ${GREEN} --install-fzf                           ${UNSET}(installs fzf)"
    echo -e "  ${GREEN} --install-ag                            ${UNSET}(installs ag)"
    echo -e "  ${GREEN} --install-autojump                      ${UNSET}(installs autojump)"
    echo -e "  ${GREEN} --install-hub                           ${UNSET}(installs hub and sets alias)"
    echo -e "  ${GREEN} --install-fd                            ${UNSET}(installs fd and sets alias)"
    echo -e "  ${GREEN} --install-vd                            ${UNSET}(installs visidata and sets alias)"
    echo -e "  ${GREEN} --install-black                         ${UNSET}(installs black and sets alias)"
    echo -e "  ${GREEN} --install-tabview                       ${UNSET}(installs tabview and sets alias)"
    echo -e "  ${GREEN} --install-radian                        ${UNSET}(installs radian and sets alias)"
    echo -e "  ${GREEN} --install-git-cola                      ${UNSET}(installs git-cola and sets alias)"
    echo -e "  ${GREEN} --install-docker          [local only]  ${UNSET}(installs docker and adds current user to new docker group)"
    echo -e "  ${GREEN} --install-alacritty       [local only]  ${UNSET}(installs alacritty, a GPU-accelerated terminal emulator)"
    echo
    echo "Dotfiles:"
    echo -e "  ${GREEN} --diffs                                   ${UNSET}(inspect differences between repo and home)"
    echo -e "  ${GREEN} --dotfiles                                ${UNSET}(update dotfiles)"
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


# Find the conda installation location
CONDA_LOCATION=
check_for_conda () {
    if [ $(which conda) ]; then
        CONDA_LOCATION=$(dirname $(dirname $(which conda)))
    else
        echo -e ${RED}cannot find conda${UNSET}
        exit 1
    fi
}

# Prompt user for info ($1 is text to provide)
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

# Reminder to source the ~/.aliases file.
remind_alias () {
    echo -e ${YELLOW}Please run${UNSET} source ~/.aliases ${YELLOW}to make the new alias available${UNSET}
}


if [ $task == "--apt-get-installs" ]; then
    ok "Installs packages from the file apt-installs.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs.txt | grep -v "^#")

elif [ $task == "--install-docker" ]; then
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
    ok "Installs Miniconda to $HOME/miniconda3/bin and then add $HOME/miniconda3/bin to the \$PATH by adding it to the end of ~/.path"
    bash miniconda.sh -b
    echo "# Added `date`:"
    echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-bioconda" ]; then
    ok "Sets up Bioconda by adding the dependent channels in the correct order"
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

elif [ $task == "--conda-env" ]; then
    ok "Installs dependencies in 'requirements.txt' into the base conda environment"
    conda install --file requirements.txt


elif [ $task == "--powerline" ]; then
    ok "Installs patched powerline fonts from https://github.com/powerline/fonts"
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    echo "Change your terminal's config to use the new powerline patched fonts"
    echo

elif [ $task == "--download-nvim-appimage" ]; then
    ok "Downloads AppImage for neovim, install into $HOME/opt/neovim/bin/nvim, and add that to the \$PATH via the ~/.path file"
    dest="$HOME/opt/neovim/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage $dest
    chmod u+x $dest
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--download-macos-nvim" ]; then
    ok "Downloads neovim tarball from https://github.com/neovim/neovim, install
    into $HOME/opt/neovim, and add that to the \$PATH via the ~/.path file"
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt"
    mv nvim-osx64 "$HOME/opt/neovim"
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path

elif [ $task == "--set-up-nvim-plugins" ]; then
    ok "Downloads plug.vim into ~/.local/share/nvim/site/autoload/plug.vim"
    dest=~/.local/share/nvim/site/autoload/plug.vim
    mkdir -p $(dirname $dest)
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $dest
    echo
    echo "Open nvim and run :PlugInstall"
    echo

elif [ $task == "--diffs" ]; then
    ok "Shows the diffs between this repo and what's in your home directory"
    cmd="diff --recursive --exclude .git --exclude setup.sh --exclude README.md --exclude Miniconda3-latest-Linux-x86_64.sh --exclude LICENSE-MIT.txt"
    $cmd ~ . | grep -v "Only in $HOME" | sed "s|$cmd||g"


elif [ $task == "--nih-lablinux" ]; then
    ok "Assumes CentOS 7. Installs lablinux repo, but don't run any commands"
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
    ok "Installs packages on CentOS 7 (includes compiling a recent-ish tmux)"
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
    ok "Installs fzf (https://github.com/junegunn/fzf)"
    (
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --no-update-rc --completion --key-bindings
      )

elif [ $task == "--install-ag" ]; then
    ok "Installs ag into $HOME/opt (https://github.com/ggreer/the_silver_searcher)"
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
    ok "Installs autojump (https://github.com/wting/autojump)"
    (
        git clone https://github.com/wting/autojump.git
        cd autojump
        python install.py
    )
    rm -rf autojump

elif [ $task == "--install-hub" ]; then
    ok "Installs hub to $HOME/opt (https://github.com/github/hub)"
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
    ok "Installs fd (https://github.com/sharkdp/fd) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "fd"
    conda create -n fd fd-find
    add_line_to_file "alias fd=$CONDA_LOCATION/envs/fd/bin/fd" ~/.aliases
    remind_alias

elif [ $task == "--install-vd" ]; then
    ok "Installs visidata (https://visidata.org/) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "vd"
    conda create -n vd visidata
    add_line_to_file "alias vd=$CONDA_LOCATION/envs/vd/bin/vd" ~/.aliases
    remind_alias

elif [ $task == "--install-tabview" ]; then
    ok "Installs tabview (https://github.com/TabViewer/tabview) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "tabview"
    conda create -n tabview tabview
    add_line_to_file "alias tabview=$CONDA_LOCATION/envs/tabview/bin/tabview" ~/.aliases
    remind_alias

elif [ $task == "--install-black" ]; then
    ok "Installs black (https://black.readthedocs.io) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "black"
    conda create -n black black
    add_line_to_file "alias black=$CONDA_LOCATION/envs/black/bin/black" ~/.aliases
    remind_alias

elif [ $task == "--install-radian" ]; then
    ok "Installs radian (https://github.com/randy3k/radian) into a new conda env, and set the resulting binary as an alias"
    can_make_conda_env "radian"
    conda create -n radian python=3
    source activate radian
    pip install radian
    add_line_to_file "alias radian=$CONDA_LOCATION/envs/radian/bin/radian" ~/.aliases
    source deactivate
    remind_alias

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

elif [ $task == "--install-alacritty" ]; then
    ok "Installs alacritty terminal. Also needs to install rust"
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

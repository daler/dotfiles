#!/bin/bash

# All-in-one bash script to perform various setup activities

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
UNSET="\e[0m"

export PS1=

function showHelp() {
    echo
    echo "Usage:"
    echo "   $0 [OPTION]"
    echo
    echo "Options are intended to be run one-at-a-time; they are listed here in "
    echo "recommended order."
    echo
    echo "Initial setup:"
    printf "  ${GREEN} --apt-get-installs         [local only]  ${UNSET}(installs a bunch of useful Ubuntu packages)\n"
    printf "  ${GREEN} --apt-get-installs-minimal [local only]  ${UNSET}(installs a bunch of useful Ubuntu packages)\n"
    printf "  ${GREEN} --download-nvim-appimage   [local only]  ${UNSET}(download nvim AppImage)\n"
    printf "  ${GREEN} --download-macos-nvim      [local only]  ${UNSET}(download binary nvim for MacOS)\n"
    printf "  ${GREEN} --powerline                [local only]  ${UNSET}(installs powerline fonts)\n"
    printf "  ${GREEN} --set-up-nvim-plugins                    ${UNSET}(manually add vim-plug)\n"
    echo
    echo "conda:"
    printf "  ${GREEN} --download-miniconda                     ${UNSET}(downloads latest Miniconda (autodetect Mac/Linux) to current directory)\n"
    printf "  ${GREEN} --install-miniconda                      ${UNSET}(install downloaded Miniconda to ~/miniconda3)\n"
    printf "  ${GREEN} --set-up-bioconda                        ${UNSET}(add channels for bioconda in proper order and make recommended speed-ups)\n"
    printf "  ${GREEN} --conda-env                              ${UNSET}(install requirements.txt into root conda env)\n"
    printf "  ${GREEN} --conda-env-mac                          ${UNSET}(install requirements-mac.txt into root conda env)\n"
    echo
    echo "CentOS 7:"
    printf "  ${GREEN} --nih-lablinux             [local only]  ${UNSET}(install repo for LabLinux and LabLinux itself)\n"
    printf "  ${GREEN} --set-up-lablinux          [local only]  ${UNSET}(print out recommended scripts to run from LabLinux)\n"
    printf "  ${GREEN} --centos7-installs         [local only]  ${UNSET}(compilers; recent tmux)\n"
    echo
    echo "Installations:"
    printf "  ${GREEN} --install-fzf                            ${UNSET}(installs fzf)\n"
    printf "  ${GREEN} --install-ag                             ${UNSET}(installs ag)\n"
    printf "  ${GREEN} --install-ripgrep                        ${UNSET}(installs ripgrep)\n"
    printf "  ${GREEN} --install-autojump                       ${UNSET}(installs autojump)\n"
    printf "  ${GREEN} --install-hub                            ${UNSET}(installs hub and makes symlink)\n"
    printf "  ${GREEN} --install-fd                             ${UNSET}(installs fd and makes symlink)\n"
    printf "  ${GREEN} --install-vd                             ${UNSET}(installs visidata and makes symlink)\n"
    printf "  ${GREEN} --install-black                          ${UNSET}(installs black and makes symlink)\n"
    printf "  ${GREEN} --install-tabview                        ${UNSET}(installs tabview and makes symlink)\n"
    printf "  ${GREEN} --install-radian                         ${UNSET}(installs radian and makes symlink)\n"
    printf "  ${GREEN} --install-git-cola                       ${UNSET}(installs git-cola and makes symlink)\n"
    printf "  ${GREEN} --install-bat                            ${UNSET}(installs bat and makes symlink)\n"
    printf "  ${GREEN} --install-jq                             ${UNSET}(installs jq, 'like sed for JSON')\n"
    printf "  ${GREEN} --install-docker           [local only]  ${UNSET}(installs docker and adds current user to new docker group)\n"
    printf "  ${GREEN} --install-alacritty        [local only]  ${UNSET}(installs alacritty, a GPU-accelerated terminal emulator)\n"
    echo
    echo "Dotfiles:"
    printf "  ${GREEN} --diffs                                  ${UNSET}(inspect diffs between repo and home)\n"
    printf "  ${GREEN} --vim-diffs                              ${UNSET}(inspect diffs between repo and home, using vim -d)\n"
    printf "  ${GREEN} --graphical-diffs                        ${UNSET}(inspect diffs between repo and home, using meld)\n"
    printf "  ${GREEN} --dotfiles                               ${UNSET}(update dotfiles)\n"
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
        printf "${RED}conda env $1 already exists! Exiting.${UNSET}\n"
        return 1
    fi
}


# Find the conda installation location
CONDA_LOCATION=
check_for_conda () {
    if [ $(which conda) ]; then
        CONDA_LOCATION=$(dirname $(dirname $(which conda)))
    else
        printf "${RED}cannot find conda${UNSET}\n"
        exit 1
    fi
}

# Prompt user for info ($1 is text to provide)
ok () {
    printf "${GREEN}$1${UNSET}\n"
    read -p "Continue? (y/[n]) " -n 1 REPLY;
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    printf "${RED}exiting${UNSET}\n"
    return 1
}

# Reminder to source the ~/.aliases file.
remind_alias () {
    printf "${YELLOW}Please run${UNSET} source ~/.aliases ${YELLOW}to make the new alias available${UNSET}\n"
}

check_opt_bin_in_path () {
    if ! echo $PATH | grep -q "$HOME/opt/bin"; then
        printf "${YELLOW}Please add${UNSET} $HOME/opt/bin ${YELLOW} to your \$PATH${UNSET}\n"
    fi
}

# For simple cases where you just want to have a separate conda env and symlink
# the binary over, use this function.
install_env_and_symlink () {
    ENVNAME=$1
    CONDAPKG=$2
    EXECUTABLE=$3

    can_make_conda_env $ENVNAME
    conda create -n $ENVNAME $CONDAPKG
    mkdir -p ~/opt/bin
    ln -sf "$CONDA_LOCATION/envs/$ENVNAME/bin/$EXECUTABLE" $HOME/opt/bin/$EXECUTABLE
    printf "${YELLOW}Installed $HOME/opt/bin/$EXECUTABLE${UNSET}\n"
    check_opt_bin_in_path
}



if [ $task == "--apt-get-installs" ]; then
    ok "Installs packages from the file apt-installs.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs.txt | grep -v "^#")

if [ $task == "--apt-get-installs-minimal" ]; then
    ok "Installs packages from the file apt-installs-minimal.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs-minimal.txt | grep -v "^#")

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

    if [[ $OSTYPE == darwin* ]]; then
        download https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh miniconda.sh
    else
        download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh
    fi

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

elif [ $task == "--conda-env-mac" ]; then
    ok "Installs dependencies in 'requirements-mac.txt' into the base conda environment"
    conda install --file requirements-mac.txt


elif [ $task == "--powerline" ]; then
    ok "Installs patched powerline fonts from https://github.com/powerline/fonts"
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    printf "${YELLOW}Change your terminal's config to use the new powerline patched fonts${UNSET}\n"
    echo

elif [ $task == "--download-nvim-appimage" ]; then
    ok "Downloads AppImage for neovim, install into $HOME/opt/neovim/bin/nvim, and add that to the \$PATH via the ~/.path file"
    dest="$HOME/opt/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage $dest
    chmod u+x $dest
    echo "export PATH=\"$HOME/opt/neovim/bin:\$PATH\"" >> ~/.path
    source ~/.path
    printf "${YELLOW}Installed neovim to $HOME/opt/neovim/bin and symlinked to $HOME/opt/bin${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--download-macos-nvim" ]; then
    ok "Downloads neovim tarball from https://github.com/neovim/neovim, install
    into $HOME/opt/neovim, and add that to the \$PATH via the ~/.path file"
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt/bin"
    mv nvim-osx64 "$HOME/opt/"
    ln -s ~/opt/nvim-osx64/bin/nvim ~/opt/bin/nvim

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
    printf "${YELLOW}Installed to $HOME/opt/bin/hub${UNSET}\n"

elif [ $task == "--install-fd" ]; then
    ok "Installs fd (https://github.com/sharkdp/fd) into a new conda env, and symlink to ~/opt/bin/fd"
    install_env_and_symlink fd fd-find fd

elif [ $task == "--install-vd" ]; then
    ok "Installs visidata (https://visidata.org/) into a new conda env, and symlink to ~/opt/bin/vd"
    install_env_and_symlink visidata visidata vd

elif [ $task == "--install-tabview" ]; then
    ok "Installs tabview (https://github.com/TabViewer/tabview) into a new conda env, and symlink to ~/opt/bin/tabview"
    install_env_and_symlink tabview tabview tabview

elif [ $task == "--install-black" ]; then
    ok "Installs black (https://black.readthedocs.io) into a new conda env, and symlink to ~/opt/bin/black"
    install_env_and_symlink black black black

elif [ $task == "--install-radian" ]; then
    ok "Installs radian (https://github.com/randy3k/radian) into a new conda env, and symlink to ~/opt/bin/radian"
    can_make_conda_env "radian"
    set +u
    # Note: radian needs R installed to compile the rchitect dependency. It
    # is unclear whether radian is dependent on a particular R version.
    conda create -n radian python r
    source activate radian
    pip install radian
    ln -sf $CONDA_LOCATION/envs/radian/bin/radian $HOME/opt/bin/radian
    source deactivate
    set -u
    printf "${YELLOW}Installed $HOME/opt/bin/radian${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-git-cola" ]; then
    ok "Installs git-cola (https://git-cola.github.io/). Clone to ~/opt/git-cola, create a new conda env, and symlink the binary to ~/opt/bin"
    # NOTE: git-cola has vendored-in PyQt. We may not actually need it in the
    # conda env?
    can_make_conda_env "git-cola"
    if [ -e ~/opt/git-cola ]; then
        printf "${RED}~/opt/git-cola already exists! Exiting.${UNSET}\n"
        exit 1
    fi
    conda create -n git-cola python=3 pyqt
    git clone git://github.com/git-cola/git-cola.git ~/opt/git-cola
    echo "#!/bin/bash" > ~/opt/bin/git-cola
    echo "$CONDA_LOCATION/envs/git-cola/bin/python $HOME/opt/git-cola/bin/git-cola" >> ~/opt/bin/git-cola
    chmod +x ~/opt/bin/git-cola
    printf "${YELLOW}Installed $HOME/opt/bin/git-cola${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-bat" ]; then
    ok "Installs bat (https://github.com/sharkdp/bat). Extracts the binary to ~/opt/bin"
    BAT_VERSION=0.12.1
    if [[ $OSTYPE == darwin* ]]; then
        download \
            "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-apple-darwin.tar.gz" \
            "/tmp/bat-${BAT_VERSION}.tar.gz"
    elsae
        download \
            "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"\
            "/tmp/bat-${BAT_VERSION}.tar.gz"
    fi
    mkdir -p /tmp/bat
    tar -xf "/tmp/bat-${BAT_VERSION}.tar.gz" -C /tmp/bat/
    mkdir -p ~/opt/bin
    cp /tmp/bat/bat*/bat ~/opt/bin
    rm -r /tmp/bat "/tmp/bat-${BAT_VERSION}.tar.gz"

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

elif [ $task == "--install-jq" ]; then
    ok "Installs jq to $HOME/opt/bin"
    download https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 $HOME/opt/bin/jq
    chmod +x $HOME/opt/bin/jq

elif [ $task == "--install-ripgrep" ]; then
    ok "Installs ripgrep to $HOME/opt/bin"
    mkdir -p /tmp/rg
    RG_VERSION=11.0.2
    download https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz /tmp/rg/ripgrep.tar.gz
    cd /tmp/rg
    tar -xf ripgrep.tar.gz
    cp ripgrep*/rg ~/opt/bin

elif [ $task == "--graphical-diffs" ]; then
    ok "Opens up meld to display differences between files in this repo and your home directory"
    for i in $(git ls-tree -r HEAD --name-only | grep "^\."); do meld $i ~/$i; done

elif [ $task == "--vim-diffs" ]; then
    ok "Opens up vim -d to display differences between files in this repo and your home directory"
    for i in $(git ls-tree -r HEAD --name-only | grep "^\."); do nvim -d $i ~/$i; done
else
    showHelp

fi

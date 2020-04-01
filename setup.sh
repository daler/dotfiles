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
    echo "recommended order. Each command will prompt if you want to continue."
    echo "Set the env var DOTFILES_FORCE=true if you want always say yes."
    echo
    echo "Many commands are OK to run on remote machines on which you do not "
    echo "have root access. These commands are marked 'remote OK'"
    echo
    printf "${GREEN}                       remote  Linux  Mac${UNSET} \n"
    printf "${GREEN}                        OK_____ | ___|   ${UNSET} \n"
    printf "${GREEN}                              | | |      ${UNSET} \n"
    printf "${GREEN}                              |x|x|x|    ${UNSET} \n"
    echo "Initial setup:"
    printf "  ${GREEN} --apt-get-installs         | |x| |  ${UNSET}(installs a bunch of useful Ubuntu packages)\n"
    printf "  ${GREEN} --apt-get-installs-minimal | |x| |  ${UNSET}(installs a bunch of useful Ubuntu packages)\n"
    printf "  ${GREEN} --download-nvim-appimage   | |x| |  ${UNSET}(download nvim AppImage)\n"
    printf "  ${GREEN} --download-macos-nvim      | | |x|  ${UNSET}(download binary nvim for MacOS)\n"
    printf "  ${GREEN} --powerline                | |x|x|  ${UNSET}(installs powerline fonts)\n"
    printf "  ${GREEN} --set-up-nvim-plugins      |x|x|x|  ${UNSET}(manually add vim-plug)\n"
    echo
    echo "conda:"
    printf "  ${GREEN} --install-miniconda        |x|x|x|  ${UNSET}(install downloaded Miniconda to ~/miniconda3)\n"
    printf "  ${GREEN} --set-up-bioconda          |x|x|x|  ${UNSET}(add channels for bioconda in proper order and make recommended speed-ups)\n"
    printf "  ${GREEN} --conda-env                |x|x| |  ${UNSET}(install requirements.txt into root conda env)\n"
    printf "  ${GREEN} --conda-env-mac            |x| |x|  ${UNSET}(install additional requirements-mac.txt into root conda env)\n"
    echo
    echo "Installations:"
    printf "  ${GREEN} --install-fzf              |x|x|x|  ${UNSET}(installs fzf)\n"
    printf "  ${GREEN} --install-ag               |x|x|x|  ${UNSET}(installs ag)\n"
    printf "  ${GREEN} --install-ripgrep          |x|x|x|  ${UNSET}(installs ripgrep)\n"
    printf "  ${GREEN} --install-autojump         |x|x| |  ${UNSET}(installs autojump)\n"
    printf "  ${GREEN} --install-hub              |x|x| |  ${UNSET}(installs hub and makes symlink)\n"
    printf "  ${GREEN} --install-fd               |x|x|x|  ${UNSET}(installs fd and makes symlink)\n"
    printf "  ${GREEN} --install-jq               |x|x| |  ${UNSET}(installs jq, 'like sed for JSON')\n"
    printf "  ${GREEN} --install-vd               |x|x|x|  ${UNSET}(installs visidata and makes symlink)\n"
    printf "  ${GREEN} --install-black            |x|x|x|  ${UNSET}(installs black and makes symlink)\n"
    printf "  ${GREEN} --install-radian           |x|x|x|  ${UNSET}(installs radian and makes symlink)\n"
    printf "  ${GREEN} --install-git-cola         |x|x|x|  ${UNSET}(installs git-cola and makes symlink)\n"
    printf "  ${GREEN} --install-bat              |x|x|x|  ${UNSET}(installs bat and makes symlink)\n"
    printf "  ${GREEN} --install-alacritty        | |x|x|  ${UNSET}(installs alacritty, a GPU-accelerated terminal emulator)\n"
    printf "  ${GREEN} --install-docker           | |x| |  ${UNSET}(installs docker and adds current user to new docker group)\n"
    echo
    echo "Dotfiles:"
    printf "  ${GREEN} --diffs                             ${UNSET}(inspect diffs between repo and home)\n"
    printf "  ${GREEN} --vim-diffs                         ${UNSET}(inspect diffs between repo and home, using vim -d)\n"
    printf "  ${GREEN} --graphical-diffs                   ${UNSET}(inspect diffs between repo and home, using meld)\n"
    printf "  ${GREEN} --dotfiles                          ${UNSET}(update dotfiles)\n"
    echo
    echo "paths to miniconda and neovim will be prepended to PATH in the"
    echo "~/.path file; that file will then be sourced"
    echo
    exit 0
}

# Deal with possibly-unset variables before we do set -u
if [ -z $1 ]; then
    showHelp
fi

if [ -z $DOTFILES_FORCE ]; then
    DOTFILES_FORCE=false
fi

set -eou pipefail

# The CLI is pretty minimal -- we're just doing an exact string match
task=$1

# Most tools install into here, so make sure it exists right from the start.
mkdir -p $HOME/opt/bin

# Depending on the system, we may have curl or wget but not both -- so try to
# figure it out.
try_curl() {
    url=$1; dest=$2; command -v curl > /dev/null && curl -fL $url > $dest
}
try_wget() {
    url=$1; dest=$2; command -v wget > /dev/null && wget -O- $url > $dest
}

# Generic download function
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
    if [ ! -e "$file" ]; then
        echo "$line" >> $file
    elif grep -vq "$line" $file; then
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
    # If the DOTFILES_FORCE=true env var was set, then no need to ask, we want
    # to always say yes
    if [ $DOTFILES_FORCE = "true" ]; then
        return 0
    fi
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

# Checks to see if ~/opt/bin is in the path, and if not, prints a reminder
check_opt_bin_in_path () {
    if ! echo $PATH | grep -q "$HOME/opt/bin"; then
        printf "${YELLOW}Please add${UNSET} $HOME/opt/bin ${YELLOW} to your \$PATH${UNSET}\n"
    fi
}

# For simple cases where you just want to have a separate conda env and symlink
# the binary over, use this function.
#
#  $1 is the environment name to create
#  $2 is the conda package to install
#  $3 is the executable in the env's bin dir to symlink to ~/opt/bin
#
# All of these may be the same, but there is flexibility to handle cases where
# they are not
install_env_and_symlink () {
    ENVNAME=$1
    CONDAPKG=$2
    EXECUTABLE=$3

    can_make_conda_env $ENVNAME
    conda create -n $ENVNAME $CONDAPKG
    ln -sf "$CONDA_LOCATION/envs/$ENVNAME/bin/$EXECUTABLE" $HOME/opt/bin/$EXECUTABLE
    printf "${YELLOW}Installed $HOME/opt/bin/$EXECUTABLE${UNSET}\n"
    check_opt_bin_in_path
}

# TASKS ----------------------------------------------------------------------
#
# Each task asks if it's OK to run; that also serves as documentation for each
# task.

if [ $task == "--apt-get-installs" ]; then
    ok "Installs packages from the file apt-installs.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs.txt | grep -v "^#")

elif [ $task == "--apt-get-installs-minimal" ]; then
    ok "Installs packages from the file apt-installs-minimal.txt"
    sudo apt-get update && \
    sudo apt-get install -y $(awk '{print $1}' apt-installs-minimal.txt | grep -v "^#")

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

elif [ $task == "--install-miniconda" ]; then
    ok "Installs Miniconda to $HOME/miniconda3/bin and then add $HOME/miniconda3/bin to the
    \$PATH by adding it to the end of ~/.path, and then source ~/.path"
    if [[ $OSTYPE == darwin* ]]; then
        download https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh miniconda.sh
    else
        download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh
    fi
    bash miniconda.sh -b
    add_line_to_file "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" ~/.path
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
    ok "Download AppImage for neovim, install into $HOME/opt/bin/nvim"
    dest="$HOME/opt/bin/nvim"
    mkdir -p $(dirname $dest)
    download https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage $dest
    chmod u+x $dest
    printf "${YELLOW}Installed neovim to $HOME/opt/bin/nvim${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--download-macos-nvim" ]; then
    ok "Downloads neovim tarball from https://github.com/neovim/neovim, install into $HOME/opt/bin/neovim"
    download https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz nvim-macos.tar.gz
    tar -xzvf nvim-macos.tar.gz
    mkdir -p "$HOME/opt/bin"
    mv nvim-osx64 "$HOME/opt/"
    ln -s ~/opt/nvim-osx64/bin/nvim ~/opt/bin/nvim

elif [ $task == "--set-up-nvim-plugins" ]; then
    ok "Downloads plug.vim into ~/.local/share/nvim/site/autoload/plug.vim. Read the instructions after this command when done."
    dest=~/.local/share/nvim/site/autoload/plug.vim
    mkdir -p $(dirname $dest)
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $dest
    echo
    echo "Open nvim and run :PlugInstall"
    echo

elif [ $task == "--install-fzf" ]; then
    ok "Installs fzf (https://github.com/junegunn/fzf)"
    (
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --no-update-rc --completion --key-bindings
      )

elif [ $task == "--install-ripgrep" ]; then
    ok "Installs ripgrep to $HOME/opt/bin"
    mkdir -p /tmp/rg
    RG_VERSION=11.0.2
    download https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz /tmp/rg/ripgrep.tar.gz
    cd /tmp/rg
    tar -xf ripgrep.tar.gz
    cp ripgrep*/rg ~/opt/bin

elif [ $task == "--install-autojump" ]; then
    ok "Installs autojump (https://github.com/wting/autojump)"
    (
        git clone https://github.com/wting/autojump.git /tmp/autojump-repo
        cd /tmp/autojump-repo
        python install.py
    )
    rm -rf /tmp/autojump-repo

elif [ $task == "--install-fd" ]; then
    ok "Install fd (https://github.com/sharkdp/fd) into a new conda env and symlink to ~/opt/bin/fd"
    install_env_and_symlink fd fd-find fd
    check_opt_bin_in_path

elif [ $task == "--install-vd" ]; then
    ok "Install visidata (https://visidata.org/) into a new conda env and symlink to ~/opt/bin/vd"
    install_env_and_symlink visidata visidata vd
    check_opt_bin_in_path

elif [ $task == "--install-hub" ]; then
    ok "Installs hub to $HOME/opt (https://github.com/github/hub)"
    HUB_VERSION=2.11.2
    if [[ $OSTYPE == darwin* ]]; then
        (
            download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-darwin-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
            cd /tmp
            tar -xf hub.tar.gz
            cd hub-darwin-amd64-${HUB_VERSION}
            prefix=$HOME/opt ./install
        )
    else
        (
            download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
            cd /tmp
            tar -xf hub.tar.gz
            cd hub-linux-amd64-${HUB_VERSION}
            prefix=$HOME/opt ./install
        )
    fi
    printf "${YELLOW}Installed to $HOME/opt/bin/hub${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-black" ]; then
    ok "Install black (https://black.readthedocs.io) into a new conda env and symlink to ~/opt/bin/black"
    install_env_and_symlink black black black
    check_opt_bin_in_path

elif [ $task == "--install-radian" ]; then
    ok "Install radian (https://github.com/randy3k/radian) into a new conda env and symlink to ~/opt/bin/radian"
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

    # The following creates a script called "git-cola" that ensures we run it
    # using the just-installed conda env
    echo "#!/bin/bash" > ~/opt/bin/git-cola
    echo "$CONDA_LOCATION/envs/git-cola/bin/python $HOME/opt/git-cola/bin/git-cola" >> ~/opt/bin/git-cola
    chmod +x ~/opt/bin/git-cola

    printf "${YELLOW}Installed $HOME/opt/bin/git-cola${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-bat" ]; then
    ok "Installs bat (https://github.com/sharkdp/bat). Extracts the binary to ~/opt/bin"
    BAT_VERSION=0.12.1
    BAT_TARBALL="/tmp/bat-${BAT_VERSION}.tar.gz"
    if [[ $OSTYPE == darwin* ]]; then
        download \
            "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-apple-darwin.tar.gz" \
            $BAT_TARBALL
    else
        download \
            "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"\
            $BAT_TARBALL
    fi
    mkdir -p /tmp/bat
    tar -xf $BAT_TARBALL -C /tmp/bat/
    mkdir -p ~/opt/bin
    cp /tmp/bat/bat*/bat ~/opt/bin
    rm -r "/tmp/bat-${BAT_VERSION}.tar.gz"
    check_opt_bin_in_path

elif [ $task == "--install-alacritty" ]; then
    ok "Installs alacritty terminal. Also needs to install rust"
    (
        set -eoux
        SRC=/tmp/alacritty
        rm -rf $SRC
        git clone https://github.com/jwilm/alacritty.git $SRC

        # Install rust
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
    if [[ $OSTYPE == darwin* ]]; then
        download https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64 $HOME/opt/bin/jq
else
        download https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 $HOME/opt/bin/jq
fi
    chmod +x $HOME/opt/bin/jq

elif [ $task == "--dotfiles" ]; then
    ok "Copies over all the dotfiles here to your home directory.
    Prompts again before actually running to make sure!"
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

    if [ $DOTFILES_FORCE == "true" ]; then
        doIt
    else
        read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            doIt
        fi
    fi
    unset doIt

elif [ $task == "--diffs" ]; then
    ok "Shows the diffs between this repo and what's in your home directory"
    cmd="diff --recursive --exclude .git --exclude setup.sh --exclude README.md --exclude Miniconda3-latest-Linux-x86_64.sh --exclude LICENSE-MIT.txt"
    $cmd ~ . | grep -v "Only in $HOME" | sed "s|$cmd||g"

elif [ $task == "--graphical-diffs" ]; then
    ok "Opens up meld to display differences between files in this repo and your home directory"
    for i in $(git ls-tree -r HEAD --name-only | grep "^\."); do meld $i ~/$i; done

elif [ $task == "--vim-diffs" ]; then
    ok "Opens up vim -d to display differences between files in this repo and your home directory"
    for i in $(git ls-tree -r HEAD --name-only | grep "^\."); do nvim -d $i ~/$i; done
else
    showHelp

fi

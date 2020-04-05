#!/bin/bash

# All-in-one bash script to perform various setup activities

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
UNSET="\e[0m"

export PS1=

function showHelp() {
    echo
    echo "Usage:"
    echo "   $0 [OPTION]"
    echo
    echo "Options are intended to be run one-at-a-time. They are listed here in "
    echo "Each command will prompt if you want to continue."
    echo "Set the env var DOTFILES_FORCE=true if you want always say yes."
    echo
    echo "Many commands are OK to run on remote machines on which you do not "
    echo "have root access. These commands are marked 'remote OK'"
    echo
    printf "${GREEN}                       remote  Linux  Mac${UNSET} \n"
    printf "${GREEN}                        OK_____ | ___|   ${UNSET} \n"
    printf "${GREEN}                              | | |      ${UNSET} \n"
    printf "${GREEN}                              |x|x|x|  (an 'x' indicates OK for that system) ${UNSET} \n"
    echo "Dotfiles:"
    printf "  ${GREEN} --diffs                             ${UNSET}inspect diffs between repo and home\n"
    printf "  ${GREEN} --vim-diffs                         ${UNSET}inspect diffs between repo and home, using vim -d\n"
    printf "  ${GREEN} --graphical-diffs                   ${UNSET}inspect diffs between repo and home, using meld\n"
    printf "  ${GREEN} --dotfiles                          ${UNSET}update dotfiles\n"
    echo "General setup:"
    printf "  ${GREEN} --apt-get-installs         | |x| |  ${UNSET}installs a bunch of useful Ubuntu packages)\n"
    printf "  ${GREEN} --apt-get-installs-minimal | |x| |  ${UNSET}installs a smaller set of useful Ubuntu packages)\n"
    printf "  ${GREEN} --install-neovim           |x|x|x|  ${UNSET}installs neovim ${BLUE}https://neovim.io/${UNSET}\n"
    printf "  ${GREEN} --powerline                | |x|x|  ${UNSET}powerline fonts for ${BLUE}https://github.com/vim-airline/vim-airline${UNSET}\n"
    printf "  ${GREEN} --set-up-vim-plugins       |x|x|x|  ${UNSET}set up vim-plug ${BLUE}https://github.com/junegunn/vim-plug${UNSET}\n"
    echo
    echo "conda:"
    printf "  ${GREEN} --install-miniconda        |x|x|x|  ${UNSET}${BLUE}https://docs.conda.io/en/latest/miniconda.html${UNSET}\n"
    printf "  ${GREEN} --set-up-bioconda          |x|x|x|  ${UNSET}${BLUE}https://bioconda.github.io/${UNSET}\n"
    printf "  ${GREEN} --conda-env                |x|x|x|  ${UNSET}install requirements.txt into root conda env\n"
    echo
    echo "Installations:"
    printf "  ${GREEN} --install-icdiff           |x|x|x|  ${UNSET}${BLUE}https://www.jefftk.com/icdiff${UNSET}\n"
    printf "  ${GREEN} --install-meld             | | |x|  ${UNSET}(currently Mac only)\n"
    printf "  ${GREEN} --install-fzf              |x|x|x|  ${UNSET}${BLUE}https://github.com/junegunn/fzf${UNSET}\n"
    printf "  ${GREEN} --install-ripgrep          |x|x|x|  ${UNSET}${BLUE}https://github.com/BurntSushi/ripgrep/${UNSET}\n"
    printf "  ${GREEN} --install-autojump         |x|x|x|  ${UNSET}${BLUE}https://github.com/wting/autojump${UNSET}\n"
    printf "  ${GREEN} --install-hub              |x|x|x|  ${UNSET}${BLUE}https://github.com/github/hub${UNSET}\n"
    printf "  ${GREEN} --install-fd               |x|x|x|  ${UNSET}${BLUE}https://github.com/sharkdp/fd${UNSET}\n"
    printf "  ${GREEN} --install-jq               |x|x|x|  ${UNSET}${BLUE}https://stedolan.github.io/jq/${UNSET}\n"
    printf "  ${GREEN} --install-vd               |x|x|x|  ${UNSET}${BLUE}https://visidata.org/${UNSET}\n"
    printf "  ${GREEN} --install-black            |x|x|x|  ${UNSET}${BLUE}https://black.readthedocs.io${UNSET}\n"
    printf "  ${GREEN} --install-radian           |x|x|x|  ${UNSET}${BLUE}https://github.com/randy3k/radian${UNSET}\n"
    printf "  ${GREEN} --install-git-cola         |x|x|x|  ${UNSET}${BLUE}https://git-cola.github.io/${UNSET}\n"
    printf "  ${GREEN} --install-bat              |x|x|x|  ${UNSET}${BLUE}https://git-cola.github.io/${UNSET}\n"
    printf "  ${GREEN} --install-alacritty        | |x|x|  ${UNSET}${BLUE}https://github.com/alacritty/alacritty${UNSET}\n"
    printf "  ${GREEN} --install-docker           | |x| |  ${UNSET}install docker and add current user to new docker group\n"
    echo
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
    [[ -e $(dirname $2) ]] || mkdir -p $(dirname $2)
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
    printf "${YELLOW}Channels configured, see ~/.condarc${UNSET}\n"

elif [ $task == "--conda-env" ]; then
    if [[ $OSTYPE == darwin* ]]; then
        ok "Installs dependencies in 'requirements.txt' and 'requirements-mac.txt' into the base conda environment"
        conda install --file requirements.txt --file requirements-mac.txt
    else
        ok "Installs dependencies in 'requirements.txt' into the base conda environment"
        conda install --file requirements.txt
    fi

elif [ $task == "--powerline" ]; then
    ok "Installs patched powerline fonts from https://github.com/powerline/fonts for use with vim-airline"
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    printf "${YELLOW}Change your terminal's config to use the new powerline patched fonts${UNSET}\n"
    echo

elif [ $task == "--install-neovim" ]; then
    NVIM_VERSION=0.4.3
    ok "Downloads neovim tarball from https://github.com/neovim/neovim, install into $HOME/opt/bin/neovim"
    if [[ $OSTYPE == darwin* ]]; then
        download https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-macos.tar.gz nvim-macos.tar.gz
        tar -xzf nvim-macos.tar.gz
        mkdir -p "$HOME/opt/bin"
        mv nvim-osx64 "$HOME/opt/neovim"
    else
        download https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz nvim-linux64.tar.gz
        tar -xzf nvim-linux64.tar.gz
        mv nvim-linux64 "$HOME/opt/neovim"
    fi
        ln -sf ~/opt/neovim/bin/nvim ~/opt/bin/nvim
        add_line_to_file 'alias "vim=nvim"' ~/.aliases
        printf "${YELLOW}- installed neovim to $HOME/opt/neovim${UNSET}\n"
        printf "${YELLOW}- created symlink $HOME/opt/bin/nvim${UNSET}\n"
        printf "${YELLOW}- added 'alias vim=nvim' to ~/.aliases${UNSET}\n"
        check_opt_bin_in_path

elif [ $task == "--set-up-vim-plugins" ]; then
    ok "Downloads plug.vim into ~/.local/share/nvim/site/autoload/plug.vim. (for nvim) and ~/.vim/autoload/plug.vim (for vim). Read the instructions after this command when done."
    nvim_dest=~/.local/share/nvim/site/autoload/plug.vim
    vim_dest=~/.vim/autoload/plug.vim
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $nvim_dest
    download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim $vim_dest
    echo
    printf "${YELLOW}Please open nvim and/or vim and run :PlugInstall{$UNSET}\n"
    echo

# ----------------------------------------------------------------------------
# Individual --install commands

elif [ $task == "--install-meld" ]; then
    ok "Downloads .dmg for meld, install into ~/opt/meld and then writes ~/opt/bin/meld wrapper"
    if [[ $OSTYPE == darwin* ]]; then
        download https://github.com/yousseb/meld/releases/download/osx-14/meldmerge.dmg /tmp/meldmerge.dmg
        set -x
        mounted=$(hdiutil attach /tmp/meldmerge.dmg | tail -1 | cut -f3)
        cp -r "$mounted" ~/opt/meld
        echo "~/opt/meld/Meld.app/Contents/MacOS/Meld \"\$@\"" > ~/opt/bin/meld
        hdiutil detach "$mounted"
        set +x
    else
        echo
        printf "${RED}--install-meld currently only supported on Mac.\n"
        printf "Use --apt-installs on Linux or '/usr/bin/python /usr/bin/meld' on Biowulf\n${UNSET}"
    fi

elif [ $task == "--install-fzf" ]; then
    ok "Installs fzf (https://github.com/junegunn/fzf)"
    (
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --no-update-rc --completion --key-bindings
    )
    printf "${YELLOW}fzf installed; see ~/.fzf${UNSET}\n"

elif [ $task == "--install-ripgrep" ]; then
    ok "Installs ripgrep to $HOME/opt/bin"
    mkdir -p /tmp/rg
    RG_VERSION=11.0.2
    download https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz /tmp/rg/ripgrep.tar.gz
    cd /tmp/rg
    tar -xf ripgrep.tar.gz
    cp ripgrep*/rg ~/opt/bin
    printf "${YELLOW}Installed to ~/opt/bin/rg${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-autojump" ]; then
    ok "Installs autojump (https://github.com/wting/autojump)"
    (
        git clone https://github.com/wting/autojump.git /tmp/autojump-repo
        cd /tmp/autojump-repo
        python install.py
    )
    rm -rf /tmp/autojump-repo
    printf "${YELLOW}autojump installed to default location of ~/.autojump${UNSET}\n"
    printf "${YELLOW}If you're not using the .functions file from these dotfiles, follow the instructions above output by autojump.${UNSET}\n"


elif [ $task == "--install-fd" ]; then
    ok "Install fd (https://github.com/sharkdp/fd) into a new conda env and symlink to ~/opt/bin/fd"
    install_env_and_symlink fd fd-find fd
    printf "${YELLOW}Installed to ~/opt/bin/fd${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--install-vd" ]; then
    ok "Install visidata (https://visidata.org/) into a new conda env and symlink to ~/opt/bin/vd"
    install_env_and_symlink visidata visidata vd
    printf "${YELLOW}Installed to ~/opt/bin/vd${UNSET}\n"
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
    printf "${YELLOW}Installed to ~/opt/bin/hub${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-black" ]; then
    ok "Install black (https://black.readthedocs.io) into a new conda env and symlink to ~/opt/bin/black"
    install_env_and_symlink black black black
    printf "${YELLOW}Installed to ~/opt/bin/black${UNSET}\n"
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

    printf "${YELLOW}Installed to ~/opt/bin/git-cola${UNSET}\n"
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
    printf "${YELLOW}Installed to ~/opt/bin/bat${UNSET}\n"
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
    printf "${YELLOW}Installed to ~/opt/bin/jq${UNSET}\n"
    check_opt_bin_in_path

elif [ $task == "--dotfiles" ]; then

    # Unique backup directory based on the hash of the current time, all
    # lowercase
    BACKUP_DIR="$HOME/dotfiles-backup-$(date +%s | sha256sum | base64 | head -c 8 | tr [:upper:] [:lower:])"

    ok "Copies over all the dotfiles here to your home directory.
    - A backup will be made in $BACKUP_DIR
    - List of files that will be copied is in 'include.files'
    - Prompts again before actually running to make sure!"

    cd "$(dirname "${BASH_SOURCE}")";

    function doIt() {
        rsync --no-perms --backup --backup-dir="$BACKUP_DIR" -avh --files-from=include.file . $HOME
        source ~/.bash_profile
    }

    if [ $DOTFILES_FORCE == "true" ]; then
        doIt
    else
        read -p "This may overwrite existing files in your home directory. Backups will be put in $BACKUP_DIR. Are you sure? (y/n) " -n 1;
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            doIt
        fi
    fi
    unset doIt

elif [ $task == "--install-icdiff" ]; then
    ok "Install icdiff (https://github.com/jeffkaufman/icdiff) into ~/opt/bin"
    download https://raw.githubusercontent.com/jeffkaufman/icdiff/release-1.9.2/icdiff ~/opt/bin/icdiff
    chmod +x ~/opt/bin/icdiff
    printf "${YELLOW}Installed to ~/opt/bin/icdiff${UNSET}\n"
    check_opt_bin_in_path

# ----------------------------------------------------------------------------
# Diffs section

elif [ $task == "--diffs" ]; then
    command -v ~/opt/bin/icdiff >/dev/null 2>&1 || {
        printf "${RED}Can't find icdiff. Did you run ./setup.sh --install-icdiff?, and is ~/opt/bin on your \$PATH?${UNSET}\n"
            exit 1;
        }
    ok "Shows the diffs between this repo and what's in your home directory"
    cmd="~/opt/bin/icdiff --recursive --line-numbers"
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

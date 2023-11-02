#! /bin/bash

# All-in-one bash script to perform various setup activities

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
UNSET="\e[0m"

export PS1=


# Since some commands affect .bashrc, it's most convenient to source it within
# this script
if [ -e ~/.bashrc ]; then
    source ~/.bashrc
fi

set -eo pipefail

# Change tool versions here
VISIDATA_VERSION=2.11
HUB_VERSION=2.14.2
NVIM_VERSION=0.9.1
RG_VERSION=13.0.0
BAT_VERSION=0.19.0
JQ_VERSION=1.6
ICDIFF_VERSION=2.0.4
BFG_VERSION=1.14.0
FD_VERSION=8.5.3
BLACK_VERSION=22.6.0
PYP_VERSION=1.1.0

function showHelp() {

    function header() {
        # Print a dashed line followed by yellow text
        echo "----------------------------------------------------------------------------"
        printf "${YELLOW}$1${UNSET}\n"
    }

    function cmd() {
        # Prints nicely-formatted command help.
        #
        # First argument is the command (like "--install-prog").
        #
        # All subsequent arguments will be joined together and will comprise
        # the description.

        label="  ${GREEN}$1${UNSET}"

        # Note that "." is used here as a placeholder instead of " ". It was
        # challenging to get whitespace to work correctly with the sed
        # commands. So the padding is only converted to spaces at the very end.

        # This converts the provided arg ('--install-prog') into dots
        pad_cmd=$(echo $1 | sed 's/[a-zA-Z\-]/./g')

        # This is the full size of the padding, used for all lines but the
        # first.
        pad_full="........................."

        # Calculate padding for the first line by deleting the number of
        # characters used by the command, plus two (for the leading 2 spaces
        # added to $label above)
        pad1=$(echo $pad_full | sed 's/'"$pad_cmd"'..//' | sed 's/./ /g')

        # The full padding is converted to spaces.
        pad2=$(echo $pad_full | sed 's/./ /g')

        # Concat all args but the first (${@:2}), format them to 60 spaces
        # using the built-in `fmt`, and then use awk to use pad1 for the first
        # line and pad2 for subsequent lines
        desc=$(echo "${@:2}" \
            | fmt -w 60 \
            | awk -v pad1="$pad1" -v pad2="$pad2" \
            'NR==1{print pad1$0} NR >1 {print pad2$0}')
        printf "$label$desc\n\n"
    }

    echo
    printf "${YELLOW}Usage:${UNSET}\n\n"
    echo "   $0 [ARGUMENT]"
    echo
    echo "     - Options are intended to be run one-at-a-time."
    echo "     - Each command will prompt if you want to continue."
    echo "     - Set the env var DOTFILES_FORCE=true if you want always say yes."
    echo
    printf "   ${BLUE}Documentation: https://daler.github.io/dotfiles/${UNSET}\n"
    echo

    header "RECOMMENDED ORDER:"
    echo "    1)  ./setup.sh --dotfiles"
    echo "    2)  CLOSE TERMINAL, OPEN A NEW ONE"
    echo "    3)  ./setup.sh --install-neovim"
    echo "    5)  ./setup.sh --install-conda"
    echo "    6)  ./setup.sh --set-up-bioconda"
    echo "    7)  ./setup.sh --install-fzf"
    echo "    8)  ./setup.sh --install-ripgrep"
    echo "    9)  ./setup.sh --install-vd"
    echo "    10) ./setup.sh --install-pyp"
    echo "    11) ./setup.sh --install-fd"
    echo
    echo "  On Mac:"
    echo "       ./setup.sh --mac-stuff"
    echo "       ./setup.sh --install-tmux"
    echo ""
    echo "  Then browse the other options below to see what else is available/useful."

    header "dotfiles:"

    cmd "--diffs" \
        "Inspect diffs between repo and home"

    cmd "--vim-diffs" \
        "Inspect diffs between repo and home, using vim -d"

    cmd "--dotfiles" \
        "Replaces files in $HOME with files from this directory"

    header "General setup:"

    cmd "--apt-install" \
        "Local Linux only, needs root. Install a bunch of useful Ubuntu" \
        "packages. See apt-installs.txt for list, and edit if needed."

    cmd "--apt-install-minimal" \
        "Local Linux only, needs root. Install a smaller set of useful Ubuntu" \
        "packages. See apt-installs-minimal.txt for list, and edit if needed"

    cmd "--install-neovim" \
        "neovim is a drop-in replacement for vim, with additional features" \
        "Homepage: https://neovim.io/"

    cmd "--compile-neovim" \
        "If installing Neovim doesn't work or you want a more recent version," \
        "use this command. You will need the prequisites " \
        " (https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites) " \
        "installed."

    header "conda setup:"

    cmd "--install-conda" \
        "Install conda using the Mambaforge installation" \
        "Homepage: https://github.com/conda-forge/miniforge"

    cmd "--set-up-bioconda" \
        "Set up bioconda channel priorities." \
        "Homepage: https://bioconda.github.io"

    cmd "--conda-env" \
        "Install requirements.txt into root conda env." \
        "Sets up a reasonable base conda env, edit requirements.txt" \
        "(or requirements-mac.txt on a Mac) to customize."

    header "Installations for local host only"

    cmd "--mac-stuff" \
        "Make some Mac-specific settings"

    cmd "--powerline" \
        "Install powerline fonts. Powerline fonts include the" \
        "fancy glyphs used for the vim-airline status bar." \
        "Only needs to be installed on local machine that is running" \
        "the terminal app." \
        "Homepage: https://github.com/vim-airline/vim-airline"

    cmd "--fix-tmux-terminfo" \
        "Update terminfo so that italics work within tmux; " \
        "see https://jdhao.github.io/2018/10/19/tmux_nvim_true_color"

    cmd "--install-alacritty" \
        "Alacritty is a terminal emulator that is quite fast;" \
        "its speed is clear when catting a large file in tmux." \
        "(Only install on local machine)" \
        "Homepage: https://github.com/alacritty/alacritty"

    cmd "--install-docker" \
        "Installs docker and adds current user to new docker group." \
        "(Needs root, Linux only)"

    header "Installations for any host:"

    cmd "--install-tmux" \
        "Install tmux"

    cmd "--install-bat" \
        "bat is like cat, but adds things like syntax highlighting," \
        "showing lines changed based on git, and showing non-printable" \
        "characters." \
        "Homepage: https://github.com/sharkdp/bat"

    cmd "--install-bfg" \
        "The BFG is a simpler, faster alternative to git-filter-branch" \
        "for cleaning bad data out of a git repo like big files or" \
        "senstive information"

    cmd "--install-black" \
        "The self-described 'uncompromising' Python formatter." \
        "Re-formats Python code to match PEP8 guidelines." \
        "Homepage: https://black.readthedocs.io"

    cmd "--install-fd" \
        "fd is a fast replacement for find, with additional" \
        "useful features." \
        "Homepage: https://github.com/sharkdp/fd"

    cmd "--install-fzf" \
        "fzf (fuzzy-finder) replaces your bash Ctrl-R reverse" \
        "history search. You can also can pipe anything into it for" \
        "on-the-fly fuzzy searches on text" \
        "Homepage: https://github.com/junegunn/fzf"

    cmd "--install-hub" \
        "hub is a command-line wrapper for git, which allows" \
        "you to do things with GitHub like easily check out PRs" \
        "Homepage: https://github.com/github/hub"

    cmd "--install-icdiff" \
        "icdiff shows colored diffs side-by-side in the terminal" \
        "and shows whitespace diffs by default" \
        "Homepage: https://www.jefftk.com/icdiff"

    cmd "--install-jq" \
        "jq is a command-line tool for extracting information" \
        "from json files." \
        "Homepage: https://stedolan.github.io/jq"

    cmd "--install-pyp" \
        "pyp lets you run arbitrary python directly from" \
        "the command line. Great as a calculator, but can also" \
        "manipulate piped-in text" \
        "Homepage: https://github.com/hauntsaninja/pyp"

    cmd "--install-radian" \
        "radian is a wrapper for the R interpreter, which adds" \
        "syntax highlighting and tab-completion" \
        "Homepage: https://github.com/randy3k/radian"

    cmd "--install-ripgrep" \
        "ripgrep (rg) is a very fast grep replacement, especially" \
        "good for exploring code bases" \
        "Homepage: https://github.com/BurntSushi/ripgrep/"

    cmd "--install-vd" \
        "visidata (vd) is great for viewing, searching, sorting" \
        "tables (TSVs, CSVs, XLS). Only thing it can't do is edit them." \
        "Homepage: https://visidata.org/"

    cmd "--install-zoxide" \
        "zoxide keeps track of recent directories you have changed" \
        "to and provides a convenient interface for jumping directly" \
        "there." \
        "Homepage: https://github.com/ajeetdsouza/zoxide"
    echo
}

# Deal with possibly-unset variables before we do set -u
if [ -z $1 ]; then
    showHelp | less -R
    exit 0
fi

if [ -z $DOTFILES_FORCE ]; then
    DOTFILES_FORCE=false
fi

set -eo pipefail

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

    # Newer versions of conda have some sort of catch on "conda env list"  if
    # you pipe the output of to something else. The help says to use --json for
    # programmatic use of conda. So here we use JSON output, which requires
    # also checking for the trailing ", of a JSON entry, hence the awkward grep
    # command.
    if conda env list --json | grep -q "/$1\",\$"; then
        printf "${RED}conda env $1 already exists!\n"
        printf "You can remove it with:\n"
        printf "    conda env remove -n $1\n"
        printf "Exiting.${UNSET}\n"
        return 1
    fi
}


# Find the conda installation location
CONDA_LOCATION=
MAMBA_LOCATION=
check_for_conda () {
    if command -v conda > /dev/null; then

        CONDA_LOCATION=$(conda info --base)
        MAMBA_LOCATION=$(mamba info --base)

        # Even if the user has not run conda init, this will enable the use of
        # "conda activate" within the various conda creation steps below.
        eval "$(conda shell.bash hook)"

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

    eval "$(conda shell.bash hook)"

    # sometimes conda can complain about env vars being unset
    set +u
    ENVNAME=$1
    CONDAPKG=$2
    EXECUTABLE=$3

    can_make_conda_env $ENVNAME
    mamba create -y -n $ENVNAME $CONDAPKG
    ln -sf "$MAMBA_LOCATION/envs/$ENVNAME/bin/$EXECUTABLE" $HOME/opt/bin/$EXECUTABLE
    printf "${YELLOW}Installed $HOME/opt/bin/$EXECUTABLE${UNSET}\n"
    check_opt_bin_in_path
    set -u
}

# TASKS ----------------------------------------------------------------------
#
# Each task asks if it's OK to run; that also serves as documentation for each
# task.

if [ $task == "--apt-install" ]; then
    ok "Installs packages from the file apt-installs.txt"
    sudo apt-get update && \
    sudo apt-get install $(awk '{print $1}' apt-installs.txt | grep -v "^#")


elif [ $task == "--apt-install-minimal" ]; then
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

elif [ $task == "--install-conda" ]; then
    ok "Installs conda using the Mambaforge installation"

    # On Biowulf/Helix, if we install into $HOME then the installation might
    # larger than the quota for the home directory. Instead, install to user's
    # data directory which has much more space.
    # Also, .path needs to reflect this change.
    MAMBAFORGE_DIR=$HOME/mambaforge
    if [[ $HOSTNAME == "helix.nih.gov" || $HOSTNAME == "biowulf.nih.gov" ]]; then
        MAMBAFORGE_DIR=/data/$USER/mambaforge

        # Newer versions of the installer cannot run from a noexec directory
        # which may be the case on some hosts. See discussion at
        # https://github.com/ContinuumIO/anaconda-issues/issues/11154#issuecomment-535571313
        export TMPDIR=/data/$USER/mambaforge

   fi

    download "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" mambaforge.sh
    bash mambaforge.sh -b -p $MAMBAFORGE_DIR
    rm mambaforge.sh
    echo "export PATH=\$PATH:$MAMBAFORGE_DIR/condabin" >> ~/.path
    printf "${YELLOW}conda installed at ${MAMBAFORGE_DIR}/condabin. This has been added to your ~/.path file, but you should double-check to make sure it gets on your path.${UNSET}\n"

elif [ $task == "--set-up-bioconda" ]; then
    ok "Sets up Bioconda by adding the dependent channels in the correct order"
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    conda config --set channel_priority strict
    printf "${YELLOW}Channels configured, see ~/.condarc${UNSET}\n"


elif [ $task == "--conda-env" ]; then
    if [[ $OSTYPE == darwin* ]]; then
        ok "Installs dependencies in 'requirements.txt' and 'requirements-mac.txt' into the base conda environment"
        conda install --file requirements.txt --file requirements-mac.txt
    else
        ok "Installs dependencies in 'requirements.txt' into the base conda environment"
        conda install --file requirements.txt
    fi


elif [ $task == "--install-neovim" ]; then
    ok "Downloads neovim tarball from https://github.com/neovim/neovim, install into $HOME/opt/bin/neovim"
    if [[ $OSTYPE == darwin* ]]; then
        download https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-macos.tar.gz nvim-macos.tar.gz
        tar -xzf nvim-macos.tar.gz
        mkdir -p "$HOME/opt/bin"
        mv nvim-macos "$HOME/opt/neovim"
    else
        download https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz nvim-linux64.tar.gz
        tar -xzf nvim-linux64.tar.gz
        mv nvim-linux64 "$HOME/opt/neovim"
        rm nvim-linux64.tar.gz
    fi
        ln -sf ~/opt/neovim/bin/nvim ~/opt/bin/nvim
        printf "${YELLOW}- installed neovim to $HOME/opt/neovim${UNSET}\n"
        printf "${YELLOW}- created symlink $HOME/opt/bin/nvim${UNSET}\n"
        check_opt_bin_in_path

elif [ $task == "--compile-neovim" ]; then
    NVIM_VERSION=stable
    ok "Clones the stable branch of the neovim repo, compiles it, and installs it into $HOME/opt/bin/nvim"
    if [ -e "$HOME/opt/neovim" ];
    then
        ok "Warning, need to delete $HOME/opt/neovim, is that ok?"
        rm -rv "$HOME/opt/neovim"
    fi
    download https://github.com/neovim/neovim/archive/refs/tags/stable.zip neovim-stable.zip
    unzip neovim-stable.zip
    (
        cd neovim-stable
        make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/opt/neovim"
        make install
        mkdir -p "$HOME/opt/bin"
        ln -sf "$HOME/opt/neovim/bin/nvim" "$HOME/opt/bin/nvim"
    )
    rm -rf neovim-stable.zip neovim-stable
    printf "${YELLOW}- installed neovim to $HOME/opt/neovim${UNSET}\n"
    printf "${YELLOW}- created symlink $HOME/opt/bin/nvim${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--mac-stuff" ]; then
    ok "Sets the shell to be bash, and silences the warning about zsh being the default by adding an env var to ~/.extra"
    chsh -s /bin/bash
    echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> ~/.extra

elif [ $task == "--powerline" ]; then
    ok "Installs patched powerline fonts from https://github.com/powerline/fonts for use with vim-airline"
    git clone https://github.com/powerline/fonts.git --depth 1 /tmp/fonts
    (cd /tmp/fonts && ./install.sh)
    rm -rf /tmp/fonts
    echo
    printf "${YELLOW}Change your terminal's config to use the new powerline patched fonts${UNSET}\n"
    echo



# ----------------------------------------------------------------------------
# Individual --install commands

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

    if [[ $OSTYPE == darwin* ]]; then
        URL=https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-apple-darwin.tar.gz
    else
        URL=https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz
    fi

    download $URL /tmp/rg/ripgrep.tar.gz
    cd /tmp/rg
    tar -xf ripgrep.tar.gz
    cp ripgrep*/rg ~/opt/bin
    printf "${YELLOW}Installed to ~/opt/bin/rg${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-fd" ]; then
    ok "Install fd (https://github.com/sharkdp/fd) into a new conda env and symlink to ~/opt/bin/fd"
    install_env_and_symlink fd fd-find="${FD_VERSION}" fd
    printf "${YELLOW}Installed to ~/opt/bin/fd${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-tmux" ]; then
    ok "Install tmux into a new conda env and symlink to ~/opt/bin/tmux"
    install_env_and_symlink tmux tmux tmux
    printf "${YELLOW}Installed to ~/opt/bin/tmux${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-vd" ]; then
    ok "Install visidata (https://visidata.org/) into a new conda env and symlink to ~/opt/bin/vd"
    install_env_and_symlink visidata visidata="${VISIDATA_VERSION}" vd
    printf "${YELLOW}Installed to ~/opt/bin/vd${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-hub" ]; then
    ok "Installs hub to $HOME/opt (https://github.com/github/hub)"
    if [[ $OSTYPE == darwin* ]]; then
        (
            download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-darwin-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
            cd /tmp
            tar -xf hub.tar.gz
            cd hub-darwin-amd64-${HUB_VERSION}
            prefix=$HOME/opt bash install
        )
    else
        (
            download https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz /tmp/hub.tar.gz
            cd /tmp
            tar -xf hub.tar.gz
            cd hub-linux-amd64-${HUB_VERSION}
            prefix=$HOME/opt bash install
        )
    fi
    printf "${YELLOW}Installed to ~/opt/bin/hub${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-black" ]; then
    ok "Install black (https://black.readthedocs.io) into a new conda env and symlink to ~/opt/bin/black"
    install_env_and_symlink black black="${BLACK_VERSION}" black
    printf "${YELLOW}Installed to ~/opt/bin/black${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-radian" ]; then
    ok "Install radian (https://github.com/randy3k/radian) into a new conda env and symlink to ~/opt/bin/radian"
    can_make_conda_env "radian"
    set +u
    # Note: radian needs R installed to compile the rchitect dependency. It
    # is unclear whether radian is dependent on a particular R version.
    mamba create -y -n radian python r
    conda activate radian
    pip install radian
    ln -sf $MAMBA_LOCATION/envs/radian/bin/radian $HOME/opt/bin/radian
    conda deactivate
    set -u
    printf "${YELLOW}Installed $HOME/opt/bin/radian${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-bat" ]; then
    ok "Installs bat (https://github.com/sharkdp/bat). Extracts the binary to ~/opt/bin"
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

    if [[ $OSTYPE == darwin* ]]; then
        printf "${YELLOW}Please download the .dmg from https://github.com/alacritty/alacritty/releases "
        printf "and drag the application either to Applications (if you have access) or to the Desktop.${UNSET}.\n"
        printf "\n${YELLOW}Then download the alacritty.yml file from that same URL, and place it in ~/.config/alacritty/alacritty.yml${UNSET}\n\n"

    else
        ok "Installs alacritty terminal. Also needs to install rust"
        (
            set -eoux
            SRC=$HOME/opt/tmp/alacritty
            rm -rf $SRC
            git clone https://github.com/jwilm/alacritty.git $SRC

            # The Docker tests run in a non-interactive terminal, so we need to
            # detect and handle that.
            case "$-" in
            *i*)  RUSTUP_Y="" ;;
            *)    RUSTUP_Y=" -y " ;;
            esac

            # Extra installations needed to compile alacritty
            sudo apt-get install -y \
                cmake \
                libfontconfig1-dev \
                libfreetype6-dev \
                libxcb-xfixes0-dev \
                pkg-config \
                python3

            # Install rust
            if [ ! `test "cargo"` ]; then
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > alacritty_install.sh
                sh alacritty_install.sh $RUSTUP_Y
                source ~/.cargo/env
                rm alacritty_install.sh
            fi

            rustup override set stable
            rustup update stable
            (
                cd $SRC;
                cargo build --release
                cp target/release/alacritty $HOME/opt/bin/alacritty
            )
        )
    fi


elif [ $task == "--install-jq" ]; then
    ok "Installs jq to $HOME/opt/bin"
    if [[ $OSTYPE == darwin* ]]; then
        download https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-osx-amd64 $HOME/opt/bin/jq
    else
        download https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 $HOME/opt/bin/jq
    fi
    chmod +x $HOME/opt/bin/jq
    printf "${YELLOW}Installed to ~/opt/bin/jq${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-icdiff" ]; then
    ok "Install icdiff (https://github.com/jeffkaufman/icdiff) into ~/opt/bin"
    download https://raw.githubusercontent.com/jeffkaufman/icdiff/release-${ICDIFF_VERSION}/icdiff ~/opt/bin/icdiff
    chmod +x ~/opt/bin/icdiff
    printf "${YELLOW}Installed to ~/opt/bin/icdiff${UNSET}\n"
    check_opt_bin_in_path


elif [ $task == "--install-pyp" ]; then
    ok "Install pyp (https://github.com/hauntsaninja/pyp) into ~/opt/bin"
    set +u
    can_make_conda_env "pyp"
    mamba create -y -n pyp python
    conda activate pyp
    pip install pypyp==${PYP_VERSION}
    ln -sf $(which pyp) $HOME/opt/bin/pyp
    conda deactivate
    printf "${YELLOW}Installed to ~/opt/bin/pyp${UNSET}\n"
    check_opt_bin_in_path
    set -u


elif [ $task == "--install-zoxide" ]; then
    ok "Install zoxide (https://github.com/ajeetdsouza/zoxide/) into ~/opt/bin?"

    install_env_and_symlink zoxide zoxide zoxide
    printf "${YELLOW}Installed to ~/opt/bin/zoxide${UNSET}\n"

    set +x
    check_opt_bin_in_path
    printf "${YELLOW}Installed to ~/opt/bin/zoxide.${UNSET}\n\n"
    printf "${YELLOW}To start using, you need to add the following line to your .bash_profile or .bashrc:${UNSET}\n\n"
    printf "     ${YELLOW}eval \"\$(zoxide init bash)\"${UNSET}\n\n"

elif [ $task == "--install-bfg" ]; then
    ok "Install BFG (https://rtyley.github.io/bfg-repo-cleaner/) git repo cleaner to ~/opt/bin?"
    BFG_WRAPPER=~/opt/bin/bfg
    download https://repo1.maven.org/maven2/com/madgag/bfg/${BFG_VERSION}/bfg-${BFG_VERSION}.jar ~/opt/bin/bfg-${BFG_VERSION}.jar

    # Make a convenient wrapper
    echo "#! /bin/bash" > $BFG_WRAPPER
    echo "java -jar ~/opt/bin/bfg-${BFG_VERSION}.jar" '$@' >> $BFG_WRAPPER
    chmod +x $BFG_WRAPPER
    check_opt_bin_in_path
    printf "${YELLOW}Installed jar file to ~/opt/bin, and created wrapper script ~/opt/bin/bfg.${UNSET}\n\n"

elif [ $task == "--dotfiles" ]; then
    set -x

    # Unique backup directory based on the hash of the current time, all
    # lowercase
    #
    # Mac doesn't have md5sum, so we use md5
    if [[ $OSTYPE == darwin* ]]; then
        md5program=md5
    else
        md5program=md5sum
    fi

    BACKUP_DIR="$HOME/dotfiles-backup-$(date +%s | $md5program | base64 | head -c 8 | tr [:upper:] [:lower:])"

    ok "Copies over all the dotfiles here to your home directory.
    - A backup will be made in $BACKUP_DIR
    - List of files that will be copied is in 'include.files'
    - Prompts again before actually running to make sure!"

    cd "$(dirname "${BASH_SOURCE}")";

    function doIt() {
        rsync --no-perms --backup --backup-dir="$BACKUP_DIR" -avh --files-from=include.file . $HOME
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

elif [ $task == "--fix-tmux-terminfo" ]; then
    ok "Runs the fix from https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/ for getting italics in tmux"
    download http://invisible-island.net/datafiles/current/terminfo.src.gz terminfo.src.gz
    gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src
    rm terminfo.src
    printf "${YELLOW}Added ~/.terminfo. You can now use 'set -g default-terminal \"screen-256color\" in your .tmux.conf.${UNSET}\n"



# ----------------------------------------------------------------------------
# Diffs section

elif [ $task == "--diffs" ]; then
    command -v ~/opt/bin/icdiff >/dev/null 2>&1 || {
        printf "${RED}Can't find icdiff. Did you run ./setup.sh --install-icdiff?, and is ~/opt/bin on your \$PATH?${UNSET}\n"
            exit 1;
        }
    ok "Shows the diffs between this repo and what's in your home directory"
    cmd="$HOME/opt/bin/icdiff --recursive --line-numbers"
    $cmd ~ . | grep -v "Only in $HOME" | sed "s|$cmd||g"

elif [ $task == "--vim-diffs" ]; then
    ok "Opens up vim -d to display differences between files in this repo and your home directory"
    for i in $(git ls-tree -r HEAD --name-only | grep "^\."); do
        if ! diff $i ~/$i &> /dev/null; then
            nvim -d $i ~/$i;
        fi
    done
else
    showHelp

fi

FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y git wget curl sudo rsync locales vim

# Locale is set in .bash_profile; needs to be created
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# From now on, use login shell so that bashrc gets sourced
ENV SHELL /bin/bash

# Get this installed up front out of the way without prompting for a region
# (which otherwise hangs the build)
RUN DEBIAN_FRONTEND=noninteractive apt-get install tzdata

ENV TMPDIR=/tmp
ENV USER=dockeruser
ENV HOME=/root/dockeruser
RUN mkdir -p $HOME
RUN mkdir -p $TMPDIR

# Don't prompt for user input when using setup.sh
ENV DOTFILES_FORCE=true

WORKDIR dotfiles

# These apt installs typically take the longest time, so run early before
# adding other files, which may otherwise invalidate the cache even though they
# are unrelated.
ADD apt-installs-minimal.txt setup.sh .
RUN ./setup.sh --apt-install-minimal

# Now add the rest of the files
ADD \
.aliases \
.bash_profile \
.bash_prompt \
.bashrc \
.dircolors \
.dircolors \
.exports \
.extra \
.functions \
.git-completion.bash \
.gitconfig \
.path \
.tmux.conf \
.vimrc \
apt-installs.txt \
include.file \
requirements-mac.txt \
requirements.txt \
.

# Directories have to be ADDed one at a time
ADD .config ./.config
ADD .config/nvim/lua ./.config/nvim/lua
ADD .config/nvim/lua/plugins ./.config/nvim/lua/plugins

# Run setup in order
RUN ./setup.sh --dotfiles
RUN ./setup.sh --install-neovim
RUN ./setup.sh --install-conda
RUN ./setup.sh --set-up-bioconda

# Various tool installations using ./setup.sh
RUN ./setup.sh --install-fzf
RUN ./setup.sh --install-ripgrep
RUN ./setup.sh --install-vd
RUN ./setup.sh --install-pyp
RUN ./setup.sh --install-tmux
RUN ./setup.sh --install-bat
RUN ./setup.sh --install-black
RUN ./setup.sh --install-fd
RUN ./setup.sh --install-hub
RUN ./setup.sh --install-icdiff
RUN ./setup.sh --install-jq

# Not working on --platform=linux/amd64
# RUN ./setup.sh --install-radian

# Additional for this container: asciinema for screen casts
RUN source ~/.bashrc \
    pip install asciinema \
    conda install -n base r-base ipython

ENTRYPOINT ["/bin/bash", "-c"]

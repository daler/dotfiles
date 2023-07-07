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

ADD . dotfiles
WORKDIR dotfiles
RUN git checkout $BRANCH

# Run setup in order

ENV DOTFILES_FORCE=true
RUN ./setup.sh --apt-install-minimal
RUN ./setup.sh --dotfiles

RUN ./setup.sh --install-conda
RUN ./setup.sh --set-up-bioconda
RUN ./setup.sh --install-neovim
RUN ./setup.sh --set-up-vim-plugins

# Various installations using ./setup.sh
RUN ./setup.sh --install-autojump
RUN ./setup.sh --install-bat
RUN ./setup.sh --install-black
RUN ./setup.sh --install-fd
RUN ./setup.sh --install-fzf
RUN ./setup.sh --install-hub
RUN ./setup.sh --install-icdiff
RUN ./setup.sh --install-jq
RUN ./setup.sh --install-pyp
RUN ./setup.sh --install-radian
RUN ./setup.sh --install-ripgrep
RUN ./setup.sh --install-vd
RUN ./setup.sh --install-tmux

# Additional for this container: asciinema for screen casts
RUN source ~/.bashrc \
    pip install asciinema \
    conda install -n base r-base ipython

ENTRYPOINT ["/bin/bash"]

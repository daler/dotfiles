FROM ubuntu:latest

SHELL ["/bin/bash", "--login", "-c"]

RUN apt update && apt install -y git wget curl sudo rsync locales

# Locale is set in .bash_profile; needs to be created
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# From now on, use login shell so that bashrc gets sourced
ENV SHELL /bin/bash

ENV DOTFILES_FORCE=true
RUN git clone https://github.com/daler/dotfiles
WORKDIR dotfiles

# Run setup in order
RUN ./setup.sh --apt-get-installs-minimal
RUN ./setup.sh --install-miniconda
RUN ./setup.sh --dotfiles
RUN ./setup.sh --set-up-bioconda
RUN ./setup.sh --download-nvim-appimage

# Docker images can't use FUSE (without lots of extra work to use the host
# kernel), so we extract and reset the alias
RUN (cd ~ && nvim --appimage-extract)
RUN ln -sf ~/squashfs-root/usr/bin/nvim ~/opt/bin/nvim

RUN ./setup.sh --set-up-nvim-plugins

# Don't know why yet, but the alias isn't sticking. But this installs plugins
# without interaction
RUN nvim +PlugInstall +qall

# Various installations using ./setup.sh
RUN ./setup.sh --install-fzf
RUN ./setup.sh --install-ripgrep
RUN ./setup.sh --install-vd
RUN ./setup.sh --install-bat

# Additional for this container: asciinema for screen casts
RUN pip install asciinema
RUN conda install r-base
RUN conda install ipython
RUN ./setup.sh --install-radian

ENTRYPOINT ["/bin/bash"]

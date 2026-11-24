FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    curl \
    git \
    locales \
    python3-venv \
    rsync \
    sudo \
    unzip \
    vim \
    wget

# Locale is set in .bash_profile; needs to be created in this image though
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# Use Bash for RUN instructions; source ~/.bashrc explicitly where needed.
SHELL [ "/bin/bash", "-c" ]
ENV SHELL=/bin/bash

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

WORKDIR /dotfiles

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
.functions \
.git-completion.bash \
.gitconfig \
.path \
.tmux.conf \
.vimrc \
.Rprofile \
apt-installs.txt \
include.file \
requirements-mac.txt \
requirements.txt \
.

# Directories have to be ADDed one at a time
ADD .config ./.config
ADD .config/nvim/lua ./.config/nvim/lua
ADD .ipython ./.ipython
ADD .ipython/profile_default ./.ipython/profile_default

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
RUN ./setup.sh --install-npm

RUN ./setup.sh --nvim-mason-tools
RUN ./setup.sh --nvim-treesitter-parsers


RUN "$HOME/opt/bin/nvim" --headless \
   "+lua require('lazy').load({plugins = {'blink.cmp'}})" \
   "+lua if not vim.wait(120000, function() return require('blink.cmp.fuzzy').implementation_type == 'rust' end, 100) then vim.cmd('cquit 1') end" \
   +qa

# Not working on --platform=linux/amd64
# RUN ./setup.sh --install-radian


# Additional for this container: asciinema for screen casts
RUN source ~/.bashrc \
    && ca \
    && conda create -y -n asciinema asciinema \
    && ln -s $(conda info --base)/envs/asciinema/bin/asciinema ~/opt/bin

# imagemagick for converting gifs
RUN source ~/.bashrc \
    && ca \
    && conda create -y -n imagemagick imagemagick \
    && ln -s $(conda info --base)/envs/imagemagick/bin/convert ~/opt/bin

# Install fonts for use by agg
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FantasqueSansMono.zip \
    && mkdir -p ~/.local/share/fonts \
    && ( cd ~/.local/share/fonts \
        && unzip /dotfiles/FantasqueSansMono.zip ) \
    && fc-cache \
    && rm /dotfiles/FantasqueSansMono.zip

RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/JetBrainsMono.zip \
    && rm -rf ~/.local/share/fonts \
    && mkdir -p ~/.local/share/fonts \
    && ( cd ~/.local/share/fonts \
        && unzip /dotfiles/JetBrainsMono.zip ) \
    && fc-cache \
    && rm /dotfiles/JetBrainsMono.zip

# asciinema/agg for cast -> gif
RUN curl -fsSL https://github.com/asciinema/agg/releases/download/v1.9.0/agg-x86_64-unknown-linux-gnu > ~/opt/bin/agg \
    && chmod +x ~/opt/bin/agg

# make it easier to run by using a patched font, and make borders show up
# correctly by using a slower but more complete renderer
RUN echo "alias AGG=\"agg --renderer=resvg --font-family='JetBrainsMono Nerd Font Mono'\"" >> ~/.aliases

# RUN source ~/.bashrc && ~/opt/bin/nvim --headless "+Lazy! sync" +qa

# Allow lazy.nvim to update. Comment this out if you want to capture that process
# RUN source ~/.bashrc && nvim +"lua require('lazy').restore({wait=true})" +q

# For demos with toggleterm and r-nvim, install R and IPython
RUN source ~/.bashrc && conda install -y r-base ipython -n base

# SCREENCAST WORKFLOW:
#
# tmux split-pane -h -l 100;  tmux split-pane -v -l 30
# cd dotfiles/docs/gifs/working
# docker run -v $PWD:/gifs --platform linux/amd64 --rm -it dotfiles
#
# - RECORD: asciinema rec demo.cast
# - MAKE GIF: AGG /gifs/demo.cast /gifs/demo.gif
# - EDIT: e.g. with Preview or ezgif
# - 
# - IMAGES:  mkdir imgs && convert -coalesce demo.gif imgs/%03d.gif
# Let docker run arguments replace the default shell without an extra bash -c.
CMD [ "/bin/bash", "-l" ]

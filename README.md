Starting with a fresh install of Ubuntu, CentOS, or macOS, with this repo I can
be up and running with everything I need plus all my configurations and plugins
in a couple of minutes.

Current options include (in approximate order in which they're typically run):

```

    --apt-get-installs    (installs a bunch of useful Ubuntu packages)
    --docker              (installs docker and adds current user to new docker group)
    --download-miniconda  (downloads latest Miniconda to current directory)
    --install-miniconda   (install downloaded Miniconda to ~/miniconda3)
    --set-up-bioconda     (add channels for bioconda in proper order)
    --conda-env           (install requirements.txt into root conda env)
    --download-neovim-appimage (download appimage instead of compiling)
    --download-macos-nvim (download binary nvim for MacOS)
    --powerline           (installs powerline fonts)
    --set-up-nvim-plugins (manually add vim-plug)
    --centos7-installs    (compilers; recent tmux)
    --install-fzf         (installs fzf)
    --install-ag          (installs ag)
    --install-autojump    (installs autojump)
    --diffs               (inspect differences between repo and home)
    --dotfiles            (update dotfiles)

```

Use `./setup.sh --diffs` to see differences between your dotfiles and what's in this repo.

Use `./setup.sh --dotfiles` to overwrite your dotfiles with these. You'll be
prompted to continue.

Note that this uses a modular system for bash configuration. `.bashrc` simply
sources `.bash_profile`, which in turn sources
other files:

- `.aliases` holds defined aliases
- `.functions` holds defined functions. `sa` is really nice if you work with
  conda envs and `tre` is great for quickly inspecting nested directory
  contents.
- `.path` is where all `export PATH=...` stuff goes. It is created by some of
  the above setup (e.g., the path to neovim is added here).
- `.bash_prompt` changes colors of the prompt depending on the host
- `.exports` is for setting env vars (though `.extras` may be more appropriate)
- `.extra` is not included in this repo but is where you can add additional
  config that is not appropriate for storing in a public repo

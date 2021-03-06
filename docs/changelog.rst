Changelog
=========

2021-07-14
----------

Lessons from setting up a new Mac...

- Instead of `.bashrc` sourcing `.bash_profile`, it is now flipped around to
  the more conventional (on Linux) `.bash_profile` sourcing `.bashrc`. This is
  also more convenient when running `conda init bash` which will add lines to
  `.bashrc`. Note that on Mac, `conda init bash` adds the lines to
  `.bash_profile.`

- Added some additional notes about configuring Macs (iTerm2 bell, disable zsh warning)

- Added some additional notes about post-setup (ssh keygen and copy-id)

- Added ncurses explicitly to the requirements-mac.txt. Without this, there was
  a dynamic library loading issue because ncurses falls back to defaults
  channel (not conda-forge). It's possible that using mamba would fix this.

- Removed dircolors from requirements-mac.txt which is apparently no longer available.

2021-06-01
----------

Installation
````````````
- modify requirements.txt: remove R, add conda-pack and mamba
- clean up miniconda.sh after installation
- improve commandline help in setup.sh
- remove installation of tig
- sort installed programs alphabetically (in setup and in docs)
- add installation of ``zoxide``

tmux
````
- don't specify shell in tmux
- don't set DISPLAY in tmux
- rm linux-specific tmux copy
- re-enable screen-256color in tmux conf

docs
````
- general cleanup

bash
````
- add ``gsv``, ``glv``, ``git-clean-branches``, and ``e`` aliases
- rm autojump setup from bash_profile


nvim 
````
- add ``set inccommand=nosplit``



2021-02-14
----------

nvim
````
- rm clipboard settings for nvim
- add vim-mergetool to init.vim and add docs
- add gv plugin and add docs
- docs on vim-fugitive
- add mapping to insert date (``,d``)
- rm the line exluding octal numbers from incrementing

tmux
````
- don't set screen-256color in tmux conf

Installation
````````````
- add notes for after installing miniconda
- solve issue with libz.so.1 conda.exe error:


2021-10-16
----------

Installation
````````````
- minor additions to dockerfile
- fix alacritty installation on linux and improve testing
- bump versions of installed tools
- support for alacritty on mac
- use conda activate rather than source activate
- add some missing user feedback
- support conda activate within script even if user hasn't run conda init yet
- support conda env list piped output for new conda versions
- update docs for aliases
- nicer command-line docs
- do not add alias when installing nvim; let aliases handle that
- let r-base version float to latest available

bash
````
- add alias for ..
- add vim=nvim only if nvim is found
- better handling of MacOS ls
- do not change prompt color on mac

2021-05-10
----------

Installation and docs
`````````````````````

- various docs and command-line help improvements
- add link for alacritty to docs
- update tmux table
- add ncurses
- add installation for pyp
- add docs for tig
- strip down README so it points to the generated docs


2021-04-26
----------

Installation
````````````

- install tig (instead of lazygit)
- explicitly use bash for installing hub
- install miniconda to /data directory if run on biowulf
- use HOME not ~
- support installation of ripgrep for mac

2021-04-06
----------

Installation and docs
`````````````````````
- update docs based on user feedback
- use OS-specific implementation of hash function
- add dircolors to mac requirements
- add sphinx docs
- specify full path to icdiff
- dockerfile improvements for testing
- streamline nvim installation on linux/mac
- add links to tools directly in setup.sh help
- install-nvim -> install-neovim
- only after installing nvim does the alias vim=nvim get created
- --install-icdiff, and use it for --diffs
- --dotfiles better behaved
- install meld in home dir on mac (still needs testing!)
- rm help for --install-ag (using rg now)
- unify installation of vim-plug to vim/nvim
- unified linux/mac conda env
- ensure destination dir exists before downloading
- unified nvim installer on linux/mac
- green hostname if on mac

bash
````
- rm the dircolors complaint in bash_profile
- fix detection of macos ls
- clean up some not-commonly-used aliases and functions

nvim
````
- fix brackets in PlugInstall
- add .vim and .vimrc
- assume vim-plug in vim and nvim

2021-03-31
----------

Installation and docs
`````````````````````
- rm note column
- now using ripgrep instead of ag
- move dotfiles clause
- add installations for mac and update help
- rm centos installs
- overhaul install table
- clarify conda env creation
- set SHELL to /bin/bash on Mac

2021-02-07
----------

Testing
```````
- Using docker for testing

Installation and docs
`````````````````````
- new tool installation: ``jq``
- clean up bat install
- install miniconda in one step
- lots of documentation work
- allow dotfiles copy to be forced
- use -y for apt minimal
- allow forcing of installs, useful for dockerfiles
- add apt minimal
- add command for apt-installs minimal
- change location of installed nvim
- install ripgrep on mac
- rm redundant ripgrep install

2019-12-16
----------

Installation and docs
`````````````````````

- update nvim appimage version
- add requirements for mac
- use printf for cross-platform colors
- install ripgrep

tmux
````
- ensure tmux windows start with bash on mac
- mac-specific ls

bash
````
- rm "z" as alias so that z.lua can use it
- export PS1 prevent conda from complaining

2019-09-30
----------

Installation and docs
`````````````````````
- install fd, vd, tabview, hub, bat, radian, black
- add --vim-diffs option
- add graphical diffs option
- install git-cola
- rm xresources
- add help text on copying in tmux
- more vim and tmux documentation
- refactor the installations
- function to remind sourcing of .aliases
- function to find conda installation location
- colored output
- change command to --install-docker
- add user prompts for every command
- add some helper functions
- move apt installs into separate file

bash
````
- change `la` alias
- use nvim for editing from vg()

nvim
````
- add vis.vim
- add more terminal & env activating cmds
- rm flake8 commands
- let alt-w move to other window in insert mode
- fix typo in clipboard
- add fenced code block shortcut
- add nerd-commenter plugin
- disable pep8; add more buffers; set clipboard

2019-03-27
----------

Installation
````````````
- add --force for alacritty build
- add alacritty and additional apt-get installs
- fix miniconda path
- add strict channel priority
- update requirements
- add git completion for mac

nvim
````
- get back out of insert mode when leaving terminal
- improve nvim terminal buffer switching
- add python folding plugin
- ensure code blocks can be folded
- clean up plugin descs
- settings to make pandoc plugin play nice
- add command for sending Rmd code chunk to neoterm
- explanation for additional <Leader>w
- tweaks to filetype listchars
- tweak listchars
- add vim-table-mode plugin

2019-02-27
----------

Installation and docs
`````````````````````
- move to next line after sending to terminal
- add config for python syntax
- rm neovim compilation commands and fasd installation

tmux
````
- add display alias for remote tmux

nvim
````
- add vim markdown syntax (with other required pandoc plugins)
- remap Esc for terminals
- overhaul init.vim
- rm old gvim sutff and fasd
- add commands for neoterm
- add vim-diff-enhanced and neoterm
- goodbye nvim-r

2018-11-28
----------

Installation and docs
`````````````````````
- add installation of fzf, ag, fasd, autojump
- improve ag installation
- rm ag tmp dir when done
- add help for new cmds
- use https for git; more flexible downloading
- fix channel order


2018-09-26
----------
Installation and docs
`````````````````````
- add apt-get and docker installation commands
- add pythonpy to reqs
- fix centos installs
- fix conda channel order
- add some mac bits
- use neovim appimage

nvim
````
- fix args for recent rmarkdown::render
- let nvim-R be installed via normal plugins
- add fugitive plugin
- clean up colors; adjust tab character colors

2017
----

Installation and docs
`````````````````````
- update dircolors
- new command for seeing what changed

bash
````
- add host-specific prompts
- add Xresources and solarized dark
- add dircolors for solarized
- disable colored section titles in manpages

nvim
````
- add nicer vim linewrapping
- add snakemake filetype
- vimwiki updates
- nvim-R updates
- update nvim-r config
- more vim plugins
- vim-cellmode and settings
- add more expandtab filetypes
- nvim-r config
- pep8 shortcut
- nvim plugins

tmux
````
- add setenv to tmux.conf
- tmux conf reorganize
- default unnamed clipboard
- add current dir to window create and split

2016
----
- add plugin for python indentation
- add requirements.txt
- exclude miniconda from rsync
- install nvim-r plugin; change option name
- disable insert mode highlight
- initial commit

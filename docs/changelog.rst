Changelog
=========

2024-09-05
----------
**setup.sh**

- Renamed ``--prep-clean-nvim`` argument to ``--nvim-test-drive``
- Add various error detection to this command and print warnings appropriately

**nvim**

Modularize configuration according to lazy.nvim recommendations. This splits
what was the ``lua/plugins.lua`` file into separate files for each plugin, and
splits what was ``init.lua`` into separate files for keymaps, autocommands, and
settings.

2024-09-01
----------
**setup.sh**

- new command ``--prep-clean-nvim``, which moves existing config and plugin
  directories to backup locations, so you can test these new changes. Also
  provides commands to roll back the process.
- new command ``--restore-nvim-plugins`` which copies just the lazy-lock.json
  file to your ~/.config/nvim/lazy-lock.json, and triggers a plugin
  restoration (without changing any other config).

**vim/nvim**
- update nvim version to 0.10.1
- add lazy-lock.json to repo to allow rollback when updated plugins break
- in diff views, show deleted lines with slashes rather than dashes
- treesitter: disable treesitter indentation for markdown (it seemed to be messing up bulleted lists)
- new plugin: obsidian.nvim for working with markdown and notes. See docs for new mappings.
- new plugin: render-markdown, for nice rendering of markdown elements
- updated :kbd:`<leader>cp` mapping to be more complete in turning off characters that shouldn't be copied
- beacon: pinned version of plugin
- which-key: pinned version of plugin
- bufferline: reverted to default style
- indent-blankline: exclude markdown and restructured text

**other**

Add ``colors.sh`` script for viewing color codes in terminal.


2024-04-30
----------

**vim/nvim**

- update nvim version to 0.9.5
- include ``vimdoc`` as a treesitter parser to install. Resolves
  ``treesitter/query.lua:219: query: invalid node type...`` error when viewing
  vim help


2024-04-27
----------

**vim/nvim**

- new plugin, *stickybuf.nvim*, which prevents buffers from opening inside a terminal window
- new plugin, *lsp-progress.nvim*, which add LSP status to the lualine at the bottom

2024-03-31
----------

**vim/nvim**

- new plugin, *conform.nvim*, for running formatter/stylers on buffer
- new plugin, *flash*, which replaces *leap* for searching in buffer
- include lsp setup for bash
- for jumping between diagnostics, use ``]d`` rather than ``]e``

2024-03-09
----------
**vim/nvim**

- pin toggleterm version; newer versions break when sending visual selections
- show full path of file in footer

**bash**

- update fzf version
- fix npm installation path

**docs**

- Add link to troubleshooting from Mac post-setup section

2023-01-21
----------

**bash**

Make ``ls`` more consistent on Mac.

Previously, there was sometimes inconsistent behavior depending on the state of
conda environments (see `#35 <https://github.com/daler/dotfiles/pull/35>`__ for
some details).

This change means that additional coloring of files by extension (like
compressed files and images) is not available on Mac. But directories,
executables, and symlinks will always be shown with color and using the
built-in ``/bin/ls``, so the end result will be more consistent behavior.

This also removes the ``git-clean-branches-main`` and
``git-clean-branches-master`` aliases, which could break in some circumstances.
In order to make it a bit safer to use, these have been replaced with
a ``git-clean-branches`` function that only prints the branches. If those look
good, then it can be run again, piping to ``xargs git branch -d``.

**setup.sh**

New argument, ``--mac-keyboard-fix``. This makes Home/End keys on an external,
non-Mac keyboard behave like they do on Windows and Linux. This makes the keys
jump to the beginning/end of a *line* rather than beginning/end of
a *document*. This is most noticeable in large text input boxes in a web
browser.

**vim/nvim**

New :kbd:`<leader>p` command for pasting the contents of the OS clipboard into
a formatted Markdown or ReST-formatted link, and place the cursor in insert
mode in the link description.

2023-12-31
----------

**setup.sh**

Changed the recommended order of events, and added a note to open vim to let it install plugins.

**docs**

Added troubleshooting notes for treesitter if there's no compiler available on the system

**vim/nvim**

Remove ReStructured Text treesitter parser and sphinx plugin, since they do not
yet support `ReST substitutions
<https://docutils.sourceforge.io/docs/ref/rst/directives.html#directives-for-substitution-definitions>`__.

2023-11-14
----------

**vim/nvim**

Tweaks for working with RMarkdown documents.

- Decided to remove the vim-pandoc family of plugins; it seems they were
  conflicting with treesitter highlighting. Treesitter is going a good job of
  it, and correctly allows :kbd:`gcc` commenting within R code chunks. Various
  filetypes set to use ``rmd`` rather than ``rmarkdown``.
- Renable lazy-load of nvim-tree, so that opening a directory works properly.
- :kbd:`gxx` to send lines to terminal now jumps to the bottom of the selection once sent.
- By default, treesitter's highlighting of markdown fenced code blocks (e.g.,
  RMarkdown chunks) makes everything italic. Disable this in
  :file:`.config/nvim/init.lua`.


2023-11-08
----------
- Turn off cursorline in a terminal buffer
- Fix inconsistent highlighting of rmarkdown documents (treesitter
  intermittently ignore the highlight ignore when setting up, so now we
  explicitly disable in an autocommand).

2023-11-07
----------

- Set up Dockerfile to create a screenshot-ready environment

**vim/nvim**

- Don't force the cursor to always be a block shape; add docs on how to get iTerm cursor looking nice
- Always highlight the current line (rather than only in insert mode). Keeping
  the previous lines in the config for future reference.
- Lazily-load nvim-tree and toggleterm plugins
- Allow treesitter to highlight markdown
- Disable the beacon globally (on every click); now only activates on searches
  or :kbd:`JK`.
- Use daler/vim-python-pep8-indent, a fork which includes snakemake as a filetype

**docs**

- Improvements to the docs based on recent feedback: iTerm cursor; zsh -> bash
  up front; patched terminal font; warning about bioconda ARM.

2023-11-01
----------

**vim/nvim**

- Initial config for LSP (Python, R, Lua). Lua autostarts; for Python use
  :kbd:`<leader>cl`. Use mason to install LSP servers. See :ref:`vim` for
  details.
- Use daler/zenburn.nvim fork for colorscheme; remove other zenburn colorscheme customizations
- Disable tree-sitter indentation for Python and Snakemake; use the pep8 python indentation plugin instead.
- Improve closing of buffers if they are not text buffers (aerial, nvim-tree, scratch from trouble.nvim)
- Reintroduce gv.vim
- Add trouble.nvim plugin
- Add more hints to descriptions of keybindings
- Instead of ``<leader>fbo`` and ``<leader>fbc`` to open and close the file
  browser, just use ``<leader>fb`` to toggle it.
- Replace vim-airline with lualine and bufferline
- New plugins:
  - nvim-lspconfig
  - mason.nvim
  - trouble.nvim
  - bufferline
  - lualine

- Removed plugins:
  - vim-airline

**setup.sh**

- Add ``--install-npm`` argument
- Specify MAMBA_LOCATION explicitly, because it seems like it can change
  depending on how mamba was originally installed.

2023-10-25
----------

**vim/nvim**

- Add better support for Snakemake filetype detection and syntax highlighting.

2023-10-23
----------
**vim/nvim; docs**

Update docs and nvim config fallback for Terminal.app users (which doesn't
support true color in the terminal, which in turn breaks many colorschemes in
nvim).

2023-10-11
----------

This finishes the progression of migrating to Lua-based vim config. See
:ref:`nvim-lua` for context, and the updated :ref:`vim` for plugin and
keymapping documentation for details.

**vim/nvim**

- new, barebones .vimrc
- remove .vim dir
- refactor init.vim to init.lua
- use lazy.nvim for plugin handling
- add plugins:

  - indent-blankline
  - beacon
  - nvim-cmp (and various dependencies)
  - telescope
  - treesitter
  - which-key
  - nvim-tree
  - accelerated_jk
  - aerial
  - gitsigns
  - diffview
- modularize config into multiple lua files
- convert mappings to have descriptions, so which-key picks them up
- change how buffers are switched
- removed plugins:

  - NERDTree (replaced by nvim-tree)
  - supertab (replaced by nvim-cmp)
  - simpylfold (replaced by treesitter folding)

2023-09-19
----------

**vim/nvim**

- make ``init.vim`` more condensed, and move plugin information over to HTML
  docs. This makes it less intimidating to look through the file and discover
  useful bits
- split out Lua-specific config code into :file:`.config/nvim/lua/plugin-config.lua`
- use ``set termguicolors`` to improve the zenburn colorscheme
- vim settings have comments on same line for more streamlined reading/discovery
- generalized comments to say <leader> instead of typing the overridden leader ","
- improved behavior when switching to a terminal in vim: when going to
  terminal, always enter insert mode. <leader>q and <leader>w work even in
  insert mode.
- detect ``*.smk`` as Snakemake files

**bash**

- split ``git-clean-branches`` into ``git-clean-branches-master`` and ``git-clean-branches-main``
- improve ``ca`` and ``conda_deactivate_all`` behavior (check conda is installed first; source the init in ``conda_deactivate_all``).
- only set ``alias vim=nvim`` if nvim exists
- new ``hostlist`` bash function for listing hosts in ssh config

**general**

- tests now run in the docker container using a new testing framework
- a few rounds of docs cleanup

**installation**

- fix Biowulf PATH for mambaforge installation (thanks @menoldmt)
- fix vim plugin installation to not use aliases (thanks @aliciaaevans)
- fix mambaforge complaining if tmpdir exists (thanks @aliciaaevans)


2023-07-06
----------

Updates to support new MacOS and arm64 architecture, and general improvements:

**bash**

- add ``ca``, ``conda_deactivate_all``, and automatic deactivation within tmux,
  as well as new documentation to describe the rationale and how to use

**installation**

- ``--install-miniconda`` is now ``--install-conda``, and uses Mambaforge
  instead of Miniconda3. This sets the conda-forge channel and includes mamba.
  This also now supports all architectures supported by Mambaforge
- various ``--install-pkgname`` commands use mamba to install rather than conda
- ``--set-up-vim-plugins`` now runs ``:PlugInstall`` automatically, and does so for both vim and nvim
- new command for post-installation stuff for mac (``--mac-stuff``)

**vim/nvim**

- nvim config now protects nvim-only configuration so that you don't get errors opening vim
- added recommended order of operations to the top of the help
- add alias for ``start_agent``
- new ``--install-tmux`` useful for Mac
- rm installation options for meld as well as the ``--graphical-diffs`` command
- improved ``start_agent`` function that works well on Mac
- add docs for mac ssh

2022-12-27
----------
Lots of updates to the neovim config, ``.config/nvim/init.vim``:

- The neoterm plugin is no longer actively developed; switched to using
  ToggleTerm and updated all shortcuts and commands
- Now ``,q`` from a terminal doesn't need <Esc> first, making switching back to
  the text buffer much nicer
- Major improvements in the comments in init.vim to make it easier to learn
  what does what, and to improve discoverability of features. This includes
  a brief description of oft-used commands provided by plugins as well as what
  to search the help for in order to learn more.
- Added the "leap" plugin.
- change ``,ry`` to ``,yr`` for better mnemonic of "YAML for R"

Other changes:

- in ``setup.sh``, add an option to compile neovim, in cases where the system's
  GLIBC is out of date (e.g. on older Linux systems) but you want to use the
  latest neovim version

- add ``.snakemake`` and ``env`` to the ignored patterns in the ``tre``
  function (found in the ``.functions`` file)

2022-09-14
----------

- conda setup now sets the recommended `strict channel priority <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html#strict-channel-priority>`_
- made some fixes to correctly run on recent Mac OS versions


2022-07-22
----------

- updated git repo for nerdtree and nerdcommenter plugins in ``init.vim`` (thanks @njohnso6)

2022-07-09
----------

- added new ``prsetup`` function for working on contributed pull requests

2022-05-27
----------

Changes to :file:`init.vim` (thanks @mitraak)

- add shortcut to add commonly-used YAML front matter to RMarkdown (``<leader>ry``, mnemonic is "RMarkdown YAML")
- add shortcut to add commonly-used ``knitr::opts`` option-setting chunk for
  RMarkdown (``<leader>ko``, mnemonic is "knitr options"
- add shortcut to change working directory of neoterm terminal to that of the
  buffer the command is called from (``<leader>tcd``, mnemonic is "terminal
  change directory")

2022-02-05
----------

Changes to :file:`init.vim`:

- Change ``<leader>d`` to insert a ReST-formatted date title
- ``<leader>-`` will fill the rest of the line with dashes (useful for making
  important comments stand out more)
- ``<leader>md`` to set hard-wrap at 80 columns. Mnemonic is "markdown" since
  this is especially useful when writing markdown. There is a corresponding
  ``<leader>nd`` ("no markdown") to turn that off.
- Set shiftwidth and tabstop to 2 spaces for R and RMarkdown, consistent with
  common R style guides
- The ``<leader>k`` command has been used for rendering RMarkdown; now if
  a file is detected as Python ``<leader>k`` will assume you're running IPython
  in the neoterm terminal and will call ``run <filename>``
- ``<leader><TAB>`` will fill out ``:set nowrap tabstop=`` and then leave the
  cursor at the vim command bar so you can fill in a reasonble tabstop for the
  file you're looking at.


2021-11-09
----------

Changed ``zoxide`` installation to use conda env.

2021-09-18
----------

Added installation of BFG for cleaning git repos

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

**installation**

- modify requirements.txt: remove R, add conda-pack and mamba
- clean up miniconda.sh after installation
- improve commandline help in setup.sh
- remove installation of tig
- sort installed programs alphabetically (in setup and in docs)
- add installation of ``zoxide``

**tmux**

- don't specify shell in tmux
- don't set DISPLAY in tmux
- rm linux-specific tmux copy
- re-enable screen-256color in tmux conf

**docs**

- general cleanup

**bash**

- add ``gsv``, ``glv``, ``git-clean-branches``, and ``e`` aliases
- rm autojump setup from bash_profile


**nvim**

- add ``set inccommand=nosplit``



2021-02-14
----------

**nvim**

- rm clipboard settings for nvim
- add vim-mergetool to init.vim and add docs
- add gv plugin and add docs
- docs on vim-fugitive
- add mapping to insert date (``,d``)
- rm the line exluding octal numbers from incrementing

**tmux**

- don't set screen-256color in tmux conf

**installation**

- add notes for after installing miniconda
- solve issue with libz.so.1 conda.exe error:


2021-10-16
----------

**installation**

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

**bash**

- add alias for ..
- add vim=nvim only if nvim is found
- better handling of MacOS ls
- do not change prompt color on mac

2021-05-10
----------

**Installation and docs**


- various docs and command-line help improvements
- add link for alacritty to docs
- update tmux table
- add ncurses
- add installation for pyp
- add docs for tig
- strip down README so it points to the generated docs


2021-04-26
----------

**Installation**


- install tig (instead of lazygit)
- explicitly use bash for installing hub
- install miniconda to /data directory if run on biowulf
- use HOME not ~
- support installation of ripgrep for mac

2021-04-06
----------

**Installation and docs**

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

**bash**

- rm the dircolors complaint in bash_profile
- fix detection of macos ls
- clean up some not-commonly-used aliases and functions

**nvim**

- fix brackets in PlugInstall
- add .vim and .vimrc
- assume vim-plug in vim and nvim

2021-03-31
----------

**Installation and docs**

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

**Testing**

- Using docker for testing

**Installation and docs**

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

**Installation and docs**


- update nvim appimage version
- add requirements for mac
- use printf for cross-platform colors
- install ripgrep

**tmux**

- ensure tmux windows start with bash on mac
- mac-specific ls

**bash**

- rm "z" as alias so that z.lua can use it
- export PS1 prevent conda from complaining

2019-09-30
----------

**Installation and docs**

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

**bash**

- change `la` alias
- use nvim for editing from vg()

**nvim**

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

**Installation**

- add --force for alacritty build
- add alacritty and additional apt-get installs
- fix miniconda path
- add strict channel priority
- update requirements
- add git completion for mac

**nvim**

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

**Installation and docs**

- move to next line after sending to terminal
- add config for python syntax
- rm neovim compilation commands and fasd installation

**tmux**

- add display alias for remote tmux

**nvim**

- add vim markdown syntax (with other required pandoc plugins)
- remap Esc for terminals
- overhaul init.vim
- rm old gvim sutff and fasd
- add commands for neoterm
- add vim-diff-enhanced and neoterm
- goodbye nvim-r

2018-11-28
----------

**Installation and docs**

- add installation of fzf, ag, fasd, autojump
- improve ag installation
- rm ag tmp dir when done
- add help for new cmds
- use https for git; more flexible downloading
- fix channel order


2018-09-26
----------
**Installation and docs**

- add apt-get and docker installation commands
- add pythonpy to reqs
- fix centos installs
- fix conda channel order
- add some mac bits
- use neovim appimage

**nvim**

- fix args for recent rmarkdown::render
- let nvim-R be installed via normal plugins
- add fugitive plugin
- clean up colors; adjust tab character colors

2017
----

**Installation and docs**

- update dircolors
- new command for seeing what changed

**bash**

- add host-specific prompts
- add Xresources and solarized dark
- add dircolors for solarized
- disable colored section titles in manpages

**nvim**

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

**tmux**

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

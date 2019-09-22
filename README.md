# Overview and rationale

Starting with a fresh install of Ubuntu, CentOS, or macOS, with this repo I can
be up and running with everything I need plus all my configurations and plugins
in a couple of minutes.

The end result is:

- neovim with all plugins installed (see below section on plugins), and
  powerline fonts to make it look nice
- all the useful packages and libraries I use
- full conda environment
- fzf, ag, autojump, fd, vd, tabview installed
- all my shortcuts

# `setup.sh`

`setup.sh` does all the work. Run it with no options to see the help. Search
for each option within the script to understand what each part does.

Current options include (in approximate order in which they're typically run):

| argument                     | description                                                                                                                                        |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| `--apt-get-installs`         | installs packages on Ubuntu (see `apt-installs.txt` for which packages)                                                                                    |
| `--docker`                   | installs docker on Ubuntu and adds current user to new docker group                                                                                |
| `--download-miniconda`       | downloads latest Miniconda to current directory                                                                                                    |
| `--install-miniconda`        | install downloaded Miniconda to ~/miniconda3                                                                                                       |
| `--set-up-bioconda`          | add channels for bioconda in proper order                                                                                                          |
| `--conda-env`                | install requirements.txt into root conda env                                                                                                       |
| `--download-neovim-appimage` | download appimage instead of compiling                                                                                                             |
| `--download-macos-nvim`      | download binary nvim for MacOS                                                                                                                     |
| `--powerline`                | installs powerline fonts, used for the vim airline plugin                                                                                          |
| `--set-up-nvim-plugins`      | download vim-plug for easy vim plugin installation                                                                                                 |
| `--centos7-installs`         | installs packages on CentOs (compilers; recent tmux)                                                                                               |
| `--install-fzf`              | installs [fzf](https://github.com/junegunn/fzf), command-line fuzzy finder                                                                         |
| `--install-ag`               | installs [ag](https://github.com/ggreer/the_silver_searcher), a fast code-searching tool                                                           |
| `--install-autojump`         | installs [autojump](https://github.com/wting/autojump), for quickly navigating multiple directories                                                |
| `--install-fd`               | installs [fd](https://github.com/sharkdp/fd), a simple, fast, and user-friendly alternative to "find" (see note 1)                                 |
| `--install-vd`               | installs [visidata](https://visidata.org), an interactive multitool for tabular data (see note 1)                                                  |
| `--install-tabview`          | installs [tabview](https://github.com/TabViewer/tabview), a command-line CSV and tabular data viewer (see note 1)                                  |
| `--install-black`          | installs [black](https://pypi.org/project/black/), "the uncompromising code formatter" for Python (see note 1)                                  |
| `--diffs`                    | show differences between repo and home directory                                                                                                   |
| `--dotfiles`                 | update dotfiles in home directory with files in this repo (you'll be prompted). Includes `.path`, `.alias`, `.bashrc`, `.config/nvim`, and others. |


**Note 1:** These tools are available in conda, so a standalone conda
environment is created for each tool, and an alias is added to the `.aliases`
file to point directly to just the installed binary file. That is,

```bash
conda create -n fd fd-find
echo "alias fd=$HOME/miniconda3/envs/bin/fd"
```

An environment will only be created if one of the same name does not already
exist.

# General workflow

## Round 1: basics, nvim, and dotfiles

The first round sets up packages, neovim, and neovim plugin support. The last
step of this round is to copy over all the dotfiles.

The steps depend on the system:

### Ubuntu with root

```
./setup.sh --apt-get-installs
./setup.sh --download-neovim-appimage
./setup.sh --powerline
./setup.sh --set-up-nvim-plugins
./setup.sh --diffs
./setup.sh --dotfiles
```

### CentOS 7 with root

```
./setup.sh --centos7-installs
./setup.sh --download-neovim-appimage
./setup.sh --powerline
./setup.sh --set-up-nvim-plugins
./setup.sh --diffs
./setup.sh --dotfiles
```

### MacOS

```
./setup.sh --download-macos-nvim
./setup.sh --powerline
./setup.sh --set-up-nvim-plugins
./setup.sh --diffs
./setup.sh --dotfiles
```

### Biowulf/Helix

```
./setup.sh --set-up-nvim-plugins
./setup.sh --diffs
./setup.sh --dotfiles
```

## Round 2: set font; install nvim plugins

In the terminal program you are using, change the font to match one of the
"Powerline" fonts that have been installed. This will make vim look nicer with
fancy glyphs in the header and footer.

Then exit and re-enter the system to load all the dotfiles.

- open `nvim` which is aliased to `vim` (see the `.aliases` section below)
- install plugins with the vim command `:PlugInstall`
- quit the plugin installer like a normal vim buffer (`:q`)
- exit vim (`:q`)

## Round 3: set up conda

The following commands will download and install miniconda to
`$HOME/miniconda3`, set up the conda-forge and bioconda channels in the proper
order, and build a default environment with useful tools.

```
./setup.py --download-miniconda
./setup.py --install-miniconda
./setup.py --set-up-bioconda
./setup.py --conda-env  # see requirements.txt for what is installed
```

## Round 3: extras

See the table above for what these tools are.

```
./setup.sh --install-fzf
./setup.sh --install-ag
./setup.sh --install-autojump
./setup.sh --install-fd
./setup.sh --install-vd
./setup.sh --install-tabview
./setup.sh --install-black
```

# Bash-related configuration

The organization for bash-related configuration is inspired by [this
repo](https://github.com/mathiasbynens/dotfiles).

`.bashrc` sources `.bash_profile`, which in turn sources the following files if
they're present. This keeps things a little more organized and modular.

| file           | description                                                                                       |
|----------------|---------------------------------------------------------------------------------------------------|
| `.aliases`     | define your bash aliases here                                                                     |
| `.functions`   | define your bash functions here                                                                   |
| `.path`        | set your `$PATH` entries here                                                                     |
| `.bash_prompt` | changes prompt colors depending on the host                                                       |
| `.exports`     | global exports that can be stored in a public repository                                                                |
| `.extra`       | put anything here that's either not appropriate to store in a repo, or for host-specific settings |

## `.aliases`

Some notable aliases:

| alias | command                  | description                                                                                                                                    |
|-------|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `vim` | `nvim`                   | always use neovim                                                                                                                              |
| `D`   | `export DISPLAY=:0`      | sometimes when using tmux the display is not set, causing GUI programs launched from the terminal to complain. This sets the display variable. |
| `ll`  | `ls -lrth --color=auto`  | useful `ls` arguments (long format, human-readable sizes, sorted by time (latest at bottom), use color)                                        |
| `la`  | `ls -lrthA --color=auto` | same as above, but also show hidden files                                                                                                      |

## `.functions`

Some notable functions:

| function      | description                                                                                                                                                                       |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `start_agent` | Use this to start the ssh agent so you don't need to keep entering your ssh key during a session                                                                                  |
| `tre`         | Nicer `tree` output, colored and piped to less                                                                                                                                    |
| `sa`          | Opens `fzf` to search across all conda environments, and activates the selected one                                                                                               |
| `vg`          | Use `ag` to search for the provided text within the current directory, and send to `fzf` for fuzzy-finding. When you choose a line, open that file with vim and jump to that line |


# Neovim configuration

In the [.config/nvim/init.vim](.config/nvim/init.vim) file in this repo:

- `<Leader>` is set to `,`.
- `<Localleader>` is set to `/`

In the terminal itself, go to Preferences, select the "Custom Font" checkbox,
and choose a font filtered with "Powerline" so it will be Powerline compatible.

## General setup

Here are the features (and fixes) you get when using this config file:

- lots of nice plugins (see below)
- syntax highlighting and proper Python formatting
- in some situations backspace does not work, this fixes it
- can use mouse to click around
- current line has a subtle coloring when in insert mode
- TAB characters are rendered as `>...` which helps troubleshoot spaces vs tabs. This is disabled for files like HTML and XML where 
- Trailing spaces are rendered as faded dots
- Comments, numbered lists can be auto-wrapped after selecting and `gq`
- In insert mode editing a comment, hitting enter will automatically add the
  comment character to the beginning of the next line
- Search highlighting is turned off, but toggle it with `<Leader>H`
- Searches will be case-sensitive only if at least letter is a capital
- `<Leader>W` will clean up all trailing spaces
- `<Leader>R` will refresh syntax highlighting
- `@l` macro will surround the line with quotes and add a trailing comma,
  making it easy to make Python lists out of pasted text.
- When a file is opened, automatically set the working directory to that of the opened file
- Switch between open buffers (listed along the top sort of like tabs in
  a browser) with `<Leader>` and a number from 1-9, corresponding to up to
  9 open buffers. E.g., `<Leader>3` switches to the 3rd buffer
- set the tabstop to 2 for YAML format files
- consider Snakefiles (`Snakefile` or `*.snakefile`) as Python syntax
- `<Leader>r` toggle relative line numbering (makes it easier to jump around
  lines with motion operators)
- In Python, space errors (primarily trailing spaces) are highlighted


## Plugins

These plugins have lots and lots of options. Here I'm only highlighting the
options I use the most, but definitely check out each homepage to see all the
other weird and wonderful ways they can be used.

### [`scrooloose/nerdcommenter`](https://github.com/scrooloose/nerdcommenter)

| command | description                       |
|---------|-----------------------------------|
| `<leader>cc`   | Comment current or selected lines |


### [`scrooloose/nerdtree`](https://github.com/scrooloose/nerdtree)

| command | description             |
|---------|-------------------------|
| `<leader>n`    | Open a new file browser |

### [`vim-airline/vim-airline`](https://github.com/vim-airline/vim-airline) and [`vim-airline/vim-airline-themes`](https://github.com/vim-airline/vim-airline/wiki/Screenshots)

Nice statusline. Install powerline fonts for full effect (with `./setup.py
--powerline-fonts` using the setup script in this repository)


### [`roxma/vim-tmux-clipboard`, `tmux-plugins/vim-tmux-focus-events`](https://github.com/roxma/vim-tmux-clipboard)

Copy yanked text from vim into tmux's clipboard and vice versa. The
focus-events plugin is also needed for this to work.

### [`nvie/vim-flake8`](https://github.com/nvie/vim-flake8)

You'll need to `pip install flake8` for this to work.
[Flake8](http://flake8.pycqa.org/en/latest/) checks your Python code against
the [PEP8 Python Style Guide](https://www.python.org/dev/peps/pep-0008/). After
it runs, you'll get a quick-fix window. In that window, hitting Enter on a line
will jump to that place in the Python buffer so you can fix it.

| command     | description                                  |
|-------------|----------------------------------------------|
| `<leader>8` | Run flake8 on the file in the current buffer |


### [`vim-python/python-syntax`](https://github.com/vim-python/python-syntax)

Sophisticated python syntax highlighting, for example within format strings.
Happens automatically when editing Python files.

### [`Vimjas/vim-python-pep8-indent`](https://github.com/Vimjas/vim-python-pep8-indent)

Auto-indent Python using pep8 recommendations. This happens as you're typing,
or when you use `gq` on a selection.

### [`ervandew/supertab`](https://github.com/ervandew/supertab)

Autocomplete most things with `TAB` in insert mode.

### [`tpope/vim-fugitive`](https://github.com/tpope/vim-fugitive)

Run git from vim.

I mostly use it for making incremental commits from within vim. This makes it
a terminal-only version of [git-cola](https://git-cola.github.io). Specifically:

| command    | description                                                                                                                  |
|------------|------------------------------------------------------------------------------------------------------------------------------|
| `:Gdiff`   | Split the current buffer, showing the current version on one side and the last-committed version in the other side           |
| `:Gcommit` | After saving the buffer, commit to git (without having to jump back out to terminal) `:Gcommit -m "commit notes" works, too. |

The following commands are built-in vim commands when in diff mode, but are used heavily when working with `:Gdiff`:

| command | description                                            |
|---------|--------------------------------------------------------|
| `]c`    | Go to the next diff.                                   |
| `[c`    | Go to the previous diff                                |
| `do`    | Use the **o**ther file's contents for the current diff |
| `dp`    | **p**ut the contents of this diff into the other file  |

### [`chrisbra/vim-diff-enhanced`](https://github.com/chrisbra/vim-diff-enhanced)

Provides additional diff algorithms that work better on certain kinds of files.

| command                     | description                                          |
|-----------------------------|------------------------------------------------------|
| `:EnhancedDiff <algorithm>` | Configure the diff algorithm to use, see below table |

The following algorithms are available:

| Algorithm | Description                                                                |
|-----------|----------------------------------------------------------------------------|
| myers     | Default diff algorithm                                                     |
| default   | Alias for myers                                                            |
| minimal   | Like myers, but tries harder to minimize the resulting diff                |
| patience  | Use the patience diff algorithm                                            |
| histogram | Use the histogram diff algorithm (similar to patience but slightly faster) |

### [`kassio/neoterm`](https://github.com/kassio/neoterm)

Provides a separate terminal in vim.

The following commands are custom mappings set in
[.config/nvim/init.vim](.config/nvim/init.vim):

| command     | description                                                                         |
|-------------|-------------------------------------------------------------------------------------|
| `<leader>t` | Open a terminal to the right                                                        |
| `gx`        | Send the current selection to the terminal                                          |
| `gxx`       | Send the current line to the terminal                                               |
| `,cd`       | Send the current RMarkdown chunk to the terminal (which is assumed to be running R) |

### [`vim-pandoc/vim-rmarkdown`](https://github.com/vim-pandoc/vim-rmarkdown)

Syntax highlight R within RMarkdown code chunks. Requires both `vim-pandoc` and
`vim-pandoc-syntax`, described below.


### [`vim-pandoc/vim-pandoc`](https://github.com/vim-pandoc/vim-pandoc) and [`vim-pandoc/vim-pandoc-syntax`](https://github.com/vim-pandoc/vim-pandoc-syntax)

Integration with pandoc, including folding and formatting. Lots of shortcuts
defined, see
[this section of the
help](https://github.com/vim-pandoc/vim-pandoc/blob/master/doc/pandoc.txt#L390) for more.


| command | description                                                                              |
|---------|------------------------------------------------------------------------------------------|
| `:TOC`  | Open a table contents for the current document that you can use to navigate the document |


### [`dhruvasagar/vim-table-mode`](https://github.com/vim-pandoc/vim-pandoc-syntax)

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.

| command             | description                                               |
|---------------------|-----------------------------------------------------------|
| `:TableModeEnable`  | enables table mode                                        |
| `:TableModeDisable` | disables table mode                                       |
| `:Tableize          | creates a markdown or ReST table based on TSV or CSV text |

See the homepage for, e.g., using `||` to auto-create header lines.

### [`tmhedberg/SimpylFold`](https://github.com/tmhedberg/SimpylFold)

Nice folding for Python, using built-in vim commands for folding like `zc`,
`zn`, `zM`.

# Overview and rationale

This repo captures hard-won settings and tool installations that I have
accumulated over time. Using the included modular setup script, starting from
a fresh installation of Ubuntu Linux or MacOS I can have everything I'm used to
-- programs and all -- in a few minutes.

It doubles as a "batteries included" set of configuration files that can be used
by others just starting out. It includes:

- bash config
- tmux config
- vim/neovim config
- various tool installation commands

If you don't want "batteries included", you can select only what is most useful
to you because:

- the `setup.sh` script is modular
- this README documents everything
- the config files themselves are documented

# `setup.sh`

`setup.sh` is the driver script for everything. Run it with no options to see
the help. Search for each option within the script to understand what each part
does.

The table below summarizes the options.

Some are for Linux, some are for Mac, and some are OK to do on a remote server
where you do not have root privileges. Run `./setup.sh` with no argument to see
info on this.

| argument                    | description                                                                                                                                        |
|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| `--diffs`                   | show differences between repo and home directory                                                                                                   |
| `--graphical-diffs`         | show differences between repo and home directory, using meld                                                                                       |
| `--vim-diffs`               | show differences between repo and home directory, using `vim -d`                                                                                   |
| `--dotfiles`                | update dotfiles in home directory with files in this repo (you'll be prompted). Includes `.path`, `.alias`, `.bashrc`, `.config/nvim`, and others. |
| `--apt-get-installs`        | installs packages on Ubuntu (see [`apt-installs.txt`](apt-installs.txt) for which packages)                                                        |
| `--apt-get-install-minimal` | installs a smaller set of packages on Ubuntu (see [`apt-installs-minimal.txt`](apt-installs-minimal.txt) for the list)                             |
| `--install-neovim`          | download appimage instead of compiling                                                                                                             |
| `--powerline`               | installs powerline fonts, used for the vim airline plugin                                                                                          |
| `--set-up-vim-plugins`      | download vim-plug for easy vim plugin installation                                                                                                 |
| `--install-miniconda`       | install downloaded Miniconda to ~/miniconda3                                                                                                       |
| `--set-up-bioconda`         | add channels for bioconda in proper order                                                                                                          |
| `--conda-env`               | install requirements.txt into root conda env                                                                                                       |
| `--install-meld`            | installs [`meld`](https://meldmerge.org/), a graphical merge tool                                                                                  |
| `--install-fzf`             | installs [`fzf`](https://github.com/junegunn/fzf), command-line fuzzy finder                                                                       |
| `--install-ripgrep`         | installs [`ripgrep`](https://github.com/BurntSushi/ripgrep), a fast code-searching tool with slightly different features from ag                   |
| `--install-autojump`        | installs [`autojump`](https://github.com/wting/autojump), for quickly navigating multiple directories                                              |
| `--install-fd`              | installs [`fd`](https://github.com/sharkdp/fd), a simple, fast, and user-friendly alternative to "find" **(see note 1)**                           |
| `--install-vd`              | installs [`visidata`](https://visidata.org), an interactive multitool for tabular data **(see note 1)**                                            |
| `--install-black`           | installs [`black`](https://pypi.org/project/black/), "the uncompromising code formatter" for Python **(see note 1)**                               |
| `--install-radian`          | installs [`radian`](https://github.com/randy3k/radian), "a 21st century R console" **(see note 1)**                                                |
| `--install-git-cola`        | installs [`git-cola`](https://git-cola.github.io), a graphical interface for adding incremental git commits  **(see note 1)**                      |
| `--install-bat`             | installs [`bat`](https://github.com/sharkdp/bat), which is like `cat` but with syntax highlighting, non-printing chars, and git diffs              |
| `--install-hub`             | installs [`hub`](https://github.com/github/hub), for more easily working with pull requests                                                        |
| `--install-jq`              | installs [`jq`](https://stedolan.github.io/jq/), a command-line tool for operating on JSON                                                         |
| `--install-docker`          | installs docker on Ubuntu and adds current user to new docker group                                                                                |
| `--install-alacritty`       | installs [`alacritty`](https://github.com/jwilm/alacritty), a GPU-accelerated terminal emulator


**Note 1:** These tools are either available in conda, or have Python
dependencies. For each tool, a standalone conda environment is created, the
tool is installed into that environment, and a symlink is added to `~/opt/bin`.


# Usage

The bash config files are modular. They work like this:

```
.bashrc # sources .bash_profile
   --> .bash_profile  # sources the following files
         --> .path         # all "export PATH=..." goes in here
         --> .aliases      # add your aliases here
         --> .functions    # add your functions here
         --> .exports      # add your various exports here
         --> .bash_prompt  # edit your bash prompt here
         --> .extra        # any machine-specific config goes here
```

## Round 1: basics, nvim and dotfiles

The particular steps depend on the system, and whether you have root access.

**All steps are optional**, though there are some dependencies. For example,
setting up bioconda assumes that you've already installed conda somehow. And
many of the `--install-<toolname>` commands expect a conda installation.


### Ubuntu with root


#. `./setup.sh --install-icdiff`. This installs `icdiff` which shows colored,
   side-by-side, easy-to-read diffs. It's useful for the next step.

#. `./setup.sh --diffs`. This shows the diffs between this repo and your
   existing dotfiles in your home directory.

#. **Decision point!** Depending on your situation, you may want to use all the
   dotfiles here (which are documented below). Or you may want to go
   through the dotfiles here to manually copy/paste into your dotfiles.

   - **To use everything here**, run `./setup.sh --dotfiles`.

   - **If manually copying**, be aware that subsequent commands expect that you
     have the directories `$HOME/miniconda3/bin` and `$HOME/opt/bin` on your
     path. So you can add the following line to your `.bashrc` or
     `.bash_profile`: `export PATH="$HOME/miniconda3/bin:$HOME/opt/bin:$PATH`

#. Install [neovim](https://neovim.io/), if you want to use it. See the "why"
   section below.

    - On Linux: `./setup.sh --download-neovim-appimage`. This installs the
      AppImage to `~/opt/bin`.

    - On Mac: `./setup.sh --download-macos-nvim`. This downloads a pre-compiled
      version for Mac.

#. Prepare for vim plugins. `./setup.sh --set-up-nvim-plugins` installs
   [vim-plug](https://github.com/junegunn/vim-plug) into the proper location
   for vim as well as nvim.

   - When done, open vim and/or nvim and run `:PlugInstall` to install all
     configured plugins in `.vimrc` or `.config/nvim/init.vim`.

#. Install powerline fonts for the fancy glyphs used by the
   [vim-airline](https://github.com/vim-airline/vim-airline) plugin.
   `./setup.sh --install-powerline`. This only needs to be done on the machine
   you're running the terminal app on. So this does not need to be run on
   a remote machine. **Note:** you'll need to configure your terminal to use
   one of the new fonts that ends in "for Powerline".

#. The following steps set up conda.

   - `./setup.sh --install-miniconda` downloads and installs Miniconda to
     `~/miniconda3`.
   - `./setup.sh --set-up-bioconda` sets up channels in the proper order for
     bioconda
   - `./setup.sh --conda-env` installs packages from
     [`requirements.txt`](requirements.txt) and, if on Mac,
     [`requirements-mac.txt`](requirements-mac.txt).

#. (Only on Linux with root privileges) Install apt packages. `./setup.sh --apt-get-installs` or
   `./setup.sh --apt-get-install-minimal`. These commands install packages from
   [`apt-installs.txt`](apt-installs.txt) or
   [`apt-installs-minimal.txt`](apt-installs-minimal.txt). Take a look at those
   files to see what you prefer (or edit as needed).

#. Install various other tools (see below)


# Additional tool installations

Run the ``--install-<toolname>`` for each of the tools below. Each is installed
(or symlinked) into `~/opt/bin`, so you'll want to make sure that's on your
path.

### `icdiff`

[icdiff](https://www.jefftk.com/icdiff) makes an easy-to-read, side-by-side
colored diff between files. It's used for `./setup.sh --diffs`. Install with
`./setup.sh --install-icdiff`.

### `fzf`

[fzf](https://github.com/junegunn/fzf) is a fuzzy-finder interface that works
with stdin. It integrates with bash so that when you use `Ctrl-R` (the standard
bash way of reverse-search through history), you'll instead get the fzf
interface. Install with `./setup.sh --install-fzf`.

### `ripgrep` (`rg`)

[ripgrep](https://github.com/BurntSushi/ripgrep/) is a fast code-searching
tool. It is like grep, but by default skips files in .gitignore, binary files,
and hidden files. Install with `./setup.sh --install-ripgrep`.

### `fd`

[fd](https://github.com/sharkdp/fd) is a much faster and more ergonomic `find`.
Install with `./setup.sh --install-fd`.

### `visidata` (`vd`)

[visidata](https://visidata.org/) ia a powerful spreadsheet-like tool for
viewing, sorting, searching, and manipulating data directly in the terminal.
Any files that pandas can open, visidata can open too. Install with `./setup.sh
--install-vd`.

### `black`

[black](https://black.readthedocs.io) reformats Python files to conform to PEP8
style conventions. Install with `./setup.sh --install-black`.

### `radian`

[radian]((https://github.com/randy3k/radian) is a replacement shell for R. It
has syntax highlighting, multiline editings, and tab completion built in. Can
be used with any version of R, in a conda environment or otherwise. Install
with `./setup.sh --install-radian`.

### `git-cola`

[git-cola](https://git-cola.github.io/) is a graphical tool for incrementally
making git commits. Very useful, for example, at the end of a coding session
and you want to make atomic commits from all the changes you made. Install with
`./setup.sh --install-git-cola`.

### `bat`

[bat](https://github.com/sharkdp/bat) is a replacement for `cat`, with syntax
highlighting, line numbers, non-printable characters, and git diffs. Install
with `./setup.sh --install-bat`.

### `alacritty`

[alacritty](https://github.com/alacritty/alacritty) is a cross-platform
GPU-accelerated terminal emulator. The speed is most noticable when catting
large files over tmux. Install with `./setup.sh --install-alacritty`.

### `jq`

[jq](https://stedolan.github.io/jq/) is like sed or awk for JSON data. Install
with `./setup.sh --install-jq`.

### `docker`

[docker](https://www.docker.com) runs containers. Needs root access, and the
installation here is currently only supported on Linux. Install with
`./setup.sh --install-docker`.


# Bash dotfiles

The modular organization for bash configuration is inspired by [this
repo](https://github.com/mathiasbynens/dotfiles). 

`.bashrc` sources `.bash_profile`, which in turn sources the following files if
they're present. This keeps things a little more organized and modular:

| file           | description                                                                                       |
|----------------|---------------------------------------------------------------------------------------------------|
| `.path`        | set your `$PATH` entries here                                                                     |
| `.aliases`     | define your bash aliases here                                                                     |
| `.functions`   | define your bash functions here                                                                   |
| `.bash_prompt` | changes prompt colors depending on the host                                                       |
| `.exports`     | global exports that can be stored in a public repository                                          |
| `.extra`       | put anything here that's either not appropriate to store in a repo, or for host-specific settings |

Below is a little more detail on the contents of each of these files and some notable features.

## `.path`

This file ends up being lots of `export PATH="$PATH:/some/other/path"` lines.
It is initially populated to put `~/opt/bin` and `~/miniconda3/bin` on the
path. As you install more software in other locations, this is a tidy place to
put the various exports.

## `.aliases`

This file keeps aliases separate. Some notable aliases that are included:

| alias | command                  | description                                                                                                                                    |
|-------|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `vim` | `nvim`                   | always use neovim                                                                                                                              |
| `D`   | `export DISPLAY=:0`      | sometimes when using tmux the display is not set, causing GUI programs launched from the terminal to complain. This sets the display variable. |
| `ll`  | `ls -lrth --color=auto`  | useful `ls` arguments (long format, human-readable sizes, sorted by time (latest at bottom), use color)                                        |
| `la`  | `ls -lrthA --color=auto` | same as above, but also show hidden files                                                                                                      |
| `v`   | (see .aliases file)      | Live, searchable, syntax-highlighted preview of files in a directory. Needs `--install-fzf` and `--install-bat`.                               |
| `fv`  | (see .aliases file)      | Same as above, but after hitting enter the file will be opened in vim                                                                          |


## `.functions`

Separate file for bash functions. This is also where fzf and autojump are set
up. Some notable functions defined here:

| function      | description                                                                                                                                                                       |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `start_agent` | Use this to start the ssh agent so you don't need to keep entering your ssh key during a session                                                                                  |
| `tre`         | Nicer `tree` output, colored and piped to less                                                                                                                                    |
| `sa`          | Opens `fzf` to search across all conda environments, and activates the selected one                                                                                               |


## `.bash_prompt`

This file changes the prompt color for Biowulf or Helix (NIH HPC), but here you
can add any other hosts or colors. See
https://misc.flogisoft.com/bash/tip_colors_and_formatting for color options.

# Vim / Neovim

`.vimrc` and `.config/nvim/init.vim` have the same contents.

In the [.config/nvim/init.vim](.config/nvim/init.vim) file in this repo:

- `<Leader>` is set to `,`.
- `<Localleader>` is set to `/`

**Setting up powerline fonts:** After running `./setup.sh --powerline`, which
will install the fonts, you need to tell the terminal to use those fonts. In
the terminal itself, go to Preferences, select the "Custom Font" checkbox, and
choose a font that ends with "Powerline".

## General features

Here are the features (and fixes) you get when using this config file. Note
that the file itself is pretty heavily commented so you can pick-and-choose at
will.

- Lots of nice plugins (see below)
- Syntax highlighting and proper Python formatting
- In some situations backspace does not work, this fixes it
- Use mouse to click around
- Current line has a subtle coloring when in insert mode
- Hitting the TAB key enters spaces, not a literal tab character. Important for
  writing Python!
- TAB characters are rendered as `>...` which helps troubleshoot spaces vs
  tabs. This is disabled for files like HTML and XML where tabs vs whitespace
  is not important
- Set the tabstop to 2 for YAML format files
- Trailing spaces are rendered as faded dots
- Comments, numbered lists can be auto-wrapped after selecting and using `gq`
- In insert mode while editing a comment, hitting enter will automatically add
  the comment character to the beginning of the next line
- Searches will be case-sensitive only if at least letter is a capital
- Plugins for working more easily within tmux

## Shortcuts

Here are the shortcuts defined. Note that many of these (the ones talking about
a terminal) expect Neovim and the neoterm plugin.

| command       | works in mode    | description                                                                                                                                  |
|---------------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `,`           |                  | Remapped leader. When you see `<leader>` below, it means `,`. E.g., `<leader>3` means `,3`                                                   |
| `<leader>r`   | normal           | Toggle relative line numbering (makes it easier to jump around lines with motion operators)                                                  |
| `<leader>H`   | normal           | Toggle higlighted search                                                                                                                     |
| `<leader>\``  | normal or insert | When editing RMarkdown, creates a new code chunk and enters it, ready to type                                                                |
| `<leader>W`   | normal           | clean up all trailing spaces                                                                                                                 |
| `<leader>R`   | normal or insert | refresh syntax highlighting                                                                                                                  |
| `@l`          | normal           | macro to surround the line with quotes and add a trailing comma, making it easy to make Python or R lists out of pasted text                 |
| `<leader>t`   | normal           | Open neoterm terminal to the right.                                                                                                          |
| `<leader>te`  | normal           | Open neoterm terminal to the right, and immediatly activate the conda environment in the `./env` directory                                   |
| `<leader>t1e` | normal           | Same as above, but 1 dir above in  `../env`                                                                                                  |
| `<leader>t2e` | normal           | Same as above, but 2 dir above in  `../../env`                                                                                               |
| `<leader>t3e` | normal           | Same as above, but 2 dir above in  `../../../env`                                                                                            |
| `Alt-w`       | normal or insert | Move to terminal on right and enter insert mode                                                                                              |
| `<leader>w`   | normal           | Same as above, but normal mode only                                                                                                          |
| `Alt-q`       | normal or insert | Move to buffer on left and enter normal mode                                                                                                 |
| `<leader>q`   | normal           | Same as above, but normal mode only                                                                                                          |
| `<leader>cd`  | normal           | Send the current RMarkdown code chunk to the neoterm buffer, and jump to the next chunk                                                      |
| `gxx`         | normal           | Send the current line to the neoterm buffer                                                                                                  |
| `gx`          | visual           | Send the selection to the neoterm buffer                                                                                                     |
| `<leader>k`   | normal           | Render the current RMarkdown file to HTML using `knitr::render()`. Assumes you have knitr installed and you're running R in a neoterm buffer |

## Plugins

The plugins configured at the top of `.config/nvim/init.vim` have lots and lots
of options. Here I'm only highlighting the options I use the most, but
definitely check out each homepage to see all the other weird and wonderful
ways they can be used.

| Plugin                                                                                            | Description                                                              |
|---------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `neoterm` [[section]](#neoterm) [[repo]](https://github.com/kassio/neoterm)                       | Provides a separate terminal in vim                                      |
| `supertab`[[section]](#supertab) [[repo]](https://github.com/ervandew/supertab)                   | Autocomplete most things by hitting <TAB>                                |
| `python-syntax` [[section]](#python-syntax) [[repo]](https://github.com/vim-python/python-syntax) | Sophisticated python syntax highlighting.                                |
| `Vimjas/vim-python-pep8-indent`                                                                   | Indent python using pep8 recommendations                                 |
| `vim-pandoc/vim-rmarkdown`                                                                        | Nice RMarkdown syntax highlighting                                       |
| `vim-pandoc/vim-pandoc`                                                                           | Required for vim-rmarkdown                                               |
| `vim-pandoc/vim-pandoc-syntax`                                                                    | Required for vim-rmarkdown, lots of other nice syntax highlighting, too  |
| `dhruvasagar/vim-table-mode`                                                                      | Easily create Markdown or ReST tables                                    |
| `tmhedberg/SimpylFold`                                                                            | Nice folding for Python                                                  |
| `vim-scripts/vis`                                                                                 | Operations in visual block mode respect selection                        |
| `scrooloose/nerdcommenter`                                                                        | Comment large blocks of text                                             |
| `scrooloose/nerdtree`                                                                             | File browser for vim                                                     |
| `roxma/vim-tmux-clipboard`                                                                        | Copy yanked text from vim into tmux's clipboard and vice versa.          |
| `tmux-plugins/vim-tmux-focus-events`                                                              | Makes tmux and vim play nicer together.                                  |
| `tpope/vim-fugitive`                                                                              | Run git from vim                                                         |
| `tpope/vim-surround`                                                                              | Quickly change surrounding characters                                    |
| `vim-airline/vim-airline`                                                                         | Nice statusline. Install powerline fonts for full effect.                |
| `vim-airline/vim-airline-themes`                                                                  | Themes for the statusline                                                |
| `chrisbra/vim-diff-enhanced`                                                                      | Provides additional diff algorithms                                      |
| `flazz/vim-colorschemes`                                                                          | Pile 'o colorschemes                                                     |
| `felixhummel/setcolors.vim`                                                                       | `:SetColors all` and then use F8 to change colorscheme                   |
| `jremmen/vim-ripgrep`                                                                             | Search current directory for lines in files containing word under cursor |
| `singularityware/singularity.lang`                                                                | Syntax highlighting for Singularity                                      |


#### [`kassio/neoterm`](https://github.com/kassio/neoterm)

Provides a separate terminal in vim. That way you can send text between that
terminal and a file you have open. As described in the "Using R with nvim"
section, this lets you reproduce an RStudio-like environment purely from the
terminal.

The following commands are custom mappings set in
[.config/nvim/init.vim](.config/nvim/init.vim) that affect the terminal use:

| command      | description                                                                         |
|--------------|-------------------------------------------------------------------------------------|
| `<leader>t`  | Open a terminal in a new window to the right                                        |
| `gx`         | Send the current selection to the terminal                                          |
| `gxx`        | Send the current line to the terminal                                               |
| `<leader>cd` | Send the current RMarkdown chunk to the terminal (which is assumed to be running R) |

#### [`ervandew/supertab`](https://github.com/ervandew/supertab)

Autocomplete most things with `TAB` in insert mode.

#### [`vim-python/python-syntax`](https://github.com/vim-python/python-syntax)

Sophisticated python syntax highlighting, for example within format strings.
Happens automatically when editing Python files.

#### [`Vimjas/vim-python-pep8-indent`](https://github.com/Vimjas/vim-python-pep8-indent)

Auto-indent Python using pep8 recommendations. This happens as you're typing,
or when you use `gq` on a selection.

#### [`vim-pandoc/vim-rmarkdown`](https://github.com/vim-pandoc/vim-rmarkdown)

Syntax highlight R within RMarkdown code chunks. Requires both `vim-pandoc` and
`vim-pandoc-syntax`, described below.


#### [`vim-pandoc/vim-pandoc`](https://github.com/vim-pandoc/vim-pandoc) and [`vim-pandoc/vim-pandoc-syntax`](https://github.com/vim-pandoc/vim-pandoc-syntax)

Integration with pandoc, including folding and formatting. Lots of shortcuts
defined, see
[this section of the
help](https://github.com/vim-pandoc/vim-pandoc/blob/master/doc/pandoc.txt#L390) for more.


| command | description                                                                              |
|---------|------------------------------------------------------------------------------------------|
| `:TOC`  | Open a table contents for the current document that you can use to navigate the document |


#### [`vis`](vim-scripts/vis)

When selecting things in visual block mode, by default operations
(substitutions, sorting) operate on the entire line, not just the block.

| command                                       | description            |
|-----------------------------------------------|------------------------|
| Ctrl-v, then select, then `:B` instead of `:` | Operates on block only |

#### [`scrooloose/nerdcommenter`](https://github.com/scrooloose/nerdcommenter)

Easily comment blocks of text

| command      | description                       |
|--------------|-----------------------------------|
| `<leader>cc` | Comment current or selected lines |


#### [`scrooloose/nerdtree`](https://github.com/scrooloose/nerdtree)

Open up a file browser, navigate it with vim movement keys, and hit `Enter` to
open the file in a new buffer.

| command     | description         |
|-------------|---------------------|
| `<leader>n` | Toggle file browser |

#### [`vim-airline/vim-airline`](https://github.com/vim-airline/vim-airline) and [`vim-airline/vim-airline-themes`](https://github.com/vim-airline/vim-airline/wiki/Screenshots)

Nice statusline. Install powerline fonts for full effect (with `./setup.py
--powerline-fonts` using the setup script in this repository)

#### [`roxma/vim-tmux-clipboard`, `tmux-plugins/vim-tmux-focus-events`](https://github.com/roxma/vim-tmux-clipboard)

Copy yanked text from vim into tmux's clipboard and vice versa. The
focus-events plugin is also needed for this to work.

#### [`tpope/vim-fugitive`](https://github.com/tpope/vim-fugitive)

Run git from vim.

I mostly use it for making incremental commits from within vim. This makes it
a terminal-only version of [git-cola](https://git-cola.github.io). Specifically:

| command    | description                                                                                                                  |
|------------|------------------------------------------------------------------------------------------------------------------------------|
| `:Gdiff`   | Split the current buffer, showing the current version on one side and the last-committed version in the other side           |
| `:Gcommit` | After saving the buffer, commit to git (without having to jump back out to terminal) `:Gcommit -m "commit notes" works, too. |

The following commands are built-in vim commands when in diff mode, but are
used heavily when working with `:Gdiff`:

| command | description                                            |
|---------|--------------------------------------------------------|
| `]c`    | Go to the next diff.                                   |
| `[c`    | Go to the previous diff                                |
| `do`    | Use the **o**ther file's contents for the current diff |
| `dp`    | **p**ut the contents of this diff into the other file  |

#### [`chrisbra/vim-diff-enhanced`](https://github.com/chrisbra/vim-diff-enhanced)

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



#### [`dhruvasagar/vim-table-mode`](https://github.com/vim-pandoc/vim-pandoc-syntax)

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.

| command             | description                                               |
|---------------------|-----------------------------------------------------------|
| `:TableModeEnable`  | enables table mode                                        |
| `:TableModeDisable` | disables table mode                                       |
| `:Tableize          | creates a markdown or ReST table based on TSV or CSV text |
| `:TableModeRealign` | realigns an existing table (adding padding as necessary)  |

See the homepage for, e.g., using `||` to auto-create header lines.


#### [`tmhedberg/SimpylFold`](https://github.com/tmhedberg/SimpylFold)

Nice folding for Python, using built-in vim commands for folding like `zc`,
`zn`, `zM`.

| command | description                     |
|---------|---------------------------------|
| `zn`    | unfold everything               |
| `zM`    | fold everything                 |
| `zc`    | toggle folding of current block |


## Working with R in nvim

This assumes that you're using neovim and have installed the neoterm plugin.

### Initial setup

When first starting work on a file:

1. Open or create a new RMarkdown file with nvim
2. Open a neoterm terminal to the right (`,t`)
3. Move to that terminal (`Alt-w`).
4. In the terminal, source activate your environment
5. Start R in the terminal
6. Go back to the RMarkdown or R script, and use the commands above to send
   lines over.

### Working with R

Once you have the terminal up and running:

1. Write some R code.
2. `gxx` to send the current line to R
3. Highlight some lines (`Shift-V` in vim gets you to visual select mode), `gx`
   sends them and then jumps to the terminal.
4. Inside a code chunk, `,cd` sends the entire code chunk and then jumps to the
   next one. This way you can `,cd` your way through an Rmd
5. `,k` to render the current Rmd to HTML.

### Troubleshooting

Sometimes text gets garbled when using an interactive node on biowulf. This is
due to a known bug in Slurm, but Biowulf is not intending on updating any time
soon. The fix is `Ctrl-L` either in the Rmd buffer or in the terminal buffer.
And maybe `,R` to refresh the syntax highlighting.

Remember that the terminal is a vim window, so to enter commands you need to be
in insert mode.



# tmux configuration

Here are the general features of the `.tmux.conf` file:

- Set the prefix to be `Ctrl-j` (instead of the default `Ctrl-b`)
- Use mouse
- Reset escape key time to avoid conflicting with vim
- Set a large history size
- Use vim mode for navigating in copy mode
- When creating a new window or pane, automatically change to the directory of
  the current window or pane.

Here are some shortcuts for window and pane navigation:

| command       | description               |
|---------------|---------------------------|
| `Alt-left`    | move to pane on the left  |
| `Alt-right`   | move to pane on the right |
| `Alt-up`      | move to pane above        |
| `Alt-down`    | move to pane below        |
| `Shift-left`  | move to next window       |
| `Shift-right` | move to previous window   |


# Copy/paste in vim and tmux

In general, if things seem strange, try adding Shift to copy/paste commands.

This is by far the most annoying part about using tmux and vim together.

| copy method                                                                      | where does it go    | how to paste       |
|----------------------------------------------------------------------------------|---------------------|--------------------|
| Shift-select text                                                                | middle-click buffer | shift-middle-click |
| Shift-select text, then Ctrl-shift-C                                             | clipboard           | Ctrl-shift-V       |
| tmux copy mode (`Ctrl-j`, `[`). You probably want to avoid using this inside vim | tmux clipboard      | `Ctrl-j`, `]`      |

Another annoying situation is when copying text from the terminal into an
email. In this case, we cannot use tmux copy mode, because X windows doesn't
know about it. Instead:

- if you're in a pane, make it full screen (`Ctrl-j`, `z`)
- if you're in vim, turn off line numbers (`:set nonu`), or maybe quit out of vim and just cat the file
- shift-select text in terminal
- middle-click to paste into email


# Why?

**Why this repo?** This started as a way of quickly getting myself set up on a new
Linux box (like a fresh AWS instance). Once I started my own bioinformatics
group, I realized there was a benefit to having others use it as well. It now
serves as an opinionated set of configs and tools that new members to the group
can use as a starting point to grow their own dotfiles.

**Why neovim?** The biggest reason is for the within-editor terminal that lets
us recapitulate RStudio completely within the terminal on an HPC cluster. While
the latest version of vim (version 8) is approaching feature parity with neovim
especially with a terminal, vim 8 is just about as difficult to install as
nvim. On biowulf, nvim (but not vim8) is installed. That makes it easier to use
the same features both locally and on biowulf. There are a couple of
nice additions,and plugins that work only with nvim, but honestly the
differences now are pretty subtle.

**Why have all those install commands?** Each tool has its own way of installing
and/or compiling. Many tools have been turned into conda packages, which
simplifies things, but not all tools are available on conda. Those install
commands keep things modular (only install what you want) and simple. And of
course the end result is lots of useful tools.

**Why use conda and then symlink to `~/opt/bin`?** I wanted the tools to be
available no matter what conda environment I was in.

**Why bash for `setup.sh`?** There are a lot of system calls, which gets awkward in
Python. This way everything is straightforwardly (if verbosely) captured in
a single script without any other dependencies.

Starting with a fresh install of Ubuntu, CentOS, or macOS, with this repo I can
be up and running with everything I need plus all my configurations and plugins
in a couple of minutes.


# `setup.sh`

`setup.sh` does all the work. Run it with no options to see the help. Search
for each option within the script to understand what each part does.

Current options include (in approximate order in which they're typically run):


argument                    |  description   
--------                    |  -----------
--`dotfiles`                | update dotfiles in home directory with files in this repo (you'll be prompted)                  
--`apt-get-installs`        | installs packages on Ubuntu (see `setup.sh` for which packages)                                     
--`docker`                  | installs docker on Ubuntu and adds current user to new docker group                              
--`download-miniconda`       | downloads latest Miniconda to current directory                                                    
--`install-miniconda`        | install downloaded Miniconda to ~/miniconda3                                                        
--`set-up-bioconda`          | add channels for bioconda in proper order                                                           
--`conda-env`                | install requirements.txt into root conda env                                                        
--`download-neovim-appimage` | download appimage instead of compiling                                                             
--`download-macos-nvim`      | download binary nvim for MacOS                                                                     
--`powerline`                | installs powerline fonts, used for the vim airline plugin                                           
--`set-up-nvim-plugins`      | download vim-plug for easy vim plugin installation                                                  
--`centos7-installs`         | installs packages on CentOs (compilers; recent tmux)                                              
--`install-fzf`              | installs [fzf](https://github.com/junegunn/fzf), command-line fuzzy finder                          
--`install-ag`               | installs [ag](https://github.com/ggreer/the_silver_searcher), a fast code-searching tool          
--`install-autojump`         | installs [autojump](https://github.com/wting/autojump), for quickly navigating multiple directories
--`diffs`                    | show differences between repo and home directory                                                    


# General workflow

On a new machine:

```
./setup.sh --dotfiles
./setup.sh --apt-get-installs
./setup.sh --download-neovim-appimage
./setup.sh --powerline
./setup.sh --set-up-nvim-plugins

# exit and re-enter
```

# Bash-related configuration

`.bashrc` sources `.bash_profile`, which in turn sources the following files if
they're present. This keeps things a little more organized and modular.

| file           | description                                                                                     |
| --             | --                                                                                              |
| `.aliases`     | defines bash aliases                                                                            |
| `.functions`   | defines bash functions                                                                          |
| `.path`        | sets `$PATH` entries                                                                            |
| `.bash_prompt` | changes prompt colors depending on the host                                                     |
| `.exports`     | global exports that can be public                                                               |
| `.extra`       | put anything here that's not appropriate for storing in a public repository like IPs, keys, etc |

## `.aliases`

Some notable aliases:

| alias | command             | description                                                                                                                                    |
|-------|---------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `vim` | `nvim`              | always use neovim                                                                                                                              |
| `D`   | `export DISPLAY=:0` | sometimes when using tmux the display is not set, causing GUI programs launched from the terminal to complain. This sets the display variable. |

## `.functions`

Some notable functions:

| function      | description                                                                                      |
| ----          | ---                                                                                              |
| `start_agent` | Use this to start the ssh agent so you don't need to keep entering your ssh key during a session |
| `tre`         | Nicer `tree` output, colored and piped to less                                                   |
| `sa`          | Opens fzf to search across all conda environments, and activates the selected one                |


# Neovim configuration

In the [.config/nvim/init.vim](.config/nvim/init.vim) file in this repo:

- `<Leader>` is set to `,`.
- `<Localleader>` is set to `/`
In the terminal itself, go to Preferences, select the "Custom Font" checkbox, and choose a font filtered with "Powerline" so it will be Powerline compatible.

## Plugins

These plugins have lots and lots of options. Here I'm only highlighting the
options I use the most, but definitely check out each homepage to see all the
other weird and wonderful ways they can be used.

### `scrooloose/nerdcommenter`

[Homepage](https://github.com/scrooloose/nerdcommenter)

| command | description                       |
|---------|-----------------------------------|
| `<leader>cc`   | Comment current or selected lines |


### `scrooloose/nerdtree`

[Homepage](https://github.com/scrooloose/nerdtree)

| command | description             |
|---------|-------------------------|
| `<leader>n`    | Open a new file browser |

### `vim-airline/vim-airline`, `vim-airline/vim-airline-themes`

[vim-airline homepage](https://github.com/vim-airline/vim-airline)
[themes](https://github.com/vim-airline/vim-airline/wiki/Screenshots)

Nice statusline. Install powerline fonts for full effect (with `./setup.py
--powerline-fonts` using the setup script in this repository)


### `roxma/vim-tmux-clipboard`, `tmux-plugins/vim-tmux-focus-events`

[Homepage](https://github.com/roxma/vim-tmux-clipboard)

Copy yanked text from vim into tmux's clipboard and vice versa. The
focus-events plugin is also needed for this to work.

### `nvie/vim-flake8`

[Homepage](https://github.com/nvie/vim-flake8)

You'll need to `pip install flake8` for this to work.
[Flake8](http://flake8.pycqa.org/en/latest/) checks your Python code against
the [PEP8 Python Style Guide](https://www.python.org/dev/peps/pep-0008/). After
it runs, you'll get a quick-fix window. In that window, hitting Enter on a line
will jump to that place in the Python buffer so you can fix it.

| command     | description                                  |
|-------------|----------------------------------------------|
| `<leader>8` | Run flake8 on the file in the current buffer |


### `vim-python/python-syntax`

[Homepage](https://github.com/vim-python/python-syntax)

Sophisticated python syntax highlighting, for example within format strings.


### `Vimjas/vim-python-pep8-indent`

[Homepage](https://github.com/Vimjas/vim-python-pep8-indent)

Auto-indent Python using pep8 recommendations. This happens as you're typing,
or when you use `gq` on a selection.

### `ervandew/supertab`

[Homepage](https://github.com/ervandew/supertab)

Autocomplete most things with `TAB` in insert mode.

### `tpope/vim-fugitive`

[Homepage](https://github.com/tpope/vim-fugitive)

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

### `chrisbra/vim-diff-enhanced`

[Homepage](https://github.com/chrisbra/vim-diff-enhanced)

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

### `kassio/neoterm`

[Homepage](https://github.com/kassio/neoterm)

Provides a separate terminal in vim.

The following commands are custom mappings set in
[.config/nvim/init.vim](.config/nvim/init.vim):

| command     | description                                                                         |
|-------------|-------------------------------------------------------------------------------------|
| `<leader>t` | Open a terminal to the right                                                        |
| `gx`        | Send the current selection to the terminal                                          |
| `gxx`       | Send the current line to the terminal                                               |
| `,cd`       | Send the current RMarkdown chunk to the terminal (which is assumed to be running R) |

### `vim-pandoc/vim-rmarkdown`

[Homepage](https://github.com/vim-pandoc/vim-rmarkdown)

Syntax highlight R within RMarkdown code chunks. Requires both `vim-pandoc` and
`vim-pandoc-syntax`, described below.


### `vim-pandoc/vim-pandoc`, `vim-pandoc/vim-pandoc-syntax`

- [vim-pandoc](https://github.com/vim-pandoc/vim-pandoc)
- [vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax)

Integration with pandoc, including folding and formatting. Lots of shortcuts
defined, see
[this section of the
help](https://github.com/vim-pandoc/vim-pandoc/blob/master/doc/pandoc.txt#L390) for more.


| command | description                                                                              |
|---------|------------------------------------------------------------------------------------------|
| `:TOC`  | Open a table contents for the current document that you can use to navigate the document |


### `dhruvasagar/vim-table-mode`

[Homepage](https://github.com/vim-pandoc/vim-pandoc-syntax)

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.

| command             | description                                               |
|---------------------|-----------------------------------------------------------|
| `:TableModeEnable`  | enables table mode                                        |
| `:TableModeDisable` | disables table mode                                       |
| `:Tableize          | creates a markdown or ReST table based on TSV or CSV text |

See the homepage for, e.g., using `||` to auto-create header lines.

### `tmhedberg/SimpylFold`

[Homepage](https://github.com/tmhedberg/SimpylFold)

Nice folding for Python, using built-in vim commands for folding like `zc`,
`zn`, `zM`.


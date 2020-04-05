.. _why:

Why?
====

**Why this repo?** This started as a way of quickly getting myself set
up on a new Linux box (like a fresh AWS instance). Once I started my own
bioinformatics group, I realized there was a benefit to having others
use it as well. It now serves as an opinionated set of configs and tools
that new members to the group can use as a starting point to grow their
own dotfiles.

**Why neovim?** The biggest reason is for the within-editor terminal
that lets us recapitulate RStudio completely within the terminal on an
HPC cluster. While the latest version of vim (version 8) is approaching
feature parity with neovim especially with a terminal, vim 8 is just
about as difficult to install as nvim. On biowulf, nvim (but not vim8)
is installed. That makes it easier to use the same features both locally
and on biowulf. There are a couple of nice additions,and plugins that
work only with nvim, but honestly the differences now are pretty subtle.

**Why have all those install commands?** Each tool has its own way of
installing and/or compiling. Many tools have been turned into conda
packages, which simplifies things, but not all tools are available on
conda. Those install commands keep things modular (only install what you
want) and simple. And of course the end result is lots of useful tools.

**Why use conda and then symlink to ``~/opt/bin``?** I wanted the tools
to be available no matter what conda environment I was in.

**Why bash for ``setup.sh``?** There are a lot of system calls, which
gets awkward in Python. This way everything is straightforwardly (if
verbosely) captured in a single script without any other dependencies.

.. _why:

Why?
====

**Why this repo?** This started as a way of quickly getting myself set
up on a new Linux box (like a fresh AWS instance). Once I started my own
bioinformatics group, I realized there was a benefit to having others
use it as well. It now serves as an opinionated set of configs and tools
that new members to the group can use as a starting point to grow their
own dotfiles. Of course, some folks already have their own dotfiles, but this
repo also serves as a compilation of useful tools and config options, so that
I can easily reference a line number in the repo to illustrate how to fix an
issue.

**Why neovim?** The biggest reason is the within-editor terminal. It lets us
work in an RStudio-like environment, but completely within the terminal on an
HPC cluster. While the latest version of vim (version 8) is approaching feature
parity with neovim especially with a terminal, vim 8 is just about as difficult
to install as nvim. On Biowulf, nvim (but not vim8) is installed. That makes it
easier to use the same features both locally and on Biowulf. There are a couple
of nice additions and plugins that work only with nvim, but honestly the
differences now are pretty subtle.

**Why have all those install commands?** Each tool has its own way of
installing and/or compiling. Many tools have been turned into conda
packages, which simplifies things, but not all tools are available on
conda. Those install commands keep things modular (only install what you
want) and simple. And of course the end result is lots of useful tools.

**Why use conda and then symlink to** ``~/opt/bin``? I wanted the tools
to be available no matter what conda environment I was in, and didn't want to
have to install them into each environment. Plus, it can get messy if
everything is in the same environment and I just want to upgrade one tool --
conda/mamba might decide it needs to upgrade other tools as well. This way,
with everything in its own independent conda environment, I can maintain and
upgrade independently, and still have them on my path.

**Why use bash for** ``setup.sh`` ? There are a lot of system calls, which gets
awkward in Python. Using bash, everything is straightforwardly (if verbosely)
captured in a single script without any other dependencies.

.. _why-lua:

**Why move to Lua for nvim?** For years I've symlinked :file:`.vimrc` to
:file:`.config/nvim/init.vim`, and had just a small number of if-clauses for
nvim-specific behavior. This was because on some systems I still had vim, or
otherwise hadn't completely set up nvim for things like ``$EDITOR``, and wanted
to be fully functional in either. Nowadays though, I have nvim everywhere and
there's not much of a need. Plus, there's a lot of interesting functionality
being developed for nvim, and keeping backwards compatibility was holding back
the vim+nvim config. I suppose I could have kept :file:`init.vim` in VimL, but
some plugins (nvim-cmp, treesitter, and LSP-related stuff in particular) often
needs a lot of customization in Lua. Having one main config file for all of that would
get out of hand, so I'd need to modularize somehow. I liked how lazy.nvim
naturally supported modularization of plugins, and once I refactored things
I thought it was a good approach.

.. _bash:

Bash dotfiles
=============

The modular organization for bash configuration is inspired by `this
repo <https://github.com/mathiasbynens/dotfiles>`__.

``.bashrc`` sources ``.bash_profile``, which in turn sources the
following files if they’re present. This keeps things a little more
organized and modular. They work like this:

::

   .bash_profile  # sources .bashrc
   .bashrc        # sources the following files:
            --> .path         # all "export PATH=..." goes in here
            --> .aliases      # add your aliases here
            --> .functions    # add your functions here
            --> .exports      # add your various exports here
            --> .bash_prompt  # edit your bash prompt here
            --> .extra        # any machine-specific config goes here

Below is a little more detail on the contents of each of these files and
some notable features.

``.path``
---------

This file ends up being lots of ``export PATH="$PATH:/some/other/path"``
lines. It is initially populated to put ``~/opt/bin`` and
``~/mambaforge/condabin`` on the path. As you install more software in other
locations, this is a tidy place to put the various exports.

``.aliases``
------------

This file keeps aliases separate. Some notable aliases that are
included:

.. list-table::

    * - alias
      - command
      - description

    * - ``vim``
      - ``nvim``
      - always use neovim (this is added only if nvim is found on the path)

    * - ``D``
      - ``export DISPLAY=:0``
      - sometimes when using tmux the display is not set, causing GUI programs
        launched from the terminal to complain. This sets the display variable.

    * - ``ll``
      - ``ls -lrth --color=auto``
      - useful `ls` arguments (long format, human-readable sizes, sorted by
        time (latest at bottom), use color). MacOS has different options, so
        this alias tries to handle that correctly.

    * - ``la``
      - ``ls -lrthA --color=auto``
      - same as above, but also show hidden files

    * - ``v``
      - (see .aliases file)
      - Live, searchable, syntax-highlighted preview of files in a directory.
        Needs :ref:`fzf` and :ref:`bat` installed

    * - ``..``
      - ``cd ..``
      - faster way of moving up a directory

    * - ``gsv``
      - ``vim -c ':Gstatus' -c ':bunload 1'``
      - Opens vim and runs vim-fugitive. See :ref:`vim-fugitive` for details.

    * - ``glv``
      - ``vim -c ':GV'``
      - Opens vim and runs vim-gv for browsing git history. See :ref:`vim-gv`
        for details.

``.functions``
--------------

Separate file for bash functions. This is also where fzf and autojump
are set up. Some notable functions defined here:

.. list-table::

    * - function
      - description
    * - ``start_agent``
      - Use this to start the ssh agent so you don't need to keep entering your
        ssh key during a session
    * - ``tre``
      - Nicer ``tree`` output, colored and piped to less
    * - ``sa``
      - Open :ref:`fzf` to search across all conda environments, and activates the
        selected one
    * - ``prsetup``
      - When run in a clone of a repo with a pull request from a fork, get set up
        to push changes back to the contributor's branch

``.bash_prompt``
----------------

This file changes the prompt color for Biowulf or Helix (NIH HPC), but
here you can add any other hosts or colors. See
https://misc.flogisoft.com/bash/tip_colors_and_formatting for color
options.

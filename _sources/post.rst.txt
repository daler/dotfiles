Post-setup tasks
================

The ``setup.sh`` script tries to automate as much as possible, but there are
some things that have to be manually done. This page documents those additional
tasks.

.. _macpostinstall:

Mac
---

Cursor
~~~~~~

- In iTerm, I like tweaking the cursor a little, to have the block cursor show
  inverted colors and to have the vertical line cursor a little wider so it's
  easier to see. First, in Preference -> Profile -> Colors, select "Smart box
  cursor color". Then in Preferences -> Advanced:

    - width of vertical bar cursor: 2
    - threshold for smart cursor for foreground: 0
    - threshold for smart cursor for background: 0

Disable bell
~~~~~~~~~~~~

To turn off the iTerm2 audio bell (that "donk!" noise you get after hitting
TAB): under preferences, go to Profiles, then the Terminal tab. Make sure
"Silence bell" is checked.

.. _zshmac:

zsh to bash
~~~~~~~~~~~

Recent macOS versions use ``zsh`` as the default shell instead of bash. These
dotfiles assume bash as the default shell (for compatibility with HPC (Linux)
systems which typically default to bash as well). See `this post
<https://apple.stackexchange.com/a/361957>`_ for a great explanation of the
differences. 

The ``chsh`` command just has to be run once to change the shell to bash. To
avoid the message about zsh popping up all the time (as `documented at
support.apple.com <https://support.apple.com/en-us/HT208050>`_), set
``BASH_SILENCE_DEPRECATION_WARNING=1``. Here, we export it in :file:`~/.extra`,
which as :ref:`bashrc` describes, will be sourced by :file:`.bashrc` once these
dotfiles are set up.

.. code-block::

    chsh -s /bin/bash
    echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> ~/.extra

Touchbar
~~~~~~~~
To turn off the application-specific changing of the touch bar: System
Preferences > Keyboard, then change "Touch Bar shows" to "Expanded Control
Strip".

Copy/paste
~~~~~~~~~~
In iTerm preferences, click the "General" icon, and check "Applications in
terminal may access clipboard"

SSH config
----------

Create your ssh keys, and add them to the various systems.

See https://nichd-bspc.github.io/training/ssh.html for more details and for
more specific commands.

.. code-block:: bash

    ssh-keygen

.. code-block:: bash

    ssh-copy-id user@hostname

.. code-block:: bash

    cat ~/.ssh/id_rsa.pub

On Mac, add this to your ``~/.ssh/config`` file (creating it if it doesn't
exist). Then, by using the ``s`` alias, your SSH key will be added to the
session using your login to MacOS as the authentication, without needing to
type in your passphrase

.. code-block::

    # this goes in ~/.ssh/config
    Host *
      UseKeychain yes
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519

Git config
----------

.. code-block:: bash

    git config --global user.name "your name here"
    git config --global user.email "your email here"

Alacritty config
----------------
If you're using Alacritty as your terminal, it needs a little configuration to
get colors to work on tmux.

These instructions are from `this gist <https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6>`_.

In :file:`.config/alacritty/alacritty.yml`::

    env:
        TERM: xterm-256color

In :file:`.tmux.conf`::

    set -g default-terminal "tmux-256color"
    set -ag terminal-overrides ",xterm-256color:RGB"

    # Or use a wildcard instead of forcing a default mode.
    # Some users in the comments of this gist have reported that this work better.
    #set -sg terminal-overrides ",*:RGB"

    # You can also use the env variable set from the terminal.
    # Useful if you share your configuration betweeen systems with a varying value.
    #set -ag terminal-overrides ",$TERM:RGB"

In :file:`.config/nvim/init.vim`::


    " You might have to force true color when using regular vim inside tmux as the
    " colorscheme can appear to be grayscale with "termguicolors" option enabled.
    " if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    "   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    "   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " endif

    set termguicolors
    colorscheme yourfavcolorscheme



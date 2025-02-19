.. _postinstall:

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


Fix keyboard on Mac
~~~~~~~~~~~~~~~~~~~

By default on Mac, unless overridden by a program, Home and End jump to the
beginning/end of a *document* rather than a *line*. This is different from the
Windows and Linux behavior of jumping to beginning/end of a line.

The typical workaround is to use Cmd-Left and Cmd-Right. Some programs (like
Outlook on Mac) already override this. But some don't, like web browsers.
When editing a large text input box in a web browser, it can be frustrating if
you mistakenly hit End, expecting to jump to the end of a line in Outlook, but
instead it jumps to the very end of the text input and you have to go find where you were.

Running ``./setup.sh --mac-keyboard-fix`` fixes this by creating a new
``~/Library/KeyBindings/DefaultKeyBinding.dict`` file; see that file for
details. You'll need to restart programs to see the effect.

.. _zshmac:

zsh to bash
~~~~~~~~~~~

Recent macOS versions use ``zsh`` as the default shell instead of bash. These
dotfiles assume bash as the default shell (for compatibility with HPC (Linux)
systems which typically default to bash as well). See `this post
<https://apple.stackexchange.com/a/361957>`_ for a great explanation of the
differences. 

The ``chsh`` command just has to be run once to change the shell to bash. But
the warning will still show up. To avoid the message about zsh popping up all
the time (as `documented at support.apple.com
<https://support.apple.com/en-us/HT208050>`_), set
``BASH_SILENCE_DEPRECATION_WARNING=1``. Here, we export it in :file:`~/.extra`,
which as :ref:`bashrc` describes, will be sourced by :file:`.bashrc` once these
dotfiles are set up.

.. code-block:: bash

    chsh -s /bin/bash
    echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> ~/.extra

This can also be done by using ``./setup.sh --mac-stuff``.

Touchbar
~~~~~~~~
To turn off the application-specific changing of the touch bar: System
Preferences > Keyboard, then change "Touch Bar shows" to "Expanded Control
Strip".

Copy/paste
~~~~~~~~~~
In iTerm preferences, click the "General" icon, and check "Applications in
terminal may access clipboard"

Mac Terminal
~~~~~~~~~~~~
If you're using Mac Terminal, the colorscheme for nvim will not work because
the built-in Mac Terminal.app does not support true color for some reason. See
:ref:`mac-terminal-colors` for details on how to fix this.

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

.. code-block:: bash

    # this goes in ~/.ssh/config
    Host *
      UseKeychain yes
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519

Git config
----------

Setting up git is important for your commits to be attributed to you.

.. code-block:: bash

    git config --global user.name "your name here"
    git config --global user.email "your email here"


Alternatively you can edit :file:`~/.gitconfig` to add:

.. code-block:: ini

   [user]
       name = "your name here"
       email = "your email here"

Optionally, you can conditionally include other files. This is useful, for
example, if you have different emails configured for different remotes (GitHub,
GitLab):

.. code-block:: ini

   # In main .gitconfig, this will be the default...
   [user]
       name = "your name here"
       email = "your email here"

   # ...unless the configured SSH remote matches "git@gitlab.com:*/**"
   [includeIf "hasconfig:remote.*.url:git@gitlab.com:*/**"]
       # ...in which case this file will be included verbatim
       path = .gitlab.inc

.. code-block:: ini

   # In .gitlab.inc
   [user]
       # Override the email
       email = "your OTHER email here"


Alacritty config
----------------
If you're using Alacritty as your terminal, it needs a little configuration to
get colors to work on tmux.

These instructions are from `this gist <https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6>`_.

In :file:`.config/alacritty/alacritty.yml`::

    env:
        TERM: xterm-256color

Or in recent versions of Alacritty, in :file:`.config/alacritty/alacritty.toml`::

    [env]
    TERM = "xterm-256color"


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


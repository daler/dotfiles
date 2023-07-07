Post-setup tasks
================

The ``setup.sh`` script tries to automate as much as possible, but there are
some things that have to be manually done. This page documents those additional
tasks.

Mac
---

- To turn off the iTerm2 audio bell (that "donk!" noise you get after hitting
  TAB): under preferences, go to Profiles, then the Terminal tab. Make sure
  "Silence bell" is checked.

- To avoid the message abou zsh popping up all the time (and you still want to use bash):

.. code-block::

    chsh -s /bin/bash

and then as `documented at support.apple.com
<https://support.apple.com/en-us/HT208050>`_ export this env var to disable
(e.g., in your `~/.extras` file):

.. code-block::

    export BASH_SILENCE_DEPRECATION_WARNING=1

- To turn off the application-specific changing of the touch bar: System
  Preferences > Keyboard, then change "Touch Bar shows" to "Expanded Control
  Strip".

- In iTerm preferences:
  - click the "General" icon, and check "Applications in terminal may access
    clipboard"
  - click the "Profiles" icon, and in the "Text" "Use built-in
    Powerline glyphs"

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

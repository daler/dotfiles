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

Git config
----------

.. code-block:: bash

    git config --global user.name "your name here"
    git config --global user.email "your email here"

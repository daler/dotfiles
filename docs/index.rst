daler dotfiles
==============

.. details:: What are dofiles?

    Linux and macOS have user-specific configuration files for things like bash,
    vim, tmux, and more. Since these files traditionally start with a ``.``, they
    are collectively called dotfiles.

`This repo <https://github.com/daler/dotfiles>`_ captures hard-won settings and
tool installations that I have accumulated over time. Using the included
modular setup script, starting from a fresh installation of Ubuntu Linux or
macOS I can have everything I’m used to a few minutes. It can be useful for different audiences:

* **Just starting out?** This is a “batteries included” configuration you can use
  as a launching point.

* **Already maintain your own dotfiles?** Browse around to see if there's anything
  you want to add to your own setup, everything here is documented.

The repo includes the following, all driven by the ``setup.sh`` script:

- :ref:`bash config <bash>`, :ref:`tmux config <tmux>`, and :ref:`vim/neovim config <vim>` files.
- conda installation and setup commands
- :ref:`tool installation commands <tools>`

If you don’t want “batteries included”, you can select only what is most
useful to you because:

-  the ``setup.sh`` script is modular
-  these docs have all the details so you are informed about options
-  the config files themselves are documented

See the :ref:`changelog` for changes.

Ready? :ref:`starthere`!

.. toctree::
    :maxdepth: 3
    :hidden:

    starthere
    tools
    bash
    vim
    tmux
    conda
    post
    nvim-lua
    why
    changelog

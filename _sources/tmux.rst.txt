.. _tmux:

tmux configuration
==================

Here are the general features of the ``.tmux.conf`` file:

-  Set the prefix to be ``Ctrl-j`` (instead of the default ``Ctrl-b``)
-  Use mouse
-  Reset escape key time to avoid conflicting with vim
-  Set a large history size
-  Use vim mode for navigating in copy mode
-  When creating a new window or pane, automatically change to the
   directory of the current window or pane.

Here are some shortcuts for window and pane navigation:

================ ===========================
command          description
================ ===========================
``Alt-arrows``   move around panes
``Shift-arrows`` switch windows (left/right)
================ ===========================

Copy/paste in vim and tmux
--------------------------

In general, if things seem strange, try adding Shift to select/copy/paste
commands.

This is by far the most annoying part about using tmux and vim together.

.. list-table::

  * - copy method (Linux)
    - copy method (Mac)
    - where does it go
    - how to paste (Linux)
    - how to paste (Mac)
  * - shift-select text
    -
    - middle-click buffer
    - :kbd:`shift-middle click`
    - 
  * - shift-select text, then Ctrl-shift-C
    - shift-select text, then Cmd-shift-C
    - clipboard
    - ctrl-shift-v
    - cmd-shift-v
  * - tmux copy mode (:kbd:`ctrl-j`:kbd:`[`). You probably want to avoid using
      this inside vim.
  * - tmux copy mode (:kbd:`ctrl-j`:kbd:`[`). You probably want to avoid using
      this inside vim.
    - tmux clipboard
    - :kbd:`ctrl-j`:kbd:`]`
    - :kbd:`ctrl-j`:kbd:`]`


Another annoying situation is when copying text from the terminal into
an email. In this case, we cannot use tmux copy mode, because X windows
doesn’t know about it. Instead:

-  if you’re in a pane, make it full screen (``Ctrl-j``, ``z``)
-  if you’re in vim, turn off line numbers (``:set nonu``), or maybe
   quit out of vim and just cat the file
-  shift-select text in terminal
-  middle-click to paste into email

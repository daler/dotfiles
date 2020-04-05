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

=============== =========================
command         description
=============== =========================
``Alt-left``    move to pane on the left
``Alt-right``   move to pane on the right
``Alt-up``      move to pane above
``Alt-down``    move to pane below
``Shift-left``  move to next window
``Shift-right`` move to previous window
=============== =========================

Copy/paste in vim and tmux
--------------------------

In general, if things seem strange, try adding Shift to copy/paste
commands.

This is by far the most annoying part about using tmux and vim together.

+-----------------------------------------------+-----------+----------+
| copy method                                   | where     | how to   |
|                                               | does it   | paste    |
|                                               | go        |          |
+===============================================+===========+==========+
| Shift-select text                             | mid       | sh       |
|                                               | dle-click | ift-midd |
|                                               | buffer    | le-click |
+-----------------------------------------------+-----------+----------+
| Shift-select text, then Ctrl-shift-C          | clipboard | Ctrl     |
|                                               |           | -shift-V |
+-----------------------------------------------+-----------+----------+
| tmux copy mode (``Ctrl-j``, ``[``). You       | tmux      | ``C      |
| probably want to avoid using this inside vim  | clipboard | trl-j``, |
|                                               |           | ``]``    |
+-----------------------------------------------+-----------+----------+

Another annoying situation is when copying text from the terminal into
an email. In this case, we cannot use tmux copy mode, because X windows
doesn’t know about it. Instead:

-  if you’re in a pane, make it full screen (``Ctrl-j``, ``z``)
-  if you’re in vim, turn off line numbers (``:set nonu``), or maybe
   quit out of vim and just cat the file
-  shift-select text in terminal
-  middle-click to paste into email

conda
=====

Installing conda
----------------

To install conda, we use `Mambaforge
<https://github.com/conda-forge/miniforge>`_. Mambaforge is a way of installing
conda that sets conda-forge as the default (and only) channel, and it includes
``mamba``, a drop-in replacement for conda that is faster and more
feature-complete.

Don't run ``conda init bash``
-----------------------------

.. note::

    TL;DR: use ``ca`` to activate an environment. See below for why.

Usually, after installing conda, you would typically run ``conda init bash``.
**These dotfiles are set up to explicitly avoid that here.**

Why? First, because this adds lines to your ``.bashrc`` file (if on Linux) or
your ``.bash_profile`` file (if on Mac). Thereafter, every single new bash
session runs that code...which involves importing some Python libraries and
running conda itself. Since the conda Python module loads other modules, and
those modules load still others, every time a bash session is started, many
files are touched.

Why is this a problem?

Reading many files on every bash session can cause I/O slowdown in
a high-performance computing environment (like NIH's Biowulf) when many jobs
are kicked off simultaneously. So we want to avoid this on HPC environments.
This I/O load is not an issue on a personal machine,since it's unlikely that
you'll be starting so many bash sessions.

Second, you may find that on tmux, when you create a new pane or window, your
prompt still indicates that you're in a conda environment, but running ``which
python`` returns the *system* Python. It turns out that this is because tmux
prepends the system path to the PATH when creating a new pane or window. The
solution is to run ``conda deactivate`` a bunch of times, until the prompt no
longer has the ``(env_name)`` indicator in it, and *then* activate the
environment you want.

The solution
------------

1. **To activate an environment, use** ``ca`` at the time you want to use it.
   Use ``ca`` by itself to activate the base environment. Use ``ca <envname>`` to
   activate a specific environment.

   .. code-block:: bash

      # activate named environment
      ca myenv

      # activate environment at path
      ca ./env


2. Every new tmux pane starts with everything deactivated.

How it works
------------

These dotfiles provide a function, ``ca`` (short for "conda activate"). It's
defined in the :file:`~/.functions` file which in turn is sourced in
:file:`~/.bashrc`. This function runs ``eval "$(conda shell.bash hook)"``,
which is a way of running the same commands that ``conda init bash`` would add
to your ``~/.bashrc``. **But it runs it on demand, not every shell.** In other
words, this is wrapping the ``conda init bash`` stuff inside a function that we
only call when we need it.

The file :file:`.functions` also has a ``conda_deactivate_all`` function, which
keeps running ``conda deactivate`` until there's no activated environment (this
idea is from `this SO answer <https://stackoverflow.com/a/76304995>`_). You
typically won't run this on your own much, but theres a line in ``~/.bashrc``
that runs ``conda_deactivate_all`` if we're in a tmux session, so it will run
on each new tmux pane. You'll need to activate the environment again in the new
pane.


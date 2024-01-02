# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,bash_prompt,functions,aliases,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

[ -z "$PS1" ] && return             # exit early if not interactive
shopt -s checkwinsize               # updates size of terminal after commands

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do

    shopt -s "$option" 2> /dev/null || true
done;

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi

# makes less work on things like tarballs and images
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ `command -v dircolors` ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
update_mac_ls_colors

if [[ $OSTYPE == darwin* ]]; then
    test -f ~/.git-completion.bash && source ~/.git-completion.bash
fi

# New bash shells spawned by tmux will silently break conda environments by
# placing the system path in front of the conda env path -- even though the
# prompt still indicates an active environment. This can be quite confusing.
#
# So if we're starting a bash shell under tmux, deactivate all environments.
#
# The `ca` and `conda_deactivate_all` functions used here are defined in the
# .functions file, which in turn was sourced at the beginning of this file.
if command -v conda > /dev/null; then
    if [ ! -z $TMUX ]; then
        conda_deactivate_all
    fi
fi

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
    shopt -s "$option" 2> /dev/null;
done;

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi

# makes less work on things like tarballs and images
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ `command -v dircolors` ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
else
    if [[ $OSTYPE == darwin* ]]; then
        echo "Looks like you're on MacOS. Might want to 'conda install dircolors'"
        echo "and re-run"
    fi
fi

if [[ $OSTYPE == darwin* ]]; then
    test -f ~/.git-completion.bash && source ~/.git-completion.bash
fi

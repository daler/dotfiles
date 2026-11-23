#!/bin/bash
#
FAILURES=0
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
UNSET="\e[0m"

OLDIFS=$IFS; IFS=$'\n';
while read line; do
    tst=$(echo $line | awk -F "\t" '{print $1}')
    exp=$(echo $line | awk -F "\t" '{print $2}')
    if obs=$(docker run --rm --platform linux/amd64 daler-dotfiles bash -c '
        trap '\''echo "ERROR: shell exited before running the test" >&2; trap - EXIT; exit 125'\'' EXIT
        source .bashrc || exit $?
        trap - EXIT
        set -o pipefail
        eval "$1"
    ' bash "$tst"); then
        status=0
    else
        status=$?
    fi
    if (( status != 0 )); then
        printf "${RED}[FAIL]${UNSET} $tst; command exited with status $status (stdout: '$obs')\n"
        FAILURES=1
    elif [[ $exp != $obs ]]; then
        printf "${RED}[FAIL]${UNSET} $tst; '$obs' != '$exp'\n"
        FAILURES=1
    else
        printf "${GREEN}[PASS]${UNSET} $tst = $exp\n"

    fi
done < test_commands

IFS=$OLDIFS

if [[ $FAILURES == 1 ]]; then
    printf "${RED}Failures found, see above.${UNSET}\n\n"
    exit 1
fi

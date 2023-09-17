#!/bin/bash
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
    obs=$(docker run --rm --platform linux/amd64 daler-dotfiles "source .bashrc; $tst")
    if [[ $exp != $obs ]]; then
        printf "${RED}[FAIL]${UNSET} $tst; $obs != $exp\n"
        FAILURES=1
    else
        printf "${GREEN}[PASS]${UNSET} $tst = $exp\n"

    fi
done < test_commands
if [[ $FAILURES == 1 ]]; then
    printf "${RED}Failures found, see above.${UNSET}\n\n"
    exit 1
fi
IFS=OLDIFS

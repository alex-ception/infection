#!/usr/bin/env bash

if test ! -f "$(which expect)"; then
    test -x $(which tput) && tput setaf 1 # red
    echo "Please install expect; it is readily available from apt and brew"
    exit 1;
fi

cd $(dirname $0)
rm -v -f infection.json infection.log

set -e

if [ "$DRIVER" = "phpdbg" ]
then
    INFECTION="phpdbg -qrr ../../../bin/infection"
else
    INFECTION="php ../../../bin/infection"
fi
export INFECTION
unset CI
unset CONTINUOUS_INTEGRATION
unset TRAVIS
unset GITHUB_ACTIONS

./do_configure.expect

trap 'echo Final check failed: $(tail -n+$LINENO $0 | head -n1)' ERR

test -f infection.json

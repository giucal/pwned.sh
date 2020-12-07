#!/bin/sh

# pwned -- query HIBP's Pwned Passowords dataset

set -e

usage() {
    echo >&2 "Usage: $(basename "$0") [-h]"
    [ "$1" = '-h' ] && echo >&2 "
Query the Pwned Passwords dataset.
Refer to <https://haveibeenpwned.com/Passwords> for details."
    exit 2
}

# Prompt for a password.
prompt() {
    printf '%s' "$1" > /dev/tty
    stty -echo
    IFS= read -r "$2"
    echo > /dev/tty
    stty echo
}

getopts h _ && usage -h
[ $# -ne 0 ] && usage

prompt "Password: " pw

pwhash=$(printf '%s' "$pw" | openssl sha1 | awk '{ print $NF }')
prefix=$(printf '%s' $pwhash | head -c5)
suffix=$(printf '%s' $pwhash | tail -c35)

curl https://api.pwnedpasswords.com/range/$prefix 2>/dev/null |
grep -iq $suffix && echo "PWNED" || echo "Not pwned... yet"

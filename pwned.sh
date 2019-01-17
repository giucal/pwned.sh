#!/usr/bin/env bash

# pwned -- query HIBP's Pwned Passowords dataset

set -e

USAGE="Usage: $(basename $0) [-h]"

if getopts h opt; then
    echo $USAGE
    echo
    echo "Query the Pwned Passwords dataset."
    echo "Refer to <https://haveibeenpwned.com/Passwords> for details."
    exit
fi

if [[ $# -ne 0 ]]; then
    echo >&2 $USAGE
    exit 2
fi

echo -n "Password: "
read -s pw
echo

pwhash=$(echo -n "$pw" | openssl sha1)
prefix=$(echo -n $pwhash | head -c5)
suffix=$(echo -n $pwhash | tail -c35)

curl https://api.pwnedpasswords.com/range/$prefix 2>/dev/null |
grep -iq $suffix && echo "PWNED" || echo "Not pwned... yet"

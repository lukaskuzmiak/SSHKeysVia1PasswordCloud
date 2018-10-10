#!/bin/bash

# Copyright (c) 2018 Lukas Kuzmiak (lukash@backstep.net)
#
# ~/.op.secrets file should contains this info (separate line each, in this order):
# <subdomain> (eg. foo.1password.com will put foo)
# <email> (email used to login)
# <secret key>
#
# Don't forget to add & at the end of each addKeyFile call to make this run faster

OP=/usr/local/bin/op
SECRETS_FILE=$HOME/.op.secrets
HELPER_PATH=$HOME/ssh-add-pass-helper.sh
DISPLAY_VAL=$DISPLAY

if [ ! -f "$SECRETS_FILE" ]; then
    echo "Secrets file '$SECRETS_FILE' does not exist!"
    exit 1
fi

if [ ! -f "$HELPER_PATH" ]; then
    echo "Helper script '$HELPER_PATH' does not exist!"
    exit 2
fi

if [ -z "$DISPLAY_VAL" ]; then
	echo "WARN: \$DISPLAY is empty, will run with DISPLAY=1 for ssh-add to work."
	DISPLAY_VAL=1
fi

which -s jq || { echo "jq not found, won't be able to parse json, 'brew install jq' or install it by hand."; exit 3; }

SIGNIN_SUBDOMAIN=$(sed '1q;d' "$SECRETS_FILE")
SIGNIN_EMAIL=$(sed '2q;d' "$SECRETS_FILE")
SECRET_KEY=$(sed '3q;d' "$SECRETS_FILE")
SIGNIN_ADDRESS="${SIGNIN_SUBDOMAIN}.1password.com"

function addKeyFile() {
    local keyfile="$1"
    local pwd_name="$2"

    echo "Trying to fetch $pwd_name from 1Password ..."

    local passphrase=$($OP get item "$pwd_name" --session="$SESSION" | jq -r '.details.password') # .details.password works for Password type item (NOT Login)

    echo "$passphrase" | DISPLAY="$DISPLAY_VAL" SSH_ASKPASS="$HELPER_PATH" ssh-add -q -c "$keyfile" 2>/dev/null
    local ret=$?

    if [ "$ret" -ne 0 ]; then
        echo "Unable to add $keyfile - return code: $ret"
    else echo "Keyfile "$keyfile" added successfully."
    fi
}

# try an update to show a warning if op is out of date
$OP update

# using raw session cause eval is evil
SESSION=$($OP signin "$SIGNIN_ADDRESS" "$SIGNIN_EMAIL" "$SECRET_KEY" --output=raw) || exit $?

# copy as many of these lines as needed
# first parameter is path to the ssh private key
# second parameter is name of the item in 1Password - never tested a non-unique match in search, make it unique :)
addKeyFile "$HOME/.ssh/ii_rsa_somename" "SSH_KEY_PASSPHRASE_id_rsa_somename" &

wait

$OP signout --session="$SESSION"

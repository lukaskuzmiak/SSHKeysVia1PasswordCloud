# SSHKeysVia1PasswordCloud

Successor of https://github.com/lukaskuzmiak/SSHKeysVia1Password

A (less) desperate attempt to ssh-add all my SSH keys to SSH agent on MacOS using passphrases saved in 1Password.

## Prerequisites

* 1Password Command Line tool (https://support.1password.com/command-line-getting-started/)

## Usage

Put ```ssh-add-pass-helper.sh``` into your $HOME directory.

Adjust last lines of ```SSHKeysVia1PasswordCloud.sh``` to fit your SSH keys paths and 1Password item names - I use "Password" type for this, for any other you need to adjust the ```jq``` parsing routine in the code.

## Miscellaneous

Any code improvements and/or security concerns are more than welcome.

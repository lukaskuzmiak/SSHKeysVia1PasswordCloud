# SSHKeysVia1PasswordCloud

Successor of https://github.com/lukaskuzmiak/SSHKeysVia1Password

A (less) desperate attempt to ssh-add all my SSH keys to SSH agent on MacOS using passphrases saved in 1Password.

## Prerequisites

* 1Password Command Line tool (https://support.1password.com/command-line-getting-started/)
* https://github.com/theseal/ssh-askpass - optional, but really, you _should_ use this. Ssh-agent without confirmation of key use **can be dangerous**.

## Usage

Put ```ssh-add-pass-helper.sh``` into your $HOME directory.

Create ```$HOME/.op.secrets``` in the following format (line-by-line, in this order):

```
<subdomain> (eg. foo.1password.com will put foo)
<email> (email used to login)
<secret key>
```

Adjust last lines of ```SSHKeysVia1PasswordCloud.sh``` to fit your SSH keys paths and 1Password item names - I use "Password" type for this, for any other you need to adjust the ```jq``` parsing routine in the code.

## Miscellaneous

Any code improvements and/or security concerns are more than welcome.

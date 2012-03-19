#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: ./sign.sh REPO_CODENAME [signing user]">&2
    exit 1
fi

user=""
[ -n "$SUDO_USER" ] &&
    user=$SUDO_USER
[ -n "$2" ] &&
    user=$2

su $user -c "gpg -abs -o ~/Release.gpg /var/repo/apt/dists/$1/Release"
mv ~$user/Release.gpg /var/repo/apt/dists/$1/Release.gpg
chown root:root /var/repo/apt/dists/$1/Release.gpg

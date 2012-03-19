#!/bin/sh

su richo -c "gpg -abs -o ~/Release.gpg /var/repo/apt/dists/sid/Release"
mv ~richo/Release.gpg /var/repo/apt/dists/sid/Release.gpg
chown root:root /var/repo/apt/dists/sid/Release.gpg

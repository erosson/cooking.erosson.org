#/usr/bin/env sh
set -eu
cp -n ~/.bashrc ~/.bashrc.original
cp ~/.bashrc.original ~/.bashrc
cat .gp/bashrc >> ~/.bashrc
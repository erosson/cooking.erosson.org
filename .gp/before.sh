#/usr/bin/env sh
set -eu
cd cooking.erosson.org
cp -n ~/.bashrc ~/.bashrc.original
cp ~/.bashrc.original ~/.bashrc
cat .gp/bashrc >> ~/.bashrc
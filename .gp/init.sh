#!/usr/bin/env sh
set -eu
WORKSPACE=`pwd`
TEMPDIR=`mktemp -d`
cd $TEMPDIR
wget https://github.com/cooklang/CookCLI/releases/download/v0.1.4/CookCLI_0.1.4_linux_amd64.zip
unzip CookCLI*.zip
mkdir -p $WORKSPACE/bin/
mv cook $WORKSPACE/bin/
cd -
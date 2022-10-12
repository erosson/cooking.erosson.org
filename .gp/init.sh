#!/usr/bin/env sh
set -eu
cd cooking.erosson.org
WORKSPACE=`pwd`
TEMPDIR=`mktemp -d`
cd $TEMPDIR
wget https://github.com/cooklang/CookCLI/releases/download/v0.1.4/CookCLI_0.1.4_linux_amd64.zip
unzip CookCLI*.zip
mkdir -p $WORKSPACE/bin/
mv cook $WORKSPACE/bin/

wget https://github.com/cue-lang/cue/releases/download/v0.4.3-beta.1/cue_v0.4.3-beta.1_linux_amd64.tar.gz
tar xvfz cue*
mv cue $WORKSPACE/bin/
cd -

yarn install
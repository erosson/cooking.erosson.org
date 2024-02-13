#!/bin/sh
# which pandoc || (sudo apt-get update && sudo apt-get install -y pandoc)
# non-root install, to support cloudflare pages...
rm -rf vendor
wget -O /tmp/pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-linux-amd64.tar.gz
mkdir vendor
cd vendor
tar xvfz /tmp/pandoc.tar.gz
mv pandoc*/bin/pandoc .

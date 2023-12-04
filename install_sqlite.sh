#!/bin/bash
VERSION=$1
cd ~/workdir
wget https://www.sqlite.org/2023/sqlite-src-${VERSION}.zip
unzip sqlite-src-${VERSION}.zip
cd sqlite-src-${VERSION}
./configure --enable-fts5
make
sudo make install

#!/bin/bash
VERSION=$1
mkdir ~/workdir
cd ~/workdir
curl -O https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
tar xjf postgresql-${VERSION}.tar.bz2
cd postgresql-${VERSION}
./configure --prefix ~/workdir/db
make

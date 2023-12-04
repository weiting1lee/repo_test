#!/bin/bash
mkdir ~/workdir
cd ~/workdir
curl -O https://ftp.postgresql.org/pub/source/v$1/postgresql-$1.tar.bz2
tar xjf postgresql-$1.tar.bz2
cd postgresql-$1
./configure --prefix ~/workdir/db
make

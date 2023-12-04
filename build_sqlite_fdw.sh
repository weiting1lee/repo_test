#!/bin/bash
VERSION=$1
cd ~/workdir/postgresql-${VERSION}/contrib
git clone https://github.com/pgspider/sqlite_fdw.git
cd sqlite_fdw
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
make

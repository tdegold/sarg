#!/usr/bin/env sh
MAXIMA_VER=5.46.0
# setup maxima dir
wget -O maxima-$MAXIMA_VER.tar.gz https://sourceforge.net/projects/maxima/files/Maxima-source/$MAXIMA_VER-source/maxima-$MAXIMA_VER.tar.gz/download
tar -xvf maxima-$MAXIMA_VER.tar.gz
cd maxima-$MAXIMA_VER/
# run configure
sh ./configure --enable-sbcl-exec
# compile and install
make
#make check
make install
# cleanup
cd ..
rm -rf ./maxima*

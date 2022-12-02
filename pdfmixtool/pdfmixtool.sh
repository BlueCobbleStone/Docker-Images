#!/usr/bin/env bash

cd /root
git clone https://gitlab.com/scarpetta/pdfmixtool
cd ./pdfmixtool
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make
make install
#!/bin/sh -x

cd "$(dirname "$0")"
for i in *.zip;  do unzip $i; done >unpack.log

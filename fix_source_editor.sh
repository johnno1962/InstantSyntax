#!/bin/bash -x
#
# call script with path mentioned in error to fix source editor

PLUGIN="${1:?Usage: $0 <Path to plugin>}"
PLUGIN="$(echo "$PLUGIN" | sed s/Index.noindex//)"
ln -sf $PLUGIN $1

#!/bin/bash
INSTALLFOLDER="$HOME/texmf"
mkdir -p "$INSTALLFOLDER"
cp -r doc tex "$INSTALLFOLDER/"
texhash "$INSTALLFOLDER"
exit 0

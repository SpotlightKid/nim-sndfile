#!/bin/bash

PROJECT="sndfile"
REPO_URL="https://github.com/SpotlightKid/nim-sndfile"
DOC_DIR="$(pwd)/.gh-pages"

nimble doc \
    --index:on \
    --project \
    --git.url:"$REPO_URL" \
    --git.commit:master \
    --out:"$DOC_DIR" \
    src/$PROJECT.nim
cp "$DOC_DIR"/$PROJECT.html "$DOC_DIR"/index.html
xdg-open file://"$DOC_DIR"/index.html

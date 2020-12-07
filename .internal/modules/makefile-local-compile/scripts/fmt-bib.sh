#!/usr/bin/env bash
GREEN=$(tput setaf 82 2>/dev/null)
RESET=$(tput sgr0 2>/dev/null)

function _inline_replace() { if ! sed -i -E '' "$1" "$2" &>/dev/null; then sed -i -E "$1" "$2"; fi; }

for bib in ./lib/*.bib; do
  _inline_replace "s/\{\\\\_\}/_/g" "$bib"
  echo -en "${GREEN}Updated $bib!${RESET}\n"
done

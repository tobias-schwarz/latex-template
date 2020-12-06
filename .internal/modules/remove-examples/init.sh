#!/usr/bin/env bash
export MODULE_NAME="Remove Examples"
export MODULE_DESCRIPTION="Remove all examples from the latex template project for advanced latex users."

function _inline_replace() { if ! sed -i '' "$1" "$2" &>/dev/null; then sed -i  "$1" "$2"; fi; }

function install() {
  rm -rf "./examples"
  _inline_replace 's/\\input{examples\/cheat_sheet.tex}//g' "main.tex"
  return 0
}

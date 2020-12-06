#!/usr/bin/env bash
export MODULE_NAME="Homework Style"
export MODULE_DESCRIPTION="Switch the template to a less scientific homework style, removing most appendix and sources from the template.
Some features may be re-enabled in the main.tex file by uncommenting them."

function _inline_replace() { if ! sed -i -E '' "$1" "$2" &>/dev/null; then sed -i -E "$1" "$2"; fi; }

function install() {
  DISABLED_TEMPLATE_FEATURES=(
    "configIncludeTitlePage"
    "configIncludeTableOfContents"
    "configIncludeAbbreviations"
    "configIncludeListOfFigures"
    "configIncludeListOfTables"
    "configIncludeAppendix"
    "configIncludeBib"
    "configIncludeAuthorStatement"
  )

  for template_part in "${DISABLED_TEMPLATE_FEATURES[@]}"; do
    sed_replace_string=$(
      printf "s/%s/%s/g" \
        "\\\\newcommand\{\\\\$template_part\}\{.*\}" \
        "\\\\newcommand{\\\\$template_part\}\{false\}"
    )
    _inline_replace "$sed_replace_string" "src/config.tex"
  done
  return 0
}

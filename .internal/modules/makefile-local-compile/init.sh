#!/usr/bin/env bash
export MODULE_NAME="Makefile [compile|clean]"
export MODULE_DESCRIPTION="Installs the makefile goals 'compile', which uses the local latex installation to compile the
project, and 'clean' to clean the local build directories."

function install() {
    mkdir -p scripts && cp "$2/scripts/compile-local.sh" .internal/scripts/compile-local.sh
    cat "$2/Makefile" >> Makefile
    return 0
}

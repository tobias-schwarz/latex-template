#!/usr/bin/env bash
export MODULE_NAME="Makefile [docker]"
export MODULE_DEPENDENCIES="makefile-local-compile"
export MODULE_DESCRIPTION="Installs the makefile goal 'docker', which uses a local docker cli to execute the latex
compilation inside a docker container."

function install() {
    mkdir -p scripts && cp "$2/scripts/compile-docker.sh" ./scripts/compile-docker.sh
    cat "$2/Makefile" >> Makefile
    return 0
}

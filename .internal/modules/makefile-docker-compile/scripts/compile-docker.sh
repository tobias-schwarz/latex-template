#!/usr/bin/env bash
OUTPUT_DIR=${OUTPUT_DIR:-output}
GREEN=$(tput setaf 82 2>/dev/null)
LIGHT_RED=$(tput setaf 9 2>/dev/null)
GRAY=$(tput setaf 247 2>/dev/null)
RESET=$(tput sgr0 2>/dev/null)

if ! hash docker 2>/dev/null; then
    echo -en "${LIGHT_RED}Could not find docker client in path${RESET}!\n"
    exit 1
fi

if ! docker ps &>/dev/null; then
    echo -en "${LIGHT_RED}Docker client could not connect to docker daemon!${RESET}!\n"
    exit 1
fi

directory="$(
    cd "$(dirname "$0")/../.." || exit
    pwd -P
)" # Fetches the parents parent directory of the scripts directory (which should be the project root)

if hash wslpath 2>/dev/null; then # Enable windows WSL users to convert the path into windows paths
    directory="$(wslpath -w "$directory")"
fi

if [[ ! -d ${OUTPUT_DIR} ]]; then
    echo -en "${GRAY}Creating output directory..."
    mkdir "${OUTPUT_DIR}" || exit 1
    echo -en "Done!${RESET}\n"
fi

echo -en "${GREEN}Starting docker compiler...${RESET}\n"

docker run --rm -v "$directory:/home/latex/" aergus/latex \
    /bin/bash -c "cd /home/latex; make compile"

echo -en "${GREEN}Done${RESET}!\n"

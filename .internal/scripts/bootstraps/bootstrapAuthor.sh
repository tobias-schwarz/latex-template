#!/usr/bin/env bash
export BOOTSTRAP_QUESTION="Please provide the full name of the author"
export BOOTSTRAP_FORMAT="\
[${ARG_COLOR}TITLE${RESET}] \
${ARG_COLOR}FIRSTNAME${RESET} \
[${ARG_COLOR}MIDDLE_NAME${RESET}] \
${ARG_COLOR}LASTNAME${RESET}"
export BOOTSTRAP_EXAMPLES=("Max Mustermann" "Tobias Sören Koll")

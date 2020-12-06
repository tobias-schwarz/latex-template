#!/usr/bin/env bash
export BOOTSTRAP_QUESTION="Please provide the title as well as the full name of your companies advisor for this paper"
export BOOTSTRAP_FORMAT="\
[${ARG_COLOR}TITLE${RESET}] \
${ARG_COLOR}FIRSTNAME${RESET} \
[${ARG_COLOR}MIDDLE_NAME${RESET}] \
${ARG_COLOR}LASTNAME${RESET}"
export BOOTSTRAP_EXAMPLES=("Ginni Rometty" "Bill Gates")

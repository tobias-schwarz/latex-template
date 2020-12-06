#!/usr/bin/env bash
# We cannot use the env.sh file, as this download script has to be self contained for accessing it from the git remote

# Hard coded variables
LATEX_TEMPLATE_HTTPS_GIT=https://github.com/tobias-schwarz/latex-template.git
GIT_MODULE_BRANCH="feature/module-core"
BOOTSTRAP_FOLDER="./.internal/scripts/bootstraps"

# Colors
RESET=$(tput sgr0 2>/dev/null)
BU=$(tput smul 2>/dev/null)
AQUA=$(tput setaf 14 2>/dev/null)
PINK=$(tput setaf 13 2>/dev/null)
ARG_COLOR=$(tput setaf 197 2>/dev/null)
DARK_AQUA=$(tput setaf 6 2>/dev/null)
LIGHT_RED=$(tput setaf 9 2>/dev/null)
GREEN=$(tput setaf 82 2>/dev/null)
DARK_GREEN=$(tput setaf 2 2>/dev/null)
GRAY=$(tput setaf 247 2>/dev/null)
BOLD=$(tput bold 2>/dev/null)
BLUE=$(tput setaf 4 2>/dev/null)
GOLD=$(tput setaf 11 2>/dev/null)

# Utility methods
# Cecho joins all provided strings together, resetting colour between each.
function cecho() {
    output_string=""
    for var in "$@"; do
        output_string+=${var}${RESET}
    done
    echo -en "$output_string"
}

# An inline replace function that works both on BSD and GNU sed
function _inline_replace() {
    if ! sed -i -E "" "$1" "$2" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then sed -i -E "$1" "$2"; fi
}
function requireGitConfig() { if ! git config "$1" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then
    NEW_VALUE=""
    cecho "You do not have your git ${LIGHT_RED}$1" " configured. Please enter it right now: "
    read -r NEW_VALUE
    git config "$1" "${NEW_VALUE}"
fi; }

# Cursor utility
function _reset_line_counter() { PRINTED_LINES=0; }
function _increase_line_counter() { PRINTED_LINES=$((PRINTED_LINES + $1)); }
function _rollback_line_counter() {
    for ((i = 0; i < $((PRINTED_LINES)); i++)); do echo -en "\033[1A\033[K"; done
    if [ "${PRINTED_LINE:=0}" -gt 0 ]; then echo -en "\033[1A"; fi
}

# Sets up the shared boostrap variables
function _setup_bootstrap_vars() {
    BOOTSTRAP_QUESTION=""
    BOOTSTRAP_FORMAT=""
    BOOTSTRAP_EXAMPLES=""
}

# Asks the provided cecho question and returns 0 if it was answered with yes, else 1.
# $1 the cecho style question
function cecho_yes_no() {
    cecho "$@"
    answer=""
    read -r answer
    if [[ ${answer} =~ ^[Yy]$ || -z ${answer} ]]; then
        return 0
    fi
    return 1
}

# Prints a separator line to the screen with the provided length.
# $1: the length in characters.
function _separator_line() {
    for ((i = 0; i < $1; ++i)); do
        printf "━"
    done
}

# Prints a new topic.
# A topic represents a type of setup, e.g. git configuration or project names.
function new_topic() {
    local TOTAL_PRINTING_CHARACTERS=$(($(tput cols) * 2 / 5))
    local TOTAL_SEPARATORS=$((TOTAL_PRINTING_CHARACTERS - ${#2}))
    local SEPARATOR_AMOUNT=$((TOTAL_SEPARATORS / 2))

    printf "%s" "${BOLD}"
    _separator_line "$SEPARATOR_AMOUNT"
    cecho "$1$2"
    printf "%s" "${BOLD}"
    _separator_line "$SEPARATOR_AMOUNT"
    if [[ ! $((TOTAL_SEPARATORS % 2)) -eq 0 ]]; then
        printf "━"
    fi
    echo -e "${RESET}"

    echo "Started $2" >>"${DHBW_BOOTSTRAP_LOG}"
}

export DHBW_BOOTSTRAP_LOG=$(mktemp /tmp/dhbw-latex-bootstrap.XXXXXX)
if [[ -z "${DHBW_BOOTSTRAP_LOG}" ]]; then
    cecho "${LIGHT_RED}Missing a \"tmp\" folder!\n"
    cecho "${LIGHT_RED}Create one using: \n"
    cecho "${LIGHT_RED}  sudo mkdir /tmp; sudo chmod 1777 /tmp\n"
    exit 1
fi

clear                                                 # Clear screen
new_topic "${AQUA}" "[DHBW LaTeX Template Generator]" # Print title

# Checking for the required tools on the machine, mostly git.
if ! hash git 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then
    cecho "Could not find ${LIGHT_RED}git" " on your machine\n"
    exit 1
fi

# Request remote git repository in which the project will live
REMOTE_GIT_REPOSITORY=$1
if [[ -z ${REMOTE_GIT_REPOSITORY} ]]; then
    cecho "${GRAY}Keep the following empty, if you do not plan on hosting the project on a remote.\n"
    cecho "Please provide the projects remote ${AQUA}${BU}git repository url" ": "
    read -r REMOTE_GIT_REPOSITORY
fi
if [[ -z ${REMOTE_GIT_REPOSITORY} ]]; then
    cecho "The project will ${LIGHT_RED}not" " be hosted at any repository.\n"
else
    cecho "The project will be hosted at: " "${AQUA}${BU}${REMOTE_GIT_REPOSITORY}" ".\n"
fi

new_topic "${AQUA}" "[Project Name]"
PROJECT_NAME=$(echo "${REMOTE_GIT_REPOSITORY:=latex-project.git}" | rev | cut -d "/" -f 1 | cut -c 5- | rev) # parse project name from git remote.

if [[ -z "${REMOTE_GIT_REPOSITORY}" ]]; then # If no git repository is provided, ask the name instantly
    cecho "Please provide the ${AQUA}${BU}project name" ": "
    read -r PROJECT_NAME
fi
while ! (cecho_yes_no "Do you want to use ${AQUA}${BU}${PROJECT_NAME}" " as your project name" " ${DARK_GREEN}[y/n]" "? "); do
    cecho "Please provide the ${AQUA}${BU}project name" ": "
    read -r PROJECT_NAME
done

# Start cloning the template.
new_topic "${GOLD}" "[Cloning the project]"
cecho "${GOLD}Cloning" " the latest latex template to ${GOLD}${BU}${PROJECT_NAME}${RESET}..."

if ! git clone ${LATEX_TEMPLATE_HTTPS_GIT} "${PROJECT_NAME}" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then
    cecho "${LIGHT_RED}Could not clone the repository! Please report this error if you cannot solve it!\n"
    exit 1
fi

# Update the projects git remotes. The official latex template will be kept as the 'upstream' remote.
# The prior provided git repository is set as 'origin'.
cd "${PROJECT_NAME}" || exit 1
git remote add upstream ${LATEX_TEMPLATE_HTTPS_GIT} 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
git fetch upstream -p 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
if [[ -z ${REMOTE_GIT_REPOSITORY} ]]; then
    git remote remove origin 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
else
    git remote set-url origin ${REMOTE_GIT_REPOSITORY} 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
    git fetch origin -p 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
fi

# Rebase onto default branch (usually module core).
# This attempts to rebase the latex template main onto its own module core branch
if ! git rebase "upstream/${GIT_MODULE_BRANCH}" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then
    cecho "${LIGHT_RED}Could not rebase module branch. Please report this error if you cannot solve it!\n"
    exit 1
fi
cecho "${GOLD}${BU}Done!\n"

# Bootstrap everything
new_topic "${BLUE}" "[Bootstrap Project]"
cecho "The " "${BLUE}bootstrap" " process will define the general context of this paper.\n"
cecho "For example, your name, the paper title etc.\n"
cecho "If a question is not applicable to your paper, simply enter nothing and continue\n".

BOOTSTRAP_ORDER=$(cat "${BOOTSTRAP_FOLDER}/order.txt") # The order.txt file lists the individual bootstrap files in the correct oder.

_reset_line_counter
for bootstrap_name in ${BOOTSTRAP_ORDER}; do
    _rollback_line_counter
    _reset_line_counter
    file_path="${BOOTSTRAP_FOLDER}/${bootstrap_name}.sh"

    _setup_bootstrap_vars
    source "$file_path" # load in boostrap variables.

    if [ ! ${#BOOTSTRAP_EXAMPLES[@]} -eq 0 ]; then # Print potential examples defined by the boostrap step.
        cecho "${GRAY}Examples:\n" && _increase_line_counter 1
        for example in "${BOOTSTRAP_EXAMPLES[@]}"; do
            cecho "${GRAY} - ${example}\n" && _increase_line_counter 1
        done
    fi
    if [ -n "$BOOTSTRAP_FORMAT" ]; then # Print potential format defined by the boostrap step.
        cecho "${GRAY}Format: ${RESET}$BOOTSTRAP_FORMAT\n" && _increase_line_counter 1
    fi
    cecho "${BLUE}${BOLD}${BOOTSTRAP_QUESTION}: " && _increase_line_counter 1
    read -r bootstrap_answer
    bootstrap_answer=$(printf "%q" "${bootstrap_answer}")

    sed_replace_string=$(
        printf "s/%s/%s/g" \
            "\\\\newcommand\{\\\\$bootstrap_name\}\{.*\}" \
            "\\\\newcommand{\\\\$bootstrap_name\}\{$bootstrap_answer\}"
    )
    _inline_replace "$sed_replace_string" "src/config.tex" # replace the prior setting in the config.tex file
done

# Commit bootstrap
requireGitConfig "user.name"
requireGitConfig "user.email"
git add . 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
git commit -am "Bootstrap the project configuration" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1

# Install modules
new_topic "${GREEN}" "[Modules]"
if cecho_yes_no "Do you want to install any extra ${GREEN}modules" " ${DARK_GREEN}[y/n]" "? "; then
    ./.internal/scripts/install-modules.sh # run module installer.
fi

new_topic "${GREEN}" "Finished bootstrap"
cecho "${GRAY}The debug logs are available at ${DHBW_BOOTSTRAP_LOG}\n"
cecho "${GREEN}Enjoy working on your paper\n"

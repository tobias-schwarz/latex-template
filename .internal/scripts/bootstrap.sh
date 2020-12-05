#!/usr/bin/env bash
# We cannot use the env.sh file, as this download script has to be self contained for accessing it from the git remote

# Hard coded variables
LATEX_TEMPLATE_HTTPS_GIT=https://github.com/tobias-schwarz/latex-template.git
GIT_DEFAULT_BRANCH="feature/module-core"

# Colors
RESET=$(tput sgr0 2>/dev/null)
BU=$(tput smul 2>/dev/null)
AQUA=$(tput setaf 14 2>/dev/null)
PINK=$(tput setaf 13 2>/dev/null)
DARK_AQUA=$(tput setaf 6 2>/dev/null)
LIGHT_RED=$(tput setaf 9 2>/dev/null)
GREEN=$(tput setaf 82 2>/dev/null)
DARK_GREEN=$(tput setaf 2 2>/dev/null)
GRAY=$(tput setaf 247 2>/dev/null)
BOLD=$(tput bold 2>/dev/null)
BLUE=$(tput setaf 4 2>/dev/null)
GOLD=$(tput setaf 11 2>/dev/null)

# Utility methods
function cecho() {
  output_string=""
  for var in "$@"; do
    output_string+=${var}${RESET}
  done
  echo -en "$output_string"
}

function _inline_replace() { if ! sed -i -E '' "$1" "$2" &>/dev/null; then sed -i -E "$1" "$2"; fi; }

function cecho_yes_no() {
  cecho "$@"
  answer=""
  read -r answer
  if [[ ${answer} =~ ^[Yy]$ || -z ${answer} ]]; then
    return 0
  fi
  return 1
}

function new_topic() {
  local TOTAL_PRINTING_CHARACTERS=$(($(tput cols) * 2 / 5))
  local TOTAL_SEPARATORS=$((TOTAL_PRINTING_CHARACTERS - ${#2}))
  local SEPARATOR_AMOUNT=$((TOTAL_SEPARATORS / 2))

  printf "%s" "${BOLD}"
  for ((i = 0; i < SEPARATOR_AMOUNT; ++i)); do
    printf "━"
  done
  cecho "$1$2"
  printf "%s" "${BOLD}"
  for ((i = 0; i < SEPARATOR_AMOUNT; ++i)); do
    printf "━"
  done
  if [[ ! $((TOTAL_SEPARATORS % 2)) -eq 0 ]]; then
    printf "━"
  fi
  echo -e "${RESET}"
}

new_topic "${AQUA}" "[DHBW LaTeX Template Generator]"

# Checking for the required tools on the machine, mostly git
if ! hash git &>/dev/null; then
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
PROJECT_NAME=$(echo "${REMOTE_GIT_REPOSITORY:=latex-project.git}" | rev | cut -d '/' -f 1 | cut -c 5- | rev)

if [[ -z "${REMOTE_GIT_REPOSITORY}" ]]; then # If no git repository is provided, ask the name instantly
  cecho "Please provide the ${AQUA}${BU}project name" ": "
  read -r PROJECT_NAME
fi
while ! (cecho_yes_no "Do you want to use ${AQUA}${BU}${PROJECT_NAME}" " as your project name" " ${DARK_GREEN}[y/n]" "? "); do
  cecho "Please provide the ${AQUA}${BU}project name" ": "
  read -r PROJECT_NAME
done

new_topic "${GOLD}" "[Cloning the project]"
cecho "${GOLD}Cloning" " the latest latex template to ${GOLD}${BU}${PROJECT_NAME}...\n"

if ! git clone ${LATEX_TEMPLATE_HTTPS_GIT} "${PROJECT_NAME}"; then
  cecho "${LIGHT_RED}Could not clone the repository! Please report this error if you cannot solve it!\n"
  exit 1
fi

cd "${PROJECT_NAME}" || exit 1
git remote add upstream ${LATEX_TEMPLATE_HTTPS_GIT}
if [[ -z ${REMOTE_GIT_REPOSITORY} ]]; then
  git remote remove origin
else
  git remote set-url origin ${REMOTE_GIT_REPOSITORY}
fi
cecho "${GOLD}${BU}Done!\n"

# Install modules
new_topic "${GREEN}" "[Modules]"
if cecho_yes_no "Do you want to install any extra ${GREEN}modules" " ${DARK_GREEN}[y/n]" "? "; then
  cecho "${GREEN}Pulling module branch...\n"
  git fetch upstream "${GIT_DEFAULT_BRANCH}" >/dev/null
  git merge -q "upstream/${GIT_DEFAULT_BRANCH}" >/dev/null
  cecho "${GREEN}Done!\n"
  ./.internal/scripts/install-modules.sh
fi



new_topic "${BLUE}" "[Bootstrap Project]"
cecho "The " "${BLUE}bootstrap" " process will define the general context of this paper.\n"
cecho "For example, your name, the paper title etc.\n"

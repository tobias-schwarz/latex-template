#!/usr/bin/env bash
# Colors
RESET=$(tput sgr0 2>/dev/null)
BU=$(tput smul 2>/dev/null)
AQUA=$(tput setaf 14 2>/dev/null)
DARK_AQUA=$(tput setaf 6 2>/dev/null)
LIGHT_RED=$(tput setaf 9 2>/dev/null)
GREEN=$(tput setaf 82 2>/dev/null)
DARK_GREEN=$(tput setaf 2 2>/dev/null)
GRAY=$(tput setaf 247 2>/dev/null)
BOLD=$(tput bold 2>/dev/null)
GOLD=$(tput setaf 11 2>/dev/null)

#Module local variables
function setup_module_vars() {
    MODULE_NAME="error"
    MODULE_DESCRIPTION="none"
    MODULE_DEPENDENCIES=""
}

# This function will be overwritten by the module
function install() {
    local PROJECT_ROOT=$1
    local MODULE_ROOT=$2
}

# Utility methods
# Cecho joins all provided strings together, resetting colour between each.
function cecho() {
    output_string=""
    for var in "$@"; do
        output_string+=${var}${RESET}
    done
    echo -en "$output_string"
}

# Cursor utility
function _reset_line_counter() { PRINTED_LINES=0; }
function _increase_line_counter() { PRINTED_LINES=$((PRINTED_LINES + $1)); }
function _rollback_line_counter() {
    for ((i = 0; i < $((PRINTED_LINES)); i++)); do echo -en "\033[1A\033[K"; done
    if [ "${PRINTED_LINE:=0}" -gt 0 ]; then echo -en "\033[1A"; fi
}

# Prints a single box character to the console.
# $1: the current index of the box, starting from 0
# $2: the maximum length of the box.
function print_box_char() {
    last=$(($2 - 1))

    if [[ $2 == 1 ]]; then
        cecho "${BOLD}["
        return 0
    fi

    if [[ $1 == 0 ]]; then
        cecho "┏"
    elif [[ $1 == "${last}" ]]; then
        cecho "┗"
    else
        cecho "┃"
    fi
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

# Shared constant representing the last output of the method below.
CECHO_NUMBER_OR_END_OUT=""
function cecho_number_or_end() {
    cecho "$@"
    answer=""
    read -r answer
    if [[ ${answer} =~ ^[0-9]+$ || "${answer}" != "exit" ]]; then
        CECHO_NUMBER_OR_END_OUT="${answer}"
        return 0
    fi
    return 1
}

# Prints a specific module header.
# $1: The colour of the header
# $2: The module name to print
function new_module_info() {
    TEXT_TO_PRINT="<<{{ $2 }}>>"
    local TOTAL_PRINTING_CHARACTERS=$(($(tput cols) * 2 / 5))
    local TOTAL_SEPARATORS=$((TOTAL_PRINTING_CHARACTERS - ${#TEXT_TO_PRINT}))
    local SEPARATOR_AMOUNT=$((TOTAL_SEPARATORS / 2))
    local SEPARATOR_AMOUNT_HALFED=$((SEPARATOR_AMOUNT / 2))

    printf "%s" "${BOLD}"
    for ((i = 0; i < SEPARATOR_AMOUNT; ++i)); do
        if [[ "$i" -ge "$SEPARATOR_AMOUNT_HALFED" ]]; then
            printf "─"
        else
            printf " "
        fi
    done
    cecho "$1$TEXT_TO_PRINT"
    printf "%s" "${BOLD}"
    for ((i = 0; i < SEPARATOR_AMOUNT; ++i)); do
        if [[ "$i" -le "$SEPARATOR_AMOUNT_HALFED" ]]; then
            printf "─"
        else
            printf " "
        fi
    done
    if [[ ! $((TOTAL_SEPARATORS % 2)) -eq 0 ]]; then
        printf " "
    fi
    echo -e "${RESET}"
}

# Ensures that a specific git config value is set, else requests it.
# $1: the git config key.
function requireGitConfig() {
    if ! git config "$1" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1; then
        NEW_VALUE=""
        cecho "You do not have your git ${LIGHT_RED}$1" " configured. Please enter it right now: "
        read -r NEW_VALUE
        git config "$1" "${NEW_VALUE}"
    fi
}

# Commits any current changes in the repository.
# $1: The module name that is responsible for this change
# $2: The description of the module. This is included in the commit body.
function commitChanges() {
    git add .

    echo -en "Install module $1\n\nThis commit installs the $1 module onto the latex project.\n\n$2" >_commit.txt
    git commit --file _commit.txt
    rm -f _commit.txt
}

# Reads the variables of a specific module.
# $1: the folder name of the module. This is not the display name.
function _readModuleVars() {
    setup_module_vars

    # shellcheck source="${DHBW_BOOTSTRAP_LOG}"
    source "$1/init.sh"
    return 0
}

# Splits a string by the § delimiter.
# $1: the index of the split result that is returned (echoed) by this function
# $2: the entire string to split.
function _splitBy() {
    IFS=$'§' read -r -a output <<<"$2"
    echo "${output[$1]}"
}

# Installs a specific module into the repository.
# $1: the directly of the module to install.
# $2: either an empty string or 'force'. 'force' will install the module without asking for permission.
function _installModule() {
    _readModuleVars "$1"

    MODULE_DESCRIPTION=$(fmt -w 72 < <(printf "%s\n" "$MODULE_DESCRIPTION"))
    IFS=$'\n' read -rd '' -a MODULE_DESCRIPTION_ARRAY <<<"${MODULE_DESCRIPTION}"

    IFS=$',' read -r -a MODULE_DEPENDENCIES_ARRAY <<<"${MODULE_DEPENDENCIES}"

    if [[ ! $2 == "force" ]]; then # If it isn't a forced installation, print module info
        new_module_info "${GREEN}" "${MODULE_NAME}" && _increase_line_counter 1

        cecho "${GREEN}Description: \n" && _increase_line_counter 1
        MODULE_DESCRIPTION_LENGTH=${#MODULE_DESCRIPTION_ARRAY[@]}
        for ((i = 0; i < MODULE_DESCRIPTION_LENGTH; ++i)); do
            print_box_char ${i} "${MODULE_DESCRIPTION_LENGTH}"
            cecho " ${MODULE_DESCRIPTION_ARRAY[$i]}\n" && _increase_line_counter 1
        done

        if [[ -n "${MODULE_DEPENDENCIES}" ]]; then
            cecho "${GREEN}Dependencies: ${MODULE_DEPENDENCIES_ARRAY[*]}\n" && _increase_line_counter 1
        fi

        _increase_line_counter 1
        if ! cecho_yes_no "Do you want to ${BOLD}install" " ${GREEN}${MODULE_NAME} module" " ${DARK_GREEN}[y/n]" "? "; then
            return 31 # 31 means that the user actively denied the installation.
        fi
    fi

    echo "Installing $MODULE_NAME module" >>"${DHBW_BOOTSTRAP_LOG}"

    # Store root project values
    local local_module_name="${MODULE_NAME}"
    local module_description="${MODULE_DESCRIPTION}"
    local module_path="$1"

    for dep in "${MODULE_DEPENDENCIES_ARRAY[@]}"; do
        if [[ -z "${dep}" ]]; then continue; fi # Catch somehow empty dependencies

        for ((i = 0; i < COMPLETE_MODULE_LENGTH; ++i)); do
            cur_module="${MODULES[i]}"
            if [[ -z "${cur_module}" ]]; then continue; fi # Catch already used modules

            cur_module_dir=$(_splitBy 1 "${MODULES[i]}") # Get path of module
            module_id=${cur_module_dir##*/}              # only last path (e.g. the folder name)

            if [[ "${module_id}" == "${dep}" ]]; then

                _installModule "${cur_module_dir}" "force" # Install the dependency using force
                unset -v 'MODULES[i]'                      # remove the dependency from the modules array
                MODULE_LENGTH=$((MODULE_LENGTH - 1))       # reduce the length cache respectively
                break
            fi
        done
    done

    _readModuleVars "$module_path"
    install "$(pwd)" "$module_path" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1 || return 1
    commitChanges "${local_module_name}" "${module_description}" 1>>"${DHBW_BOOTSTRAP_LOG}" 2>&1
}

# Require the git config to include user information. This is required for automatically committing.
requireGitConfig "user.name"
requireGitConfig "user.email"

# Ensure that there are no changes currently in the repository.
if ! git diff-index --quiet HEAD --; then
    cecho "${LIGHT_RED}You have non-committed changes in your project.\n"
    cecho "${LIGHT_RED}Modules cannot be installed until everything is committed.\n"
    exit 1
fi

# Move the current process to the latex template root this script is called in
cd "$(
    cd "$(dirname "$0")"
    pwd -P
)/../.." || exit

MODULE_ROOT=.internal/modules # The module folder.

# Read all modules into the module array.
declare -a MODULES && i=0
for CURRENT_MODULE in "${MODULE_ROOT}"/*; do
    if [[ ! -d ${CURRENT_MODULE} ]]; then
        continue
    fi
    _readModuleVars "${CURRENT_MODULE}"
    MODULES[i]="${MODULE_NAME}§${CURRENT_MODULE}"
    ((i = i + 1))
done

COMPLETE_MODULE_LENGTH=${#MODULES[@]} # finalised module length cache
MODULE_LENGTH=${#MODULES[@]}          # mutable shared module length cache

_reset_line_counter
while true; do
    realI=0 # realI represents the actual length without removed modules of the module array.

    _rollback_line_counter
    _reset_line_counter

    cecho "${GREEN}What" " ${DARK_GREEN}modules" " ${GREEN}do you want to install" "?\n" && _increase_line_counter 1

    for ((i = 0; i < COMPLETE_MODULE_LENGTH; ++i)); do # Iterate over every known module, excluding those already installed.
        if [[ -z "${MODULES[i]}" ]]; then continue; fi

        start_char="┣"
        if [[ ${realI} -eq "0" ]]; then start_char="┏"; fi
        if [[ ${realI} -eq "$((MODULE_LENGTH - 1))" ]]; then start_char="┗"; fi
        if [[ ${#MODULES[@]} == 1 ]]; then start_char="━"; fi

        cecho " ${GRAY}${start_char}" "${DARK_GREEN}$(_splitBy 0 "${MODULES[i]}")" " (${i})\n" && _increase_line_counter 1

        realI=$((realI + 1))
    done

    # If 1 is returned, break. This means "end" was entered.
    _increase_line_counter 1
    if ! cecho_number_or_end "${GRAY}Enter the number of the module to install, or 'exit' to exit: "; then
        break
    fi

    # if empty string or not a number, restart this while loop and ask again
    if [[ -z "${CECHO_NUMBER_OR_END_OUT}" || ! "${CECHO_NUMBER_OR_END_OUT}" =~ ^[0-9]+$ ]]; then
        cecho "${LIGHT_RED}Please provide a valid module id!\n" && _increase_line_counter 1
        continue
    fi

    TARGET_MODULE=${MODULES[CECHO_NUMBER_OR_END_OUT]}
    if [[ -z "${TARGET_MODULE}" ]]; then
        cecho "${LIGHT_RED}Please provide a valid module id!\n" && _increase_line_counter 1
        continue
    fi

    _installModule "$(_splitBy 1 "${TARGET_MODULE}")" # Actually install the module
    if [ ! $? -eq 31 ]; then # not 31 means the user installed the module
        unset -v 'MODULES[CECHO_NUMBER_OR_END_OUT]'
        MODULE_LENGTH=$((MODULE_LENGTH - 1))
    fi

    if [[ ${#MODULES[@]} == 0 ]]; then # If no modules are left, end the installer.
        break
    fi
done

#!/usr/bin/env bash
GREEN=$(tput setaf 82 2>/dev/null)
LIGHT_RED=$(tput setaf 9 2>/dev/null)
GRAY=$(tput setaf 247 2>/dev/null)
RESET=$(tput sgr0 2>/dev/null)

(hash pdflatex 2>/dev/null && hash biber 2>/dev/null && hash pdflatex 2>/dev/null)
found_latex=$?

(hash latexmk 2>/dev/null)
found_latexmk=$?

if [[ ! -d ${OUTPUT_DIR} ]]; then
    echo -en "${GRAY}Creating output directory..."
    mkdir "${OUTPUT_DIR}" || exit 1
    echo -en "Done!${RESET}\n"
fi

if [[ "${found_latexmk}" -eq "0" ]]; then
    echo -en "${GREEN}Using latexmk..${RESET}\n"

    shell_escape=t latexmk -pdf -jobname="./${OUTPUT_DIR}/build" master.tex
elif [[ "${found_latex}" -eq "0" ]]; then
    echo -en "${GREEN}Using legacy latex..${RESET}\n"

    pdflatex --draftmode -recorder --jobname="./${OUTPUT_DIR}/build"  "master.tex"
    biber "${OUTPUT_DIR}/build"
    pdflatex --draftmode -recorder --jobname="./${OUTPUT_DIR}/build"  "master.tex"
    pdflatex -recorder --jobname="./${OUTPUT_DIR}/build"  "master.tex"
else
    echo -en "${LIGHT_RED}Could not find latex distribution${RESET}!\n"
    exit 1
fi

cp output/build.pdf master.pdf
echo -en "${GREEN}Done${RESET}!\n"



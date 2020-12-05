#!/usr/bin/env bash
export MODULE_NAME="GitLab CI"
export MODULE_DESCRIPTION="Installs a simple gitlab ci script for project hosted on gitlab.
This ci pipeline will automatically compile the latex project and provide the pdf as a job artifact."

function install() {
    cp "$2/.gitlab-ci.yml" ".gitlab-ci.yml"
    return 0
}

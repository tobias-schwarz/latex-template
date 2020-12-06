# Bash Installer

This README.md is purely for development purposes and only describes the basic layout of the scripts found in the `.internal` package. If you are **
not planning on contributing** to the template, this README.md is rather useless to you.

------------------------------------------------------------------------------------------------------------------------------------------------------

The core of the `.internal/scripts` package hosts the scripts required to install the entire latex template straight from the internet. The basic
concept of both the boostrap and modul installation is sourcing of other scripts, which define/overwrite predetermined functions or variables. The
module installer, for example, will source a modules `init.sh` file which both exports environment variables such as `MODULE_NAME` and the core
installation function `install`.

## Bootstrap

The bootstrap framework of the latex template (part of the `.internal/scripts/bootstrap.sh` script) defines individual values the user may configure
using individual `.sh` files in the `.internal/scripts/bootstraps/` folder. Bootstrap files are to be named after their value, prefixed
with `bootstrap`. For example, a bootstrap script to configure the new value `example` is to be named `bootstrapExample.sh`.  
These files may/have to export the following variables:

| Name               | Required | Description                                                        | Example                          |
|--------------------|----------|--------------------------------------------------------------------|----------------------------------|
| BOOTSTRAP_QUESTION | yes      | A single line question send to the user, prompting them to answer. | "What is you full name?"         |
| BOOTSTRAP_FORMAT   | no       | An optional format, describing how the answer is to be given.      | firstname [middle_name] lastname |
| BOOTSTRAP_EXAMPLES | no       | A bash list of example answers to the defined question.            | ("Tobias Schwarz" "Bjarne Koll") |

> The `BOOTSTRAP_FORMAT` field follows the Google command style definitions found [here](https://developers.google.com/style/code-syntax) including
> colour codes. The ARG_COLOR environment variable holds the colour used for variables. Brackets or pipes should be printed using the default colour
> ($RESET).

For a bootstrap script to be integrated into the boostrap process, two following requirements have to be met.

1. The filename of the bootstrap script **without the `.sh` file type** has to be added to the `.internal/scripts/bootstraps/order.txt`. The order of
   the txt file automatically defines when the boostrap script is to be executed.
2. A new *latex* command has to be added to the `src/config.tex` file, which is named after the bootstrap script filename **without the `.sh` file
   type**. E.g a new boostrap script called `bootstrapExampleName.sh` needs to be matched by the *latex* command definition
   ```tex
   \newcommand{\bootstrapExampleName}{Default Value}
   ```

## Modules

The module framework of the latex template follows a similar idea as the boostrap framework. Again, individual modules are defined in their own
script, this time even separated into their own folders (as seen in `.internal/modules`). The module install script is its own standalone script found
in `.internal/scripts/install-modules.sh` and will automatically be executed by the bootstrap script after all initial setup of the project is done.

Compared to the bootstrap frameworks `order.txt`, the module framework uses the folders found in the module folder to automatically parse and generate
a list of available modules to install. For this, each module defines an `init.sh` file in their respective folder as well as the folder name itself,
which has to follow [kebab case](https://en.wiktionary.org/wiki/kebab_case), and serves as the **module id**. This file is both responsible for
exporting meta information through environment variables (similar to the individual bootstrap scripts), and providing the installation logic. For this
following variables may be exposed by the `init.sh` script through exports:

| Name                | Required | Description                                                              | Example                     |
|---------------------|----------|--------------------------------------------------------------------------|-----------------------------|
| MODULE_NAME         | yes      | A straight forward name for the module.                                  | "Makefile [docker]"         |
| MODULE_DESCRIPTION  | yes      | A small description of the modules purpose.                              | "Creates docker a makefile" |
| MODULE_DEPENDENCIES | no       | A bash list of modules required. Modules are identified by folder name.  | ("makefile-base")           |

> The dependencies of a module will be installed prior to the module without requiring permission from the user.

Next to the export of metadata through environment variables, the `init.sh` file also has to define a bash function called `install`. The bash
function is executed to install the module and is responsible for copying/modifying all files in the root project to install the module's
functionality. For this the following arguments are passed to the function:

1. `$1` holds the **root directory of the template**. This also serves as the current working process in which the `init.sh` file is called. Yet to
   allow for potential directory changes, this function parameter is passed.

2. `$2` holds the **directory containing the modules `init.sh` script**. This directory should hence be used to reference files inside the module.

The module framework will automatically create a git commit after the installation process of a single module is done.

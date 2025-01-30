# configuration

# 1. List of parameters that control the behavior of the Makefile.


SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

# BUILD

# 1. Variable that refers to the build directory.


BUILD := _build
${BUILD}:
	mkdir -p $@

# SRC

# 1. Variable that refers to the source file.


SRC := locs-and-refs
SRC_ORG := ${SRC}.org
SRC_EL := ${BUILD}/${SRC}.el

# PACKAGES

# 1. Variable that refers to the list of Guix packages of the environment.


PACKAGES := guix-packages
PACKAGES_SCM := ${BUILD}/${PACKAGES}.scm

# INIT

# 1. Variable that refers to init file of the bash session in the environment.


INIT := init
INIT_BASH := ${BUILD}/${INIT}.bash

# ELISP

# 1. Variable that refers to ELisp code that should be loaded by ${EMACS}.


ELISP := elisp
ELISP_EL := ${BUILD}/${ELISP}.el

# EMACS

# 1. Variable that refers to the Emacs executable.


EMACS := emacs -Q --batch -l ${ELISP_EL}

# GUIX

# 1. Variable that refers to guix executable.


GUIX := guix

# ENVIRONMENT

# 1. List of files that form the development environment.


ENVIRONMENT := ${SRC_EL} ${INIT_BASH} ${PACKAGES_SCM} ${ELISP_EL}

# init

# 1. Makefile target that tangles necessary files.


.PHONY: init
init: ${ENVIRONMENT}
${ENVIRONMENT}: ${SRC}.org | ${BUILD}
	emacs -Q --batch $< -f org-babel-tangle &>/dev/null # ${ELISP_EL} extracted.
	${EMACS} $< -f org-babel-tangle &>/dev/null	
	mv ${SRC}.el ${INIT}.bash ${PACKAGES}.scm ${ELISP}.el ${BUILD}
	sed -i '1,2d' ${SRC_EL}

# clean

# 1. Makefile target that delete all generate files necesseary files.


.PHONY: clean
clean:
	rm -rfv _*

# env

# 1. Makefile target that starts the environment.


.PHONY: env
env:
	ALL="${ALL}"
	if [[ ! -v GUIX_ENVIRONMENT ]]; then
	  ${MAKE} init
	  if [[ "$${ALL}" == "true" ]]; then
	    ${GUIX} shell --container \
	    -F \
	    --file=${PACKAGES_SCM} \
	    --preserve='^TERM$$' \
	    -- bash --init-file ${INIT_BASH} -c "${MAKE} lint checkdoc"
	  else
	    ${GUIX} shell --container \
	    -F \
	    --file=${PACKAGES_SCM} \
	    --preserve='^TERM$$' \
	    -- bash --init-file ${INIT_BASH} -i
	  fi
	fi

# elc

# 1. Makefile target that byte compiles the package.


.PHONY: elc
SRC_ELC := ${BUILD}/${SRC}.elc
elc: ${SRC_ELC}
${SRC_ELC}: ${SRC_EL}
	${EMACS} -f batch-byte-compile $<

# lint

# 1. Makefile target that lints the package.


.PHONY: lint
LINT := lint-report
LINT_TXT := ${BUILD}/${LINT}.txt
lint: ${LINT_TXT}
${LINT_TXT}: ${SRC_EL}
	$(EMACS) $< -f package-lint-buffer > $@

# checkdoc

# 1. Makefile target that check the docstrings of the package.


.PHONY: checkdoc
CHECKDOC := checkdoc
CHECKDOC_TXT := ${BUILD}/${CHECKDOC}.txt
checkdoc: ${CHECKDOC_TXT}
${CHECKDOC_TXT}: ${SRC_EL}
	$(EMACS) --eval '(checkdoc-file "$<")' > $@

# all

# 1. Makefile target that builds, lint and checkdoc the package.


.DEFAULT_GOAL := all
.PHONY: all
all: init
	${MAKE} env ALL=true

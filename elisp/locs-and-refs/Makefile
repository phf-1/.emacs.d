# Configuration

# - List of Makefile configurations.


SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

# help

# - make help # Print this help.


.PHONY: help
help:
	grep '^# - make ' $(MAKEFILE_LIST) | sed 's/^# - make //' | awk 'BEGIN {FS = " # "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# BUILD

# - ${BUILD} is the directory under which all generated files are installed.


BUILD := _build
${BUILD}:
	mkdir -p $@

# TRACE

# - ${TRACE} is a file used to record an execution trace.


TRACE := ${BUILD}/trace.txt

# TRAP

# - ${TRAP} If something has been written to ${TRACE}, then consider that the rule failed.


TRAP := > ${TRACE}; trap 'if [[ $$? -ne 0 ]]; then cat ${TRACE}; fi' EXIT

# MAIN_ORG

# - ${MAIN_ORG} is the path to source file.


MAIN_ORG := README.org

# tangle-heading

# - make tangle-heading # Returns the path to the updated ./tangle-heading script.


.PHONY: tangle-heading
TANGLE_HEADING := ${BUILD}/tangle-heading
tangle-heading: ${TANGLE_HEADING}
${TANGLE_HEADING}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} tangle-heading ${BUILD} &> ${TRACE}
	cp -vf ${BUILD}/tangle-heading ./tangle-heading &>> ${TRACE}
	tail -n 1 ${TRACE}

# Makefile

# - make Makefile # Returns the path to the updated ./Makefile.


.PHONY: Makefile
MAKEFILE := ${BUILD}/Makefile
Makefile: ${MAKEFILE}
${MAKEFILE}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} Makefile ${BUILD} &> ${TRACE}
	cp -vf ${BUILD}/Makefile ./Makefile &>> ${TRACE}
	tail -n 1 ${TRACE}

# packages.scm

# - make packages.scm # Returns the path to the Guix packages available in the environment.


.PHONY: packages.scm
PACKAGES_SCM := ${BUILD}/packages.scm
packages.scm: ${PACKAGES_SCM}
${PACKAGES_SCM}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} packages.scm ${BUILD} &> ${TRACE}
	echo "$@"

# init.bash

# - make init.bash # Returns the path to parameters that initialize Bash in the environment.


.PHONY: init.bash
INIT_BASH := ${BUILD}/init.bash
init.bash: ${INIT_BASH}
${INIT_BASH}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} init.bash ${BUILD} &> ${TRACE}
	echo "$@"

# env

# - make env # Starts the environment.


.PHONY: env
GUIX := guix
GUIX_SHELL := ${GUIX} shell --container \
	-F \
	-N \
	--file=${PACKAGES_SCM} \
	--preserve='^TERM$$' \
	-- bash --init-file ${INIT_BASH}
env: ${PACKAGES_SCM} ${INIT_BASH}
	CMD="${CMD}"
	if [[ ! -v GUIX_ENVIRONMENT ]]; then
	  if [[ "$${CMD}" == "" ]]; then
	    ${GUIX_SHELL} -i;
	  else
	    ${GUIX_SHELL} -c "${CMD}";
	  fi
	else
	  ${CMD}
	  :
	fi

# el

# - make el # Returns the path to the elisp package.


.PHONY: el
LOCS_AND_REFS_EL := ${BUILD}/locs-and-refs.el
el: ${LOCS_AND_REFS_EL}
${LOCS_AND_REFS_EL}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} locs-and-refs.el ${BUILD} &> ${TRACE}
	[[ -s ${TRACE} ]] && exit 1
	echo "$@"

# elc

# - make elc # Returns the path to the compiled elisp package.


.PHONY: elc
LOCS_AND_REFS_ELC := ${BUILD}/locs-and-refs.elc
elc: ${LOCS_AND_REFS_ELC}
${LOCS_AND_REFS_ELC}: ${LOCS_AND_REFS_EL}
	${TRAP}
	emacs -Q --batch \
	--eval '(setq org-id-track-globally nil)' \
	--eval '(defun reb-target-binding (_sym) (error "pcre2el v1.11"))' \
	-f batch-byte-compile $< &> ${TRACE}
	[[ -s ${TRACE} ]] && exit 1
	echo "$@"

# lint

# - make lint # Returns the path to the linting report of the elisp package.


.PHONY: lint
LINT_REPORT := ${BUILD}/lint-report.txt
lint: ${LINT_REPORT}
${LINT_REPORT}: ${LOCS_AND_REFS_EL}
	${TRAP}
	emacs --batch \
	--file $< \
	--eval '(setq org-id-track-globally nil)' \
	--eval "(progn (require 'package) (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t) (package-initialize))" \
	--eval "(progn (require 'package-lint) (let ((errors (package-lint-buffer))) (when errors (message \"%s\" errors))))" &> ${TRACE}
	[[ -s ${TRACE} ]] && exit 1
	echo "$@"

# checkdoc

# - make checkdoc # Returns the path to the analysis of the docstrings of the elisp package.


.PHONY: checkdoc
CHECKDOC := ${BUILD}/checkdoc.txt
checkdoc: ${CHECKDOC}
${CHECKDOC}: ${LOCS_AND_REFS_EL}
	${TRAP}
	emacs -Q --batch \
	--eval '(setq org-id-track-globally nil)' \
	--eval '(checkdoc-file "$<")' &> ${TRACE}
	[[ -s ${TRACE} ]] && exit 1
	echo "$@"

# all

# - make all # Returns the path of the elisp package after lint, checkdoc and elc steps.


.PHONY: all
all: ${BUILD}
	${TRAP}
	${MAKE} env CMD="${MAKE} lint checkdoc elc" &> ${TRACE}
	echo ${LOCS_AND_REFS_EL}

# clean

# - make clean # Deletes all generated files.


.PHONY: clean
clean:
	rm -rfv ${BUILD}

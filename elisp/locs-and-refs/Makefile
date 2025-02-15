# Configuration
# - List of Makefile configurations.

SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

# BUILD

# - ~${BUILD}~ is the directory under which all generated files are installed.

BUILD := _build
${BUILD}:
	mkdir -vp $@

# TRACE

# - ${TRACE} is a file used to record an execution trace.

TRACE := ${BUILD}/trace.txt

# TRAP

TRAP := > ${TRACE}; trap 'if [[ $$? -ne 0 ]]; then cat ${TRACE}; fi' EXIT

# MAIN

# - ~${MAIN}~ is the name of the source file.
# - ~${MAIN_ORG}~ is the path to its Org Mode representation.

MAIN := README
MAIN_ORG := ${MAIN}.org

# tangle-heading

# - ~make tangle-heading~ builds ~${BUILD}/tangle-heading~ and ~./tangle-heading~.

.PHONY: tangle-heading
TANGLE_HEADING := ${BUILD}/tangle-heading
tangle-heading: ${TANGLE_HEADING}
${TANGLE_HEADING}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} tangle-heading ${BUILD} &> ${TRACE}
	cp -vf ${BUILD}/tangle-heading ./tangle-heading &>> ${TRACE}
	tail -n 1 ${TRACE}

# Makefile

# - ~make Makefile~ builds ~${BUILD}/Makefile~ and ~./Makefile~.

.PHONY: Makefile
MAKEFILE := ${BUILD}/Makefile
Makefile: ${MAKEFILE}
${MAKEFILE}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} Makefile ${BUILD} &> ${TRACE}
	cp -vf ${BUILD}/Makefile ./Makefile &>> ${TRACE}
	tail -n 1 ${TRACE}

# packages.scm

# - ~make packages.scm~ builds ~${BUILD}/packages.scm~ 

.PHONY: packages.scm
PACKAGES_SCM := ${BUILD}/packages.scm
packages.scm: ${PACKAGES_SCM}
${PACKAGES_SCM}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} packages.scm ${BUILD} &> ${TRACE}
	echo "$@"

# init.bash

# - ~make init.bash~ builds ~${BUILD}/init.bash~ 

.PHONY: init.bash
INIT_BASH := ${BUILD}/init.bash
init.bash: ${INIT_BASH}
${INIT_BASH}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} init.bash ${BUILD} &> ${TRACE}
	echo "$@"

# env

# - ~make env~ starts the environment.

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

# - ~make el~ builds ~${BUILD}/locs-and-refs.el~ 

.PHONY: el
LOCS_AND_REFS_EL := ${BUILD}/locs-and-refs.el
el: ${LOCS_AND_REFS_EL}
${LOCS_AND_REFS_EL}: ${MAIN_ORG} | ${BUILD}
	${TRAP}
	./tangle-heading ${MAIN_ORG} locs-and-refs.el ${BUILD} &> ${TRACE}
	sed -i '1,2d' ${LOCS_AND_REFS_EL} &>> ${TRACE}
	[[ -s ${TRACE} ]] && exit 1
	echo "$@"

# elc

# - ~make elc~ builds ~${BUILD}/locs-and-refs.elc~ 

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

# - ~make lint~ builds ~${BUILD}/lint-report.txt~ 

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

# - ~make checkdoc~ builds ~${BUILD}/checkdoc.txt~ 

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

# - ~make all~ builds the package

.DEFAULT_GOAL := all
.PHONY: all
all:
	${MAKE} env CMD="${MAKE} lint checkdoc elc"

# clean

# - ~make clean~ deletes all generated files.

.PHONY: clean
clean:
	rm -rfv ${BUILD}

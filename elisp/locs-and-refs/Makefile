SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

BUILD := _build
${BUILD}:
	mkdir -p $@

SRC := locs-and-refs
SRC_ORG := ${SRC}.org
SRC_EL := ${BUILD}/${SRC}.el

PACKAGES := guix-packages
PACKAGES_SCM := ${BUILD}/${PACKAGES}.scm

INIT := init
INIT_BASH := ${BUILD}/${INIT}.bash

ELISP := elisp
ELISP_EL := ${BUILD}/${ELISP}.el

EMACS := emacs -Q --batch -l ${ELISP_EL}

GUIX := guix

ENVIRONMENT := ${SRC_EL} ${INIT_BASH} ${PACKAGES_SCM} ${ELISP_EL}

.PHONY: init
init: ${ENVIRONMENT}
${ENVIRONMENT}: ${SRC}.org | ${BUILD}
	emacs -Q --batch $< -f org-babel-tangle &>/dev/null
	mv ${SRC}.el ${INIT}.bash ${PACKAGES}.scm ${ELISP}.el ${BUILD}
	sed -i '1,2d' ${SRC_EL}

.PHONY: clean
clean:
	rm -rfv _*

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

.PHONY: elc
SRC_ELC := ${BUILD}/${SRC}.elc
elc: ${SRC_ELC}
${SRC_ELC}: ${SRC_EL}
	${EMACS} -f batch-byte-compile $<

.PHONY: lint
LINT := lint-report
LINT_TXT := ${BUILD}/${LINT}.txt
lint: ${LINT_TXT}
${LINT_TXT}: ${SRC_EL}
	$(EMACS) $< -f package-lint-buffer > $@

.PHONY: checkdoc
CHECKDOC := checkdoc
CHECKDOC_TXT := ${BUILD}/${CHECKDOC}.txt
checkdoc: ${CHECKDOC_TXT}
${CHECKDOC_TXT}: ${SRC_EL}
	$(EMACS) --eval '(checkdoc-file "$<")' > $@

.DEFAULT_GOAL := all
.PHONY: all
all: init
	${MAKE} env ALL=true

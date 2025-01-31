# configuration
# - List of parameters that control the behavior of the Makefile.

SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

# BUILD
# - Variable that refers to the build directory.

BUILD := _build
${BUILD}:
	mkdir -p $@

# SRC
# - Variable that refers to the source file.

SRC := locs-and-refs
SRC_ORG := ${SRC}.org

# PACKAGES
# - Variable that refers to the list of Guix packages of the environment.

PACKAGES := guix-packages

# INIT
# - Variable that refers to init file of the bash session in the environment.

INIT := init

# ELISP
# - Variable that refers to ELisp code that should be loaded by ${EMACS}.

ELISP := elisp

# ENV_FILES
# - List of files that form the development environment.

ELISP_EL := ${BUILD}/${ELISP}.el
INIT_BASH := ${BUILD}/${INIT}.bash
PACKAGES_SCM := ${BUILD}/${PACKAGES}.scm
SRC_EL := ${BUILD}/${SRC}.el

ENV_FILES := ${SRC_EL} ${INIT_BASH} ${PACKAGES_SCM} ${ELISP_EL}

# EMACS
# - Variable that refers to the Emacs executable.

EMACS := emacs -Q --batch -l ${ELISP_EL}

# GUIX
# - Variable that refers to guix executable.

GUIX := guix

# tangle
# - Makefile target that tangles necessary files.

.PHONY: tangle
tangle: ${ENV_FILES}
${ENV_FILES}: ${SRC}.org | ${BUILD}
	# Tangling done twice because we want ${ELISP_EL}.
	emacs -Q --batch $< -f org-babel-tangle &>/dev/null
	mv ${SRC}.el ${INIT}.bash ${PACKAGES}.scm ${ELISP}.el ${BUILD}
	${EMACS} $< -f org-babel-tangle &>/dev/null
	mv ${SRC}.el ${INIT}.bash ${PACKAGES}.scm ${ELISP}.el ${BUILD}
	sed -i '1,1d' ${SRC_EL}

# clean
# - Makefile target that delete all generate files necesseary files.

.PHONY: clean
clean:
	rm -rfv _*

# env
# - Makefile target that starts the environment.

.PHONY: env
GUIX_SHELL := ${GUIX} shell --container \
	-F \
	--file=${PACKAGES_SCM} \
	--preserve='^TERM$$' \
	-- bash --init-file ${INIT_BASH}
env:
	CMD="${CMD}"
	if [[ ! -v GUIX_ENVIRONMENT ]]; then
	  ${MAKE} tangle
	  if [[ "$${CMD}" == "" ]]; then
	    ${GUIX_SHELL} -i;
	  else
	    ${GUIX_SHELL} -c "${CMD}";
	  fi
	fi

# elc
# - Makefile target that byte compiles the package.

.PHONY: elc
SRC_ELC := ${BUILD}/${SRC}.elc
elc: ${SRC_ELC}
${SRC_ELC}: ${SRC_EL}
	${EMACS} -f batch-byte-compile $<

# lint
# - Makefile target that lints the package.

.PHONY: lint
LINT := lint-report
LINT_TXT := ${BUILD}/${LINT}.txt
lint: ${LINT_TXT}
${LINT_TXT}: ${SRC_EL}
	${EMACS} $< -f package-lint-buffer > $@

# checkdoc
# - Makefile target that check the docstrings of the package.

.PHONY: checkdoc
CHECKDOC := checkdoc
CHECKDOC_TXT := ${BUILD}/${CHECKDOC}.txt
checkdoc: ${CHECKDOC_TXT}
${CHECKDOC_TXT}: ${SRC_EL}
	${EMACS} --eval '(checkdoc-file "$<")' > $@

# all
# - Makefile target that builds, lint and checkdoc the package.

.DEFAULT_GOAL := all
.PHONY: all
all:
	${MAKE} tangle
	${MAKE} env CMD="${MAKE} lint checkdoc"

# Makefile

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -ceuo pipefail
EMACS := emacs --batch
PKG := locs-and-refs.org
ENVIRONMENT := environment.org
BUILD := _build
$(shell mkdir -p ${BUILD})

# env

# 1. ~make env~ builds the environment.

.PHONY: env
ENV := ${BUILD}/environment.scm
BASH_INIT := ${BUILD}/bash.rc
ORG_PATCHES := ${BUILD}/org-patches.el
${ENV}: ${ENVIRONMENT}
	emacs -Q --batch $< -f org-babel-tangle
env: ${ENV}
	guix shell --container \
	-F \
	--file=$< \
	--preserve='^TERM$$' \
	-- bash --init-file ${BASH_INIT} -i

# el

# 2. ~make el~ tangle the package.

.PHONY: el
EL := ${BUILD}/locs-and-refs.el
el: ${EL}
${EL}: ${ENV} ${PKG} 
	$(EMACS) ${PKG} -l ${ORG_PATCHES} -f org-babel-tangle
	sed -i '1,2d' $@

# elc

# 3. ~make elc~ byte compile the package.

.PHONY: elc
ELC := ${BUILD}/locs-and-refs.elc
elc: ${ELC}
${ELC}: ${EL}
	$(EMACS) -f batch-byte-compile $<

# lint

# 4. ~make lint~ lint the package.

.PHONY: lint
LINT := ${BUILD}/lint-report.txt
lint: ${LINT}
${LINT}: ${EL}
	$(EMACS) $< -f package-lint-buffer > $@

# checkdoc

# 5. ~make checkdoc~ checks the documentation of the package.

.PHONY: checkdoc
CHECKDOC := ${BUILD}/checkdoc-report.txt
checkdoc: ${CHECKDOC}
${CHECKDOC}: ${EL}
	$(EMACS) --eval '(checkdoc-file "$<")' > $@

# all

# 6. ~make all~ all of the above.

.DEFAULT_GOAL := all
.PHONY: all
all: elc checkdoc lint

# clean

# 7. ~make clean~ delete all generated files.

.PHONY: clean
clean:
	rm -rfv _*

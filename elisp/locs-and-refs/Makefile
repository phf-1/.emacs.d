SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

PKG_NAME := lar
SRC     := ${PWD}/src
TEST    := ${PWD}/test
MAIN    := ${SRC}/lar.el
PKG_FILE := ${SRC}/lar-pkg.el
DIST    := ${PWD}/_dist
STAGING := ${PWD}/_staging

# ${MAIN} → ${VERSION}
VERSION := $(shell awk '/^;; Package-Version:/ { print $$3; exit }' ${MAIN} | tr -d '[:space:]')
ifeq ($(strip $(VERSION)),)
$(error Could not extract Package-Version from ${MAIN})
endif

PKG_FILES := \
	${SRC}/lar--check.el \
	${SRC}/lar--error.el \
	${MAIN} \
	${SRC}/lar--link-id.el \
	${SRC}/lar--link.el \
	${SRC}/lar--message.el \
	${SRC}/lar--overlayer.el \
	${SRC}/lar--parser.el \
	${SRC}/lar--searcher.el \
	${SRC}/lar--send.el \
	${SRC}/lar--tag.el \
	${SRC}/lar--ui.el \
	${SRC}/lar--vocabulary.el \
	${PKG_FILE} \
	README.org \
	LICENSE \
	CONTRIBUTORS.org

ARCHIVE := ${DIST}/${PKG_NAME}-${VERSION}.tar

${DIST}:
	mkdir -p $@

# ${MAIN} → ${PKG_FILE}
${PKG_FILE}: ${MAIN}
	echo ';; lar-pkg.el --- Package metadata for lar.el -*- no-byte-compile: t; lexical-binding: t; -*-' > $@
	awk '/^;; Package-Version:/ {version=$$3} \
	     /^;; Package-Requires:/ {reqs=substr($$0, index($$0, $$3))} \
	     /^;;; lar\.el ---/ {desc=substr($$0, index($$0, "---") + 4); gsub(/^[ \t]+|[ \t]+$$/, "", desc); gsub(/[ \t]*-\*-.*$$/, "", desc)} \
	     END {printf "(define-package \"lar\" \"%s\"\n  \"%s\"\n  %s)\n", version, desc, reqs}' $< >> $@
	echo ';; Local Variables:' >> $@
	echo ';; no-byte-compile: t' >> $@
	echo ';; End:' >> $@
	echo "Generated $@"

# ${PKG_FILES} → ${ARCHIVE}
.PHONY: dist
dist: ${ARCHIVE}
${ARCHIVE}: ${PKG_FILES} | ${DIST}
	rm -rf ${STAGING}
	mkdir -p ${STAGING}/${PKG_NAME}-${VERSION}
	cp ${PKG_FILES} ${STAGING}/${PKG_NAME}-${VERSION}/
	tar -C ${STAGING} -cf $@ ${PKG_NAME}-${VERSION}
	rm -rf ${STAGING}
	echo "Created Emacs package: $@"

.PHONY: dist-test
dist-test: ${ARCHIVE}
	rm -vrf /home/phf/.emacs.d/elpa/${PKG_NAME}-${VERSION}
	emacs -Q --batch --file "${TEST}/example.org" --eval '(progn (package-install-file "$^") (lar-mode))'

.PHONY: example
example: ${ARCHIVE}
	rm -vrf /home/phf/.emacs.d/elpa/${PKG_NAME}-${VERSION}
	emacs -Q --eval '(progn (package-install-file "$^"))' --file "${TEST}/scratch.el"

.PHONY: clean
clean:
	rm -rfv _*

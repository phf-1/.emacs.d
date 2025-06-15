SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

BUILD := _build
${BUILD}:
        mkdir -p $@

TRACE := ${BUILD}/trace.txt

TRAP := > ${TRACE}; trap 'if [[ $$? -ne 0 ]]; then cat ${TRACE}; fi' EXIT

MAIN_ORG := total-recall.org

.PHONY: help
help:
        grep '^# - make ' $(MAKEFILE_LIST) | sed 's/^# - make //' | awk 'BEGIN {FS = " # "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: tangle-heading
TANGLE_HEADING := ${BUILD}/tangle-heading
tangle-heading: ${TANGLE_HEADING}
${TANGLE_HEADING}: ${MAIN_ORG} | ${BUILD}
        ${TRAP}
        ./tangle-heading ${MAIN_ORG} tangle-heading ${BUILD} &> ${TRACE}
        cp -vf ${BUILD}/tangle-heading ./tangle-heading &>> ${TRACE}
        tail -n 1 ${TRACE}

.PHONY: Makefile
MAKEFILE := ${BUILD}/Makefile
Makefile: ${MAKEFILE}
${MAKEFILE}: ${MAIN_ORG} | ${BUILD}
        ${TRAP}
        ./tangle-heading ${MAIN_ORG} Makefile ${BUILD} &> ${TRACE}
        cp -vf ${BUILD}/Makefile ./Makefile &>> ${TRACE}
        tail -n 1 ${TRACE}

.PHONY: packages.scm
PACKAGES_SCM := ${BUILD}/packages.scm
packages.scm: ${PACKAGES_SCM}
${PACKAGES_SCM}: ${MAIN_ORG} | ${BUILD}
        ${TRAP}
        ./tangle-heading ${MAIN_ORG} packages.scm ${BUILD} &> ${TRACE}
        echo "$@"

.PHONY: init.bash
INIT_BASH := ${BUILD}/init.bash
init.bash: ${INIT_BASH}
${INIT_BASH}: ${MAIN_ORG} | ${BUILD}
        ${TRAP}
        ./tangle-heading ${MAIN_ORG} init.bash ${BUILD} &> ${TRACE}
        echo "$@"

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

.PHONY: el
TOTAL_RECALL_EL := ${BUILD}/total-recall.el
el: ${TOTAL_RECALL_EL}
${TOTAL_RECALL_EL}: ${MAIN_ORG} | ${BUILD}
        ${TRAP}
        ./tangle-heading ${MAIN_ORG} total-recall.el ${BUILD} &> ${TRACE}
        # sed -i '1,2d' ${TOTAL_RECALL_EL} &>> ${TRACE}
        [[ -s ${TRACE} ]] && exit 1
        echo "$@"

.PHONY: elc
TOTAL_RECALL_ELC := ${BUILD}/total-recall.elc
elc: ${TOTAL_RECALL_ELC}
${TOTAL_RECALL_ELC}: ${TOTAL_RECALL_EL}
        ${TRAP}
        emacs -Q --batch \
        --eval '(setq org-id-track-globally nil)' \
        --eval '(defun reb-target-binding (_sym) (error "pcre2el v1.11"))' \
        -f batch-byte-compile $< &> ${TRACE}
        [[ -s ${TRACE} ]] && exit 1
        echo "$@"

.PHONY: lint
LINT_REPORT := ${BUILD}/lint-report.txt
lint: ${LINT_REPORT}
${LINT_REPORT}: ${TOTAL_RECALL_EL}
        ${TRAP}
        emacs --batch \
        --file $< \
        --eval '(setq org-id-track-globally nil)' \
        --eval "(progn (require 'package) (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t) (package-initialize))" \
        --eval "(progn (require 'package-lint) (let ((errors (package-lint-buffer))) (when errors (message \"%s\" errors))))" &> ${TRACE}
        [[ -s ${TRACE} ]] && exit 1
        echo "$@"

.PHONY: checkdoc
CHECKDOC := ${BUILD}/checkdoc.txt
checkdoc: ${CHECKDOC}
${CHECKDOC}: ${TOTAL_RECALL_EL}
        ${TRAP}
        emacs -Q --batch \
        --eval '(setq org-id-track-globally nil)' \
        --eval '(checkdoc-file "$<")' &> ${TRACE}
        [[ -s ${TRACE} ]] && exit 1
        echo "$@"

.PHONY: test
TEST := ${BUILD}/test-log.txt
test: ${TEST}
${TEST}: ${TOTAL_RECALL_EL}
        ${TRAP}
        emacs -Q --batch \
        --eval '(setq org-id-track-globally nil)' \
        --eval '(load-file "$<")' \
        --eval '(ert-run-tests-batch-and-exit t)' &> $@
        echo "$@"

.PHONY: all
all: ${BUILD}
        ${TRAP}
        ${MAKE} env CMD="${MAKE} lint checkdoc elc" &> ${TRACE}
        echo ${TOTAL_RECALL_EL}

.PHONY: clean
clean:
        rm -rfv ${BUILD}

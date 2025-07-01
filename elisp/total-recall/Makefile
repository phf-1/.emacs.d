SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:

BUILD := ${PWD}/_build
${BUILD}:
	mkdir -p $@

.PHONY: deps
PACKAGES_SCM := ${BUILD}/packages.scm
deps: ${PACKAGES_SCM}
${PACKAGES_SCM}: packages.org | ${BUILD}
	emacs -Q --batch --file "$<" --eval '(org-babel-tangle)'
	mv packages.scm "$@"
	echo "$@"

.PHONY: env
GUIX := guix
GUIX_SHELL := ${GUIX} shell --container \
	-F \
	--file=${PACKAGES_SCM} \
	--preserve='^TERM$$' \
	-- bash --init-file init.bash
env: ${PACKAGES_SCM} | ${BUILD}
	echo 'export LC_ALL=en_US.UTF-8' >init.bash
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
TOTAL_RECALL_TEST_EL := ${BUILD}/total-recall-test.el
NETWORK_SERVER := ${BUILD}/network-server
el: ${TOTAL_RECALL_EL}
${TOTAL_RECALL_EL}: solution.org | ${BUILD}
	emacs -Q --batch --file "$<" --eval '(org-babel-tangle)'
	mv total-recall.el "$@"
	mv total-recall-test.el "${TOTAL_RECALL_TEST_EL}"
	mv network-server "${NETWORK_SERVER}"
	echo "$@"
	echo "${TOTAL_RECALL_TEST_EL}"

.PHONY: lint
LINT_REPORT := ${BUILD}/lint-report.txt
lint: ${LINT_REPORT}
${LINT_REPORT}: ${TOTAL_RECALL_EL}
	emacs --batch --chdir "${BUILD}" \
	--file "$<" \
	--eval '(setq org-id-track-globally nil)' \
	--eval "(progn (require 'package-lint) (let ((errors (package-lint-buffer))) (when errors (message \"%s\" errors))))" 2>&1 | tee "$@"
	echo "$@"

.PHONY: elc
TOTAL_RECALL_ELC := ${BUILD}/total-recall.elc
elc: ${TOTAL_RECALL_ELC}
${TOTAL_RECALL_ELC}: ${TOTAL_RECALL_EL}
	emacs -Q --dir "${BUILD}" --batch \
	--eval '(setq org-id-track-globally nil)' \
	--eval '(defun reb-target-binding (_sym) (error "pcre2el v1.11"))' \
	-f batch-byte-compile "$<"
	echo "$@"

.PHONY: checkdoc
CHECKDOC := ${BUILD}/checkdoc-report.txt
checkdoc: ${CHECKDOC}
${CHECKDOC}: ${TOTAL_RECALL_EL}
	emacs -Q --batch \
	--eval '(setq org-id-track-globally nil)' \
	--eval '(checkdoc-file "$<")' 2>&1 | tee "$@"
	echo "$@"

.PHONY: test
TEST := ${BUILD}/test-report.txt
test: ${TEST}
${TEST}: ${TOTAL_RECALL_EL}
	emacs -Q --batch \
	--eval '(setq org-id-track-globally nil)' \
	--eval '(load-file "${TOTAL_RECALL_EL}")' \
	--eval '(load-file "${TOTAL_RECALL_TEST_EL}")' \
	--eval '(ert-run-tests-batch-and-exit t)' 2>&1 | tee "$@"
	echo "$@"

.PHONY: manual-test
CONFIGURATION_EL := "${BUILD}"/configuration.el
manual-test: ${TOTAL_RECALL_EL}
	cp configuration.el "${CONFIGURATION_EL}"
	emacs -Q -nw --chdir "${BUILD}" -l "$<" -l "${CONFIGURATION_EL}" --eval '(toggle-debug-on-error)' --file "$<"

.PHONY: all
all:
	${MAKE} el
	${MAKE} lint
	${MAKE} checkdoc
	${MAKE} elc
	${MAKE} test

.PHONY: clean
clean:
	rm -rfv ${BUILD}

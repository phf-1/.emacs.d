# -*- mode: snippet -*-
# name: actor
# key: actor
# expand-env: ((yas-indent-line 'fixed) (yas-wrap-around-region 'nil))
# --
* Makefile
:PROPERTIES:
:header-args+: :tangle Makefile
:END:

** Configuration
- List of Makefile configurations.

#+begin_src makefile
SHELL := bash
.SHELLFLAGS := -ceuo pipefail
MAKEFLAGS += --no-print-directory
.ONESHELL:
.SILENT:
#+end_src

** help
- make help # Print this help.

#+begin_src makefile
.PHONY: help
help:
	grep '^# - make ' \$(MAKEFILE_LIST) | sed 's/^# - make //' | awk 'BEGIN {FS = " # "}; {printf "\033[36m%-30s\033[0m %s\n", \$\$1, \$\$2}'
#+end_src

** BUILD
- \${BUILD} is the directory under which all generated files are installed.

#+begin_src makefile
BUILD := _build
\${BUILD}:
	mkdir -p \$@
#+end_src

** TRACE
- \${TRACE} is a file used to record an execution trace.

#+begin_src makefile
TRACE := \${BUILD}/trace.txt
#+end_src

** TRAP
- \${TRAP} If something has been written to \${TRACE}, then consider that the rule failed.

#+begin_src makefile
TRAP := > \${TRACE}; trap 'if [[ \$\$? -ne 0 ]]; then cat \${TRACE}; fi' EXIT
#+end_src

** MAIN_ORG
- \${MAIN_ORG} is the path to source file.

#+begin_src makefile
MAIN_ORG := README.org
#+end_src

** Makefile
- make Makefile # Returns the path to the updated ./Makefile.

#+begin_src makefile
.PHONY: Makefile
MAKEFILE := \${BUILD}/Makefile
Makefile: \${MAKEFILE}
\${MAKEFILE}: \${MAIN_ORG} | \${BUILD}
	\${TRAP}
	./tangle-heading \${MAIN_ORG} Makefile \${BUILD} &> \${TRACE}
	cp -vf \${BUILD}/Makefile ./Makefile &>> \${TRACE}
	tail -n 1 \${TRACE}
#+end_src 

** packages.scm
- make packages.scm # Returns the path to the Guix packages available in the environment.

#+begin_src makefile
.PHONY: packages.scm
PACKAGES_SCM := \${BUILD}/packages.scm
packages.scm: \${PACKAGES_SCM}
\${PACKAGES_SCM}: \${MAIN_ORG} | \${BUILD}
	\${TRAP}
	./tangle-heading \${MAIN_ORG} packages.scm \${BUILD} &> \${TRACE}
	echo "\$@"
#+end_src 

** init.bash
- make init.bash # Returns the path to parameters that initialize Bash in the environment.

#+begin_src makefile
.PHONY: init.bash
INIT_BASH := \${BUILD}/init.bash
init.bash: \${INIT_BASH}
\${INIT_BASH}: \${MAIN_ORG} | \${BUILD}
	\${TRAP}
	./tangle-heading \${MAIN_ORG} init.bash \${BUILD} &> \${TRACE}
	echo "\$@"
#+end_src 

** env
- make env # Starts the environment.

#+begin_src makefile
.PHONY: env
GUIX := guix
GUIX_SHELL := \${GUIX} shell --container \
	-F \
	-N \
	--file=\${PACKAGES_SCM} \
	--preserve='^TERM\$\$' \
	-- bash --init-file \${INIT_BASH}
env: \${PACKAGES_SCM} \${INIT_BASH}
	CMD="\${CMD}"
	if [[ ! -v GUIX_ENVIRONMENT ]]; then
	  if [[ "\$\${CMD}" == "" ]]; then
	    \${GUIX_SHELL} -i;
	  else
	    \${GUIX_SHELL} -c "\${CMD}";
	  fi
	else
	  \${CMD}
	  :
	fi
#+end_src

** all
- make all # Returns the path of the elisp package after lint, checkdoc and elc steps.

#+begin_src makefile
.PHONY: all
all: \${BUILD}
	\${TRAP}
	\${MAKE} env CMD="\${MAKE} lint checkdoc elc" &> \${TRACE}
	echo \${LOCS_AND_REFS_EL}
#+end_src

** clean
- make clean # Deletes all generated files.

#+begin_src makefile
.PHONY: clean
clean:
	rm -rfv \${BUILD}
#+end_src


(use-modules (gnu packages base))
(define locale
  (make-glibc-utf8-locales
   glibc
   #:locales (list "en_US")
   #:name "glibc-en-utf8-locales"))

(use-modules (gnu packages emacs-xyz))
(define elisp-packages (list emacs-package-lint emacs-org))

(use-modules
 (gnu packages base)
 (gnu packages bash)
 (gnu packages emacs)
 (gnu packages rust-apps)
 (gnu packages certs)
 (gnu packages admin)
 (gnu packages build-tools))

(define binaries
  (list

   ;; build dependencies
   ;; bash-minimal
   bash
   coreutils
   gnu-make
   emacs
   sed
   nss-certs

   ;; runtime dependencies
   ripgrep
   fd))

`(,locale ,@elisp-packages ,@binaries)

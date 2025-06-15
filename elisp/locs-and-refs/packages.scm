;; locale

;; - Guix package that provides utf8 locale.

;; #+name: locale

(use-modules (gnu packages base))
(define locale
  (make-glibc-utf8-locales
   glibc
   #:locales (list "en_US")
   #:name "glibc-en-utf8-locales"))

;; elisp-packages

;; - List of Elisp guix packages.

;; #+name: elisp-packages

(use-modules (gnu packages emacs-xyz))
(define elisp-packages (list emacs-pcre2el emacs-package-lint))

;; binaries

;; - List of Guix packages that provides binaries.

;; #+name: binaries

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
   emacs-minimal
   sed
   nss-certs

   ;; runtime dependencies
   ripgrep
   fd))

;; ■

;; - List of Guix packages.


`(,locale ,@elisp-packages ,@binaries)

;; backup
;; :PROPERTIES:
;; :header-args+: :tangle elisp/user-backup.el
;; :END:

(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq create-lockfiles nil)
(setq delete-by-moving-to-trash t)
(setq
 backup-by-copying t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 auto-save-list-file-prefix emacs-tmp-dir
 auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))
 backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(provide 'user-backup)

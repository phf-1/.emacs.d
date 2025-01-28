;; editing
;; :PROPERTIES:
;; :header-args+: :tangle elisp/user-editing.el
;; :END:

;; 1. (add-hook 'before-save-hook #'whitespace-cleanup) does not work,
;;    because it removes tabs in makefile code blocks.

(setq-default indent-tabs-mode nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(delete-selection-mode 1)
(global-auto-revert-mode t)
(put 'narrow-to-region 'disabled nil)
(setq load-prefer-newer t)
(provide 'user-editing)

;; editing

;; 1. (add-hook 'before-save-hook #'whitespace-cleanup) does not work,
;;    because it removes tabs in makefile code blocks.


;; (setq-default indent-tabs-mode nil)
;; (setq whitespace-style '(face tabs trailing lines-tail))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(delete-selection-mode 1)
(global-auto-revert-mode t)
(put 'narrow-to-region 'disabled nil)
(setq load-prefer-newer t)
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
(provide 'user-editing)

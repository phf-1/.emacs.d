;; key-bindings
;; :PROPERTIES:
;; :header-args+: :tangle elisp/user-key-bindings.el
;; :END:

(global-set-key (kbd "C-$") #'clone-indirect-buffer-other-window)
(global-set-key (kbd "C-c l") #'org-store-link)
(provide 'user-key-bindings)

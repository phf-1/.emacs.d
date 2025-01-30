;; ui


(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode 1)
(setq-default cursor-type 'bar)
(setq-default fill-column 85)
(column-number-mode 1)
(setq frame-title-format '("%b"))
(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)
(add-to-list 'default-frame-alist '(font . "JetBrains Mono"))
(provide 'user-ui)

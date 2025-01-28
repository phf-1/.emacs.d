;; utils
;; :PROPERTIES:
;; :header-args+: :tangle elisp/user-utils.el
;; :END:

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."

  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(defun dedicate-window (&optional arg)
  "Set current window to be dedicated.
With prefix ARG, undedicate it."
  (interactive "P")
  (set-window-dedicated-p (get-buffer-window (current-buffer)) (not arg))
  (message (if arg
               "Window '%s' is normal"
             "Window '%s' is dedicated")
           (current-buffer)))
(provide 'user-utils)

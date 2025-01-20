;; Property drawers are removed after tangling

(defun user--org-remove-property-drawers ()
  "After tangling, remove all :PROPERTIES: drawers."
  (save-excursion
    (let ((inhibit-modification-hooks t)
          (modified-p (buffer-modified-p)))
      (goto-char (point-min))
      (while (re-search-forward ".*:PROPERTIES:$" nil t)
        (let ((start (line-beginning-position)))
          (when (re-search-forward ".*:END:\n" nil t)
            (delete-region start (point)))))
      (set-buffer-modified-p modified-p))))
(add-hook 'org-babel-post-tangle-hook #'user--org-remove-property-drawers)

;; org-babel-spec-to-string is fixed
;; Like the original version
;; but do not insert useless new line.

(defun org-babel-spec-to-string (spec)
  "Insert SPEC into the current file.

Insert the source-code specified by SPEC into the current source
code file.  This function uses `comment-region' which assumes
that the appropriate major-mode is set.  SPEC has the form:

  (start-line file link source-name params body comment)"
  (pcase-let*
      ((`(,start ,file ,link ,source ,info ,body ,comment) spec)
       (comments (cdr (assq :comments info)))
       (link? (or (string= comments "both") (string= comments "link")
                  (string= comments "yes") (string= comments "noweb")))
       (link-data `(("start-line" . ,(number-to-string start))
                    ("file" . ,file)
                    ("link" . ,link)
                    ("source-name" . ,source)))
       (insert-comment (lambda (text)
                         (when (and comments
                                    (not (string= comments "no"))
                                    (org-string-nw-p text))
                           (if org-babel-tangle-uncomment-comments
                               ;; Plain comments: no processing.
                               (insert text)
                             ;; Ensure comments are made to be comments.  Also ignore
                             ;; invisible characters when commenting.
                             (comment-region
                              (point)
                              (progn (insert (org-no-properties text))
                                     (point))))))))
    (when comment (funcall insert-comment comment))
    (when link?
      (funcall insert-comment
               (org-fill-template
                org-babel-tangle-comment-format-beg link-data)))
    (insert body "\n")
    (when link?
      (funcall insert-comment
               (org-fill-template
                org-babel-tangle-comment-format-end link-data)))))

;; Try to format all JS code blocks
;; - λ()
;;   - point :≡ point-min()
;;   - search-next-code-block() ≡
;;     - error[msg] ⇒ message(msg)
;;     - nil ⇒ ■
;;     - pair[start end] ⇒
;;       - format-code extract-code(start end) ≡
;;         - error[msg] ⇒ message(msg)
;;         - formatted-code ⇒ replace-code(start end formatted-code)
;;       - point :≡ end
;;       - λ()

(defun user-format-all-js-code-blocks ()
  "Format all JavaScript code blocks in the current buffer using Biomejs or Prettier.
If neither Prettier nor Biomejs is found in the PATH, signal an error.
Iteratively processes all blocks marked with the 'js' tag."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (pcase (user--next-code-block "js")
        ('nil
         (message "All JS code blocks have been formatted using %s" (user--format-code-cmd))
         (end-of-buffer))
        (`(:error ,msg)
         (user-error msg))
        (`(,start ,end)
         (pcase (user--format-code (user--extract-code start end)
                                   (get-buffer-create "*Formatting errors*"))
           (`(:error ,msg)
            (message "Code block starting at %s has not been formatted.\n%s" start msg)

            (goto-char end))
           (formatted-code
            (user--replace-code start end formatted-code)
            (goto-char start)
            (forward-line -1)
            (pcase (user--next-code-block "js")
              (`(,start ,end)
               (goto-char end))))))))))

(defun user--next-code-block (tag)
  "Find the next code block tagged with TAG in the current buffer.
Returns nil if no block is found, or a list (START END) indicating
the region of the block, or an error if an unmatched block is found."
  (save-excursion
    (let ((case-fold-search t) begin-re end-re start)
      (setq begin-re
            (rx-to-string `(seq bol (0+ " ") "#+begin_src" (1+ " ") (literal ,tag) (not word))))
      (pcase (search-forward-regexp begin-re nil t)
        ('nil nil)
        (_
         (backward-char)
         (forward-line 1)
         (setq start (point))
         (setq end-re (rx-to-string '(seq bol (0+ " ") "#+end_src" (0+ " "))))
         (pcase (search-forward-regexp end-re nil t)
           ('nil
            (list :error (format "start of code block at %s has no matching end")))
           (_
            (beginning-of-line)
            (list start (point)))))))))

(defun user--extract-code (start end)
  "Extract the code between START and END in the current buffer.
Returns the content of the region as a string."
  (buffer-substring-no-properties start end))

(defun user--replace-code (start end code)
  "Replace the content between START and END with CODE in the current buffer."
  (save-excursion
    (kill-region start end)
    (goto-char start)
    (insert code)))

(defun user--format-code (code error-buffer)
  "Format the given CODE using Prettier.
If formatting succeeds, return the formatted code as a string.
If an error occurs, insert the error message into ERROR-BUFFER
and return an error indicator."
  (if (string= code "")
      ""
    (let (return-code)
      (with-temp-buffer
        (insert code)
        (setq return-code
              (shell-command-on-region
               (point-min)
               (point-max)
               (user--format-code-cmd)
               (current-buffer) t
               error-buffer))
        (pcase return-code
          (0
           (buffer-substring-no-properties (point-min) (point-max)))
          (_
           (list :error (format "Formatting error. See buffer %s" (buffer-name error-buffer)))))))))

(setq user--format-code-cmd-cache nil)
(defun user--format-code-cmd ()
  (if (null user--format-code-cmd-cache)
      (setq user--format-code-cmd-cache
            (pcase (executable-find "biome")
              ((and (pred stringp) path)
               (format "%s format --indent-style space --indent-width 4 --stdin-file-path tmp.js" path))
              (_
               (pcase (executable-find "prettier")
                 ((and (pred stringp) path)
                  (format "%s --stdin-filepath tmp.js" path))
                 (_
                  (user-error "neither biome nor prettier in the PATH"))))))
    user--format-code-cmd-cache))

;; provide

(provide 'org-patches)

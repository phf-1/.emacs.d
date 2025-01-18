;; tangled files

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


;; org-babel-spec-to-string

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

(provide 'org-patches)

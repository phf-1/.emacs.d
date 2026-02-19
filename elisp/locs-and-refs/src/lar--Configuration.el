;;; lar--Configuration.el --- User configuration for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later
;; [[ref:3679aa4b-cb4b-40a5-a72a-a8cf95e3de99][specification]]

;;; Code:

(require 'project)  ; built-in, used for automatic project-root detection

(defgroup lar nil
  "Locate and print Org-style id/ref links."
  :group 'tools)

(defcustom lar-root-directory nil
  "Root directory for link searches.

- nil (default) → automatically use the project root of the current buffer
  (via `project-current' – respects .git, mix.exs, Cargo.toml, etc.)
- Custom directory → override (still useful for monorepos or non-project folders)

Falls back to `default-directory' → `~' only if no project is found."
  :type '(choice (const :tag "Auto-detect project root" nil)
                 (directory :tag "Fixed directory"))
  :group 'lar)

(defcustom lar-rg-path "rg"
  "Path to the ripgrep executable."
  :type 'string
  :group 'lar)

(defun lar--Configuration (msg)
  "Actor for configuration queries."
  (pcase msg
    (:rg (executable-find lar-rg-path))
    (:root (lar--compute-root))
    (_ (lar--unexpected #'lar--Error msg))))

(defun lar--compute-root ()
  "Return the root directory to search (project-aware)."
  (or (and lar-root-directory
           (expand-file-name lar-root-directory))
      (when-let ((proj (project-current)))
        (project-root proj))
      (expand-file-name default-directory)   ; per-buffer fallback
      (expand-file-name "~")))

(provide 'lar--Configuration)
;;; lar--Configuration.el ends here

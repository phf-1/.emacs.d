;;; lar--Configuration.el --- User configuration for lar -*- lexical-binding: t; -*-
;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later
;; [[ref:3679aa4b-cb4b-40a5-a72a-a8cf95e3de99][specification]]

;;; Code:

(defgroup lar nil
  "Locate and print Org-style id/ref links."
  :group 'tools)

(defcustom lar-rg-path "rg"
  "Path to the ripgrep executable."
  :type 'string
  :group 'lar)

(defcustom lar-root-directory "~"
  "The root directory where the searcher looks for links."
  :type 'directory
  :group 'lar)

(defun lar--Configuration (msg)
  "Actor for type checking and validation."
  (pcase msg
    (:rg (executable-find lar-rg-path))
    (:root (expand-file-name lar-root-directory))
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--Configuration)
;;; lar--Configuration.el ends here

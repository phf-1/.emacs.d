;;; lar--link-id.el --- Link ID validation for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--check)
(require 'lar--error)
(require 'lar--vocabulary)

(defun lar--LinkId (msg)
  "Actor representing a unique link identifier."
  (pcase msg
    (`(:check ,obj)
     (lar--mk #'lar--LinkId obj)
     nil)

    (`(:mk ,str)
     (lar--string #'lar--Check str)
     (cond
      ((> (length str) 0) str)
      (t (error "Length of str is 0."))))

    (_
     (lar--unexpected #'lar--Error msg))))

(provide 'lar--link-id)
;;; lar--link-id.el ends here

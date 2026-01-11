;;; lar--tag.el --- Tag type definitions for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--error)
(require 'lar--vocabulary)

(defun lar--Tag (msg)
  "Actor for managing link tags (loc/ref)."
  (pcase msg
    (`(:check ,obj)
     (unless (memq obj '(:loc :ref))
       (error "obj is not a Tag. obj = %s" obj)))
    (:loc :loc)
    (:ref :ref)
    ('(:inverse :loc) :ref)
    ('(:inverse :ref) :loc)
    ('(:string :ref) "ref")
    ('(:string :loc) "id")
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--tag)
;;; lar--tag.el ends here

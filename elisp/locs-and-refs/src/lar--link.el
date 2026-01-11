;;; lar--link.el --- Link data structure actors for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--vocabulary)
(require 'lar--tag)
(require 'lar--check)
(require 'lar--error)
(require 'lar--link-id)

(defun lar--Link (msg)
  "Actor representing a parsed link."
  (pcase msg
    (`(:mk ,tag ,id ,start ,end ,name)
     (lar--check #'lar--Tag tag)
     (lar--check #'lar--LinkId id)
     (lar--posint #'lar--Check start)
     (lar--posint #'lar--Check end)
     (lar--string #'lar--Check name)
     (unless (< start end) (error "start ≥ end"))
     (lambda (msg)
       (pcase msg
         (:tag tag)
         (:id id)
         (:start start)
         (:end end)
         (:name name)
         (_ (lar--unexpected #'lar--Error msg)))))

    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--link)
;;; lar--link.el ends here

;;; lar--message.el --- Message protocol for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--send)

(defun lar--Message (msg)
  "Actor for handling communication messages."
  (pcase msg
    (`(:mk ,kw)
     (unless (keywordp kw)
       (error "kw is not a keyword. kw = %s" kw))
     kw)

    (`(:mk ,kw . ,params)
     (unless (keywordp kw)
       (error "kw is not a keyword. kw = %s" kw))
     (cdr msg))

    (_
     (error "Unexpected msg. msg = %s" msg))))

(defun lar--Message-mk (kw &optional params)
  "Create a message with KW and PARAMS."
  (lar--send #'lar--Message (cons :mk (cons kw params))))

(provide 'lar--message)
;;; lar--message.el ends here

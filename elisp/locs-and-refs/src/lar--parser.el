;;; lar--parser.el --- PEG parser for lar links -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--vocabulary)
(require 'lar--check)
(require 'lar--error)
(require 'lar--link)
(require 'lar--tag)
(require 'peg)
(require 'rx)
(require 'pcre2el)

(define-peg-ruleset lar--link-grammar
  (link () `(-- (point)) (or global property inline) `(-- (point)))
  (global () (bol) "#+" tag ":" (* space) (substring id) (opt (+ space) (substring name)))
  (property () (bol) ":" tag ":" (* space) (substring id) (opt (+ space) (substring name)))
  (inline () "[" "[" tag ":" (substring id) "]" (opt "[" (opt (substring name)) "]") "]")
  (id () (+ alpha))
  (name () (+ alpha))
  (tag () (or loc ref))
  (loc () (or "id" "ID") `(-- :loc))
  (ref () (or "ref" "REF") `(-- :ref))
  (alpha () (or letter LETTER digit "_" "-" "."))
  (LETTER () [A-Z])
  (letter () [a-z])
  (digit () [0-9])
  (space () " "))

(defun lar--Parser-peg-parse ()
  "Internal function to run the PEG parser."
  (nreverse
   (with-peg-rules (lar--link-grammar)
     (peg-run (peg link)))))

(defun lar--Parser (msg)
  "Actor for parsing links and generating regexes."
  (pcase msg
    (:mk
     (lambda (msg)
       (pcase msg
         (`(:links ,buffer)
          (lar--buffer #'lar--Check buffer)
          (with-current-buffer buffer
            (let (links)
              (save-excursion
                (goto-char (point-min))
                (while (not (eobp))
                  (pcase (lar--Parser-peg-parse)
                    (`(,start ,tag ,id ,end)
                     (push (lar--mk #'lar--Link tag id start end "") links))
                    (`(,start ,tag ,id ,name ,end)
                     (push (lar--mk #'lar--Link tag id start end name) links))
                    (_ (forward-char 1)))))
              (nreverse links))))

         (`(:regex ,tag ,id)
          (lar--string #'lar--Check tag)
          (lar--string #'lar--Check id)
          (rxt-elisp-to-pcre
           (rx-to-string
            `(or
              (seq bol "#+" (or ,tag ,(upcase tag)) ":" (* space) ,id)
              (seq bol ":" (or ,tag ,(upcase tag)) ":" (* space) ,id)
              (seq "[[" (or ,tag ,(upcase tag)) ":" ,id "]" (opt "[" (* (not (any "]"))) "]") "]"))
            t)))

         (_ (lar--unexpected #'lar--Error msg)))))
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--parser)
;;; lar--parser.el ends here

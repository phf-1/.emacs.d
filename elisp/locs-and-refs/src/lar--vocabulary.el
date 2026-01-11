;;; lar--vocabulary.el --- DSL vocabulary for lar actors -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--send)
(require 'lar--message)

(defun lar--mk (actor &rest params)
  "Send :mk message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :mk params)))

(defun lar--loc (actor &rest params)
  "Send :loc message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :loc params)))

(defun lar--ref (actor &rest params)
  "Send :ref message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :ref params)))

(defun lar--check (actor &rest params)
  "Send :check message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :check params)))

(defun lar--posint (actor &rest params)
  "Send :posint message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :posint params)))

(defun lar--keyword (actor &rest params)
  "Send :keyword message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :keyword params)))

(defun lar--list (actor &rest params)
  "Send :list message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :list params)))

(defun lar--unexpected (actor &rest params)
  "Send :unexpected message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :unexpected params)))

(defun lar--tag (actor &rest params)
  "Send :tag message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :tag params)))

(defun lar--id (actor &rest params)
  "Send :id message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :id params)))

(defun lar--start (actor &rest params)
  "Send :start message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :start params)))

(defun lar--stop (actor &rest params)
  "Send :stop message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :stop params)))

(defun lar--end (actor &rest params)
  "Send :end message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :end params)))

(defun lar--inverse (actor &rest params)
  "Send :inverse message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :inverse params)))

(defun lar--buffer (actor &rest params)
  "Send :buffer message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :buffer params)))

(defun lar--name (actor &rest params)
  "Send :name message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :name params)))

(defun lar--string (actor &rest params)
  "Send :string message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :string params)))

(defun lar--links (actor &rest params)
  "Send :links message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :links params)))

(defun lar--directory (actor &rest params)
  "Send :directory message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :directory params)))

(defun lar--executable (actor &rest params)
  "Send :executable message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :executable params)))

(defun lar--search (actor &rest params)
  "Send :search message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :search params)))

(defun lar--reset (actor &rest params)
  "Send :reset message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :reset params)))

(defun lar--display (actor &rest params)
  "Send :display message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :display params)))

(defun lar--add (actor &rest params)
  "Send :add message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :add params)))

(defun lar--clean (actor &rest params)
  "Send :clean message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :clean params)))

(defun lar--regex (actor &rest params)
  "Send :regex message to ACTOR with PARAMS."
  (lar--send actor (lar--Message-mk :regex params)))

(provide 'lar--vocabulary)
;;; lar--vocabulary.el ends here

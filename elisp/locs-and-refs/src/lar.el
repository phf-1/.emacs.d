;;; lar.el --- Define locations and references for files and buffers -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; Maintainer: Pierre-Henry FRÖHRING contact@phfrohring.com
;; Homepage: https://github.com/phf-1/lar
;; Package-Version: 0.20
;; Package-Requires: ((emacs "29.1") (peg "1.0"))
;; Keywords: tools, hypermedia
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Define and navigate Org-style ID and REF links across files and buffers.
;; This mode scans the current buffer for links and provides interactive
;; overlays to search for occurrences using ripgrep.

;;; Code:

(require 'lar--vocabulary)
(require 'lar--parser)
(require 'lar--searcher)
(require 'lar--overlayer)

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

(defun lar--emacs-start ()
  "Clean previous overlays and add fresh ones to the current buffer."
  (let* ((root (expand-file-name lar-root-directory))
         (rg-path (executable-find lar-rg-path))
         (parser (lar--mk #'lar--Parser))
         (searcher (lar--mk #'lar--Searcher root rg-path))
         (overlayer (lar--mk #'lar--Overlayer searcher parser))
         (links (lar--links parser (current-buffer))))
    (lar--clean overlayer (current-buffer))
    (dolist (link links)
      (lar--add overlayer (current-buffer) link))))

(defun lar--emacs-stop ()
  "Remove all overlays added by lar-mode."
  (let ((overlayer (lar--mk #'lar--Overlayer nil nil)))
    (lar--clean overlayer (current-buffer))))

;;;###autoload
(define-minor-mode lar-mode
  "Locate and print Org-style id/ref links."
  :global nil
  :lighter " Lar"
  (if lar-mode
      (lar--emacs-start)
    (lar--emacs-stop)))

(provide 'lar)
;;; lar.el ends here

;;; lar--ui.el --- Search results UI for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--vocabulary)
(require 'lar--check)
(require 'lar--error)

(defun lar--Ui (msg)
  "Actor for managing the search results frame and buffer."
  (pcase msg
    (:mk
     (let (frame window buffer)
       (setq buffer (generate-new-buffer "*lar-search-results*"))
       (setq frame (make-frame '((name . "LAR Search Results")
                                 (width . 80)
                                 (height . 20))))
       (setq window (frame-selected-window frame))

       (with-selected-window window
         (switch-to-buffer buffer)
         (grep-mode)
         (let ((inhibit-read-only t))
           (insert "Search results:\n\n")))

       (lambda (msg)
         (pcase msg
           (:stop
            (when (buffer-live-p buffer)
              (kill-buffer buffer))
            (when (frame-live-p frame)
              (delete-frame frame)))

           (`(:display ,links)
            (with-current-buffer buffer
              (let ((inhibit-read-only t))
                (erase-buffer)
                (insert "Search results:\n\n")
                (dolist (link links)
                  (pcase-let ((`(,path ,line ,col) link))
                    (let ((abs-path (expand-file-name path)))
                      (insert (format "%s:%d:%d\n" abs-path line col)))))
                (goto-char (point-min)))))
           (_ (lar--unexpected #'lar--Error msg))))))
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--ui)
;;; lar--ui.el ends here

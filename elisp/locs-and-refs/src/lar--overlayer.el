;;; lar--overlayer.el --- Overlay management for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'lar--vocabulary)
(require 'lar--check)
(require 'lar--error)
(require 'lar--link)
(require 'lar--tag)
(require 'lar--ui)

(defun lar--Overlayer (msg)
  "Actor for creating and removing UI overlays."
  (pcase msg
    (`(:mk ,searcher ,parser)
     (lambda (msg)
       (pcase msg
         (`(:add ,buffer ,link)
          (lar--buffer #'lar--Check buffer)
          (with-current-buffer buffer
            (let* ((start (lar--start link))
                   (end (lar--end link))
                   (ov (make-overlay start end buffer))
                   (map (make-sparse-keymap)))

              (define-key map [mouse-1]
                (lambda (_)
                  (interactive "e")
                  (let* ((tag (lar--tag link))
                         (id (lar--id link))
                         (inv-tag (lar--inverse #'lar--Tag tag))
                         (tag-str (lar--string #'lar--Tag inv-tag))
                         (regex (lar--regex parser tag-str id))
                         (ui (lar--mk #'lar--Ui)))
                    (lar--search searcher regex
                                 (lambda (results)
                                   (lar--display ui results))))))

              (overlay-put ov 'lar--overlayer t)
              (overlay-put ov 'face 'link)
              (overlay-put ov 'mouse-face 'highlight)
              (overlay-put ov 'help-echo "Click to find linked occurrences")
              (overlay-put ov 'keymap map)))
          buffer)

         (`(:clean ,buffer)
          (lar--buffer #'lar--Check buffer)
          (with-current-buffer buffer
            (remove-overlays (point-min) (point-max) 'lar--overlayer t))
          buffer)

         (_ (lar--unexpected #'lar--Error msg)))))
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--overlayer)
;;; lar--overlayer.el ends here

;;; lar--Overlayer.el --- Overlay management for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later
;; [[ref:7d158113-130f-41a8-9823-99db28fdef61][specification]]

;;; Code:

(require 'lar--send)
(require 'lar--Check)
(require 'lar--Error)
(require 'lar--parser)
(require 'lar--Link)

(require 'lar--Tag)
(require 'lar--Ui)

(defun lar--Overlay (msg)
  "Actor for creating and removing UI overlays."
  (pcase msg
    (`(:mk ,buffer ,start ,end ,tag ,id ,name ,searcher)
     (lar--buffer #'lar--Check buffer)
     (lar--posint #'lar--Check start)
     (lar--posint #'lar--Check end)
     (lar--check #'lar--Tag tag)
     (lar--string #'lar--Check id)
     (lar--string #'lar--Check name)
     (unless (< start end) (error "end ≥ start"))
     (with-current-buffer buffer
       (let ((ov (make-overlay start end buffer))
             (map (make-sparse-keymap)))

         (define-key map [mouse-1]
                     (lambda (_)
                       (interactive "e")
                       (let* ((inv-tag (lar--inverse #'lar--Tag tag))
                              (tag-str (lar--string #'lar--Tag inv-tag))
                              (regex (lar--regex #'lar--parser inv-tag id))
                              (ui (lar--mk #'lar--Ui)))
                         (lar--search searcher regex
                                      (lambda (results)
                                        (if results
                                            (lar--display ui results)
                                          (lar--display ui (format "No results found.\n  tag = %s\n  id = %s" tag-str id))))))))

         (overlay-put ov 'lar--Overlayer t)
         (overlay-put ov 'face 'link)
         (overlay-put ov 'mouse-face 'highlight)
         (overlay-put ov 'help-echo "Click to find linked occurrences")
         (overlay-put ov 'keymap map)

         ;; Display only tag and name if name exists
         (when (and name (not (string-empty-p name)))
           (let ((tag-str (lar--string #'lar--Tag tag)))
             (overlay-put ov 'display (format "[%s: %s]" tag-str name)))))))

    (:tag 'lar--Overlayer)
    (_ (lar--unexpected #'lar--Error msg))))

(provide 'lar--Overlay)
;;; lar--Overlayer.el ends here

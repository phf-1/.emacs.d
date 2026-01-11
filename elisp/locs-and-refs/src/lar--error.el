;;; lar--error.el --- Error handling actors for lar -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(defun lar--Error (msg)
  "Actor handling error signals."
  (pcase msg
    (`(:unexpected ,msg)
     (error "Unexpected message. msg = %s" msg))

    (_
     (error "Unexpected message. msg = %s" msg))))

(provide 'lar--error)
;;; lar--error.el ends here

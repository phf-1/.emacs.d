;;; lar--send.el --- Actor communication primitive -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Pierre-Henry FRÖHRING
;; Author: Pierre-Henry FRÖHRING contact@phfrohring.com
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(defun lar--send (actor msg)
  "Send MSG to ACTOR."
  (funcall actor msg))

(provide 'lar--send)
;;; lar--send.el ends here

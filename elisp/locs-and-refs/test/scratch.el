(require 'lar--vocabulary)

(require 'lar--parser)
(setq parser (lar--mk #'lar--Parser))

(require 'lar--searcher)
(setq searcher (lar--mk #'lar--Searcher "/home/phf" "/home/phf/.guix-profile/bin/rg"))

(lar--search searcher "089f64c7-0c56-40af-ae19-af444e163aa0" (lambda (matches) (message "%s" matches)))

(require 'lar--overlayer)
(setq overlayer (lar--mk #'lar--Overlayer searcher parser))


(require 'lar--vocabulary)

(require 'lar--parser)
(setq parser (lar--mk #'lar--Parser))

(require 'lar--searcher)
(setq searcher (lar--mk #'lar--Searcher "./" "/home/phf/.guix-profile/bin/rg"))

(require 'lar--overlayer)
(setq overlayer (lar--mk #'lar--Overlayer searcher parser))


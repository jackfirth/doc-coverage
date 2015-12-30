#lang info

(define name "docs-coverage")
(define scribblings '(("doc-coverage.scrbl" ())))
(define raco-commands
  '(("cover-doc" (submod doc-coverage/raco main) "a code documentation coverage tool" 25)))

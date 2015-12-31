#lang info

(define name "doc-coverage")
(define scribblings '(("doc-coverage.scrbl" ())))
(define raco-commands
  '(("doc-coverage" (submod doc-coverage/raco main) "a code documentation coverage tool" 25)))

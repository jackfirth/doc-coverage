#lang info

(define name "doc-coverage")
(define scribblings '(("doc-coverage.scrbl" ())))
(define deps
  '(("base" #:version "6.1")))
(define raco-commands
  '(("doc-coverage" (submod doc-coverage/raco main)
                    "a code documentation coverage tool"
                    25)))

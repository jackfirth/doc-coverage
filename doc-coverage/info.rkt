#lang info

(define name "doc-coverage")
(define collection "doc-coverage")

(define deps
  '(("base" #:version "6.3")
    "racket-index"
    "rackunit-lib"
    "reprovide-lang-lib"
    "scribble-lib"))

(define build-deps
  '("scribble-lib"
    "racket-doc"
    "rackunit-lib"))

(define scribblings '(("scribblings/main.scrbl" () (library) "doc-coverage")))

(define raco-commands
  '(("doc-coverage" (submod doc-coverage/private/raco main)
                    "a code documentation coverage tool"
                    25)))

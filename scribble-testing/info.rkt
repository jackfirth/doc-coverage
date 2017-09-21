#lang info

(define collection "scribble")

(define scribblings
  '(("testing/scribblings/main.scrbl"
     ()
     ("Testing")
     "scribble-testing")))

(define deps
  '("base"
    "expect"
    "rackunit"
    "reprovide-lang"))
(define build-deps '("racket-doc"
                     "scribble-lib"))

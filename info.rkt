#lang info

(define collection 'multi)
(define deps '("base" "rackunit-lib" "scribble-lib" "racket-index"))
(define build-deps '("scribble-lib"
                     "rackunit-lib"
                     "racket-doc"))

(define cover-omit-paths
  '(#rx".*\\.scrbl"
    #rx"info\\.rkt"
    ))

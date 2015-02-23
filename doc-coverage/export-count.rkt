#lang racket

(require rackunit
         "export-lists.rkt")

(provide module-num-exports
         module-num-documented-exports
         module-num-undocumented-exports
         module-documentation-ratio)

(define module-num-exports (compose length module->all-exported-names))
(define module-num-documented-exports (compose length module->documented-exported-names))
(define module-num-undocumented-exports (compose length module->undocumented-exported-names))

(module+ test
  (check-eqv? (module-num-exports 'racket/match) 28)
  (check-eqv? (module-num-documented-exports 'racket/match) 27)
  (check-eqv? (module-num-undocumented-exports 'racket/match) 1))

(define (module-documentation-ratio mod)
  (/ (module-num-documented-exports mod)
     (module-num-exports mod)))

(module+ test
  (check-eqv? (module-documentation-ratio 'racket/match) (/ 27 28)))
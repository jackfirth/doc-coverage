#lang racket

(require "export-lists.rkt")

(define module-num-exports (compose length module->all-exported-names))
(define module-num-documented-exports (compose length module->documented-exported-names))
(define module-num-undocumented-exports (compose length module->undocumented-exported-names))

(define (module-documentation% mod)
  (/ (module-num-documented-exports mod)
     (module-num-undocumented-exports mod)))

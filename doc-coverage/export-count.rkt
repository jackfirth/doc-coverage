#lang racket

(require "export-lists.rkt")

(provide module-num-exports
         module-num-documented-exports
         module-num-undocumented-exports
         module-documentation-ratio)

(define module-num-exports (compose length module->all-exported-names))
(define module-num-documented-exports (compose length module->documented-exported-names))
(define module-num-undocumented-exports (compose length module->undocumented-exported-names))

(define (module-documentation-ratio mod)
  (/ (module-num-documented-exports mod)
     (module-num-exports mod)))

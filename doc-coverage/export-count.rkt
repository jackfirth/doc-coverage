#lang racket

(provide module-num-exports
         module-num-documented-exports
         module-num-undocumented-exports
         module-documentation-ratio)

(require compose-app
         "export-lists.rkt")

(define module-num-exports (length .. module->all-exported-names))

(define module-num-documented-exports
  (length .. module->documented-exported-names))

(define module-num-undocumented-exports
  (length .. module->undocumented-exported-names))

(define (module-documentation-ratio mod)
  (/ (module-num-documented-exports mod)
     (module-num-exports mod)))

#lang racket

(require scribble/xref
         setup/xref
         racket/syntax
         rackunit)

(provide module->all-exported-names
         module->documented-exported-names
         module->undocumented-exported-names
         has-docs?)

(define xref (load-collections-xref))

(define (phase-exported-names phase-exports)
  (map first phase-exports))

(define (phase-exports->names exports)
  (map first
       (apply append (map (curryr drop 1) exports))))

(define (module->all-exported-names mod)
  (let-values ([(exp-values exp-syntax) (module->exports mod)])
    (append (phase-exports->names exp-values)
            (phase-exports->names exp-syntax))))

(define (has-docs? mod binding)
  (not (not (xref-binding->definition-tag xref (list mod binding) #f))))

(define (module->documented-exported-names mod)
  (filter (curry has-docs? mod)
          (module->all-exported-names mod)))

(define (module->undocumented-exported-names mod)
  (filter-not (curry has-docs? mod)
              (module->all-exported-names mod)))

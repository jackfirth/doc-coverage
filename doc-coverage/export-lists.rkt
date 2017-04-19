#lang racket

(provide module->all-exported-names
         module->documented-exported-names
         module->undocumented-exported-names
         has-docs?)

(require scribble/xref
         setup/xref)


(define (xref-mod+binding->definition-tag mod binding #:xref [xref #f])
  (xref-binding->definition-tag (or xref (load-collections-xref))
                                (list mod binding)
                                #f))

(define (has-docs? mod binding)
  (and (xref-mod+binding->definition-tag mod binding) #t))

(define (phase-exports->names exports)
  (map first
       (apply append (map (curryr drop 1) exports))))

(define (module->all-exported-names mod)
  (let-values ([(exp-values exp-syntax) (module->exports mod)])
    (append (phase-exports->names exp-values)
            (phase-exports->names exp-syntax))))

(define (module->documented-exported-names mod)
  (filter (curry has-docs? mod) (module->all-exported-names mod)))

(define (module->undocumented-exported-names mod)
  (filter-not (curry has-docs? mod)
              (module->all-exported-names mod)))

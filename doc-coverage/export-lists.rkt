#lang racket

(provide module->all-exported-names
         module->documented-exported-names
         module->undocumented-exported-names
         has-docs?)

(require compose-app/fancy-app
         scribble/xref
         setup/xref)


(define (xref-mod+binding->definition-tag mod binding #:xref [xref #f])
  (xref-binding->definition-tag (or xref (load-collections-xref))
                                (list mod binding)
                                #f))

(define (has-docs? mod binding)
  (and (xref-mod+binding->definition-tag mod binding) #t))

(define phase-exports->names
  (map first _ .. apply append _ .. map (drop _ 1) _))

(define (module->all-exported-names mod)
  (let-values ([(exp-values exp-syntax) (module->exports mod)])
    (append (phase-exports->names exp-values)
            (phase-exports->names exp-syntax))))

(define (module->documented-exported-names mod)
  (filter (has-docs? mod _) (module->all-exported-names mod)))

(define (module->undocumented-exported-names mod)
  (filter-not (has-docs? mod _)
              (module->all-exported-names mod)))

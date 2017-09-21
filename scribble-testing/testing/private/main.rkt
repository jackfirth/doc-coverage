#lang racket

(require expect
         fancy-app
         scribble/manual-struct
         scribble/xref
         setup/xref
         (only-in expect/rackunit fail-check/expect)
         (only-in rackunit define-check))


(struct export-context context () #:transparent)
(define the-export-context (export-context "the module's set of exports"))

(struct index-context context () #:transparent)
(define the-index-context
  (index-context "the module's set of documented exports"))

(define current-xref-promise (make-parameter (delay (load-collections-xref))))
(define (current-xref) (force (current-xref-promise)))

(define (module-exports mod)
  (dynamic-require mod #f)
  (define-values (value syntax) (module->exports mod))
  (list->set (map first (append-map rest (append value syntax)))))

(define (module-export-entry? ent mod)
  (define desc (entry-desc ent))
  (and (exported-index-desc? desc)
       (member mod (exported-index-desc-from-libs desc))
       #t))

(define (module-indexed mod)
  (define entries
    (filter (module-export-entry? _ mod) (xref-index (current-xref))))
  (list->set (map exported-index-desc-name (map entry-desc entries))))

(define (expect-module-exports set-exp)
  (define e
    (expect/context (expect/proc (->expectation set-exp) module-exports)
                    the-export-context))
  (expectation-rename (expect-and (expect-pred module-path?) e)
                      'module-exports))

(define (expect-module-indexed set-exp)
  (define e
    (expect/context (expect/proc (->expectation set-exp) module-indexed)
                    the-index-context))
  (expectation-rename (expect-and (expect-pred module-path?) e)
                      'module-indexed))

(define expect-module-documented
  (expect/dependent (λ (mod) (expect-module-indexed (module-exports mod)))))

(module+ main
  (require expect/rackunit)
  (check-expect 'racket/math expect-module-documented))

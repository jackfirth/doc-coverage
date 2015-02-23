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

(define (has-docs? mod binding)
  (not (not (xref-binding->definition-tag xref (list mod binding) #f))))

(module+ test
  (check-true (has-docs? 'racket/list 'second))
  (check-false (has-docs? 'racket/match 'match-...-nesting)))

(define (module->all-exported-names mod)
  (let-values ([(exp-values exp-syntax) (module->exports mod)])
    (append (phase-exports->names exp-values)
            (phase-exports->names exp-syntax))))

(module+ test
  (check-equal? (module->all-exported-names 'racket/match)
                '(legacy-match-expander?
                  match-...-nesting
                  match-expander?
                  prop:legacy-match-expander
                  prop:match-expander
                  syntax-local-match-introduce
                  exn:misc:match?
                  match-equality-test
                  match-define-values
                  define-match-expander
                  match
                  define/match
                  match*/derived
                  match/derived
                  match/values
                  match-letrec
                  match-define
                  match-let*-values
                  match-let-values
                  match-let*
                  match-let
                  match-lambda**
                  match-lambda
                  match*
                  failure-cont
                  ==
                  struct*
                  match-lambda*)))

(define (module->documented-exported-names mod)
  (filter (curry has-docs? mod)
          (module->all-exported-names mod)))

(module+ test
  (check-equal? (module->documented-exported-names 'racket/match)
                '(legacy-match-expander?
                  match-expander?
                  prop:legacy-match-expander
                  prop:match-expander
                  syntax-local-match-introduce
                  exn:misc:match?
                  match-equality-test
                  match-define-values
                  define-match-expander
                  match
                  define/match
                  match*/derived
                  match/derived
                  match/values
                  match-letrec
                  match-define
                  match-let*-values
                  match-let-values
                  match-let*
                  match-let
                  match-lambda**
                  match-lambda
                  match*
                  failure-cont
                  ==
                  struct*
                  match-lambda*)))

(define (module->undocumented-exported-names mod)
  (filter-not (curry has-docs? mod)
              (module->all-exported-names mod)))

(module+ test
  (check-equal? (module->undocumented-exported-names 'racket/match)
                '(match-...-nesting)))
#lang racket

(require "export-lists.rkt"
         "export-count.rkt"
         rackunit)

(provide check-all-documented
         check-documented
         check-documentation-ratio)

(define (fail-check-unless cond msg)
  (unless cond (fail-check msg)))

(define-check (check-all-documented module-name)
  (let* ([undocumented (module->undocumented-exported-names module-name)]
         [num-undocumented (length undocumented)])
    (fail-check-unless (zero? num-undocumented)
      (check-all-documented-message module-name num-undocumented undocumented))))

(module+ test
  (check-not-exn (thunk check-all-documented 'racket/promise)))

(define (check-all-documented-message module-name num-undocumented undocumented)
  (string-append "Module "
                 (symbol->string module-name)
                 " has "
                 (number->string num-undocumented)
                 " undocumented bindings:\n\n"
                 (string-join (map symbol->string undocumented)
                              "\n")))

(module+ test
  (check string=?
         (check-all-documented-message 'foo 8 '(foo1 foo2 foo3))
         "Module foo has 8 undocumented bindings:\n\nfoo1\nfoo2\nfoo3"))

(define-check (check-documented module-name binding)
  (fail-check-unless (has-docs? module-name binding)
    (check-documented-message module-name binding)))

(module+ test
  (check-not-exn (thunk (check-documented 'racket/match 'match))))

(define (check-documented-message module-name binding)
  (string-append "Module "
                 (symbol->string module-name)
                 " does not document binding "
                 (symbol->string binding)))

(module+ test
  (check string=?
         (check-documented-message 'foo 'foo1)
         "Module foo does not document binding foo1"))

(define-check (check-documentation-ratio module-name minimum-ratio)
  (let ([actual-ratio (module-documentation-ratio module-name)])
    (fail-check-unless (>= actual-ratio minimum-ratio)
      (check-documentation-ratio-message module-name minimum-ratio actual-ratio))))

(define (check-documentation-ratio-message module-name minimum-ratio actual-ratio)
  (string-append "Module "
                 (symbol->string module-name)
                 " does not document at least "
                 (number->string (exact->inexact (* 100 minimum-ratio)))
                 "% of its bindings, only documents "
                 (number->string (exact->inexact (* 100 actual-ratio)))
                 "%"))

(module+ test
  (check string=?
         (check-documentation-ratio-message 'foo 0.5 0.25)
         "Module foo does not document at least 50.0% of its bindings, only documents 25.0%"))
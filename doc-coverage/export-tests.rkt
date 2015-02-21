#lang racket

(require "export-lists.rkt"
         "export-count.rkt"
         rackunit)

(provide check-all-documented
         check-documented
         check-documentation-ratio)

(define-check (check-all-documented module-name)
  (let* ([undocumented (module->undocumented-exported-names module-name)]
         [num-undocumented (length undocumented)])
    (unless (zero? num-undocumented)
      (fail-check (check-all-documented-message module-name num-undocumented undocumented)))))

(define (check-all-documented-message module-name num-undocumented undocumented)
  (string-append "Module "
                 (symbol->string module-name)
                 " has "
                 (number->string num-undocumented)
                 " undocumented bindings:\n\n"
                 (string-join (map symbol->string undocumented)
                              "\n")))

(define-check (check-documented module-name binding)
  (unless (has-docs? module-name binding)
    (fail-check
     (string-append "Module "
                    (symbol->string module-name)
                    " does not document binding "
                    (symbol->string binding)))))

(define-check (check-documentation-ratio module-name minimum-ratio)
  (let ([actual-ratio (module-documentation-ratio module-name)])
    (unless (>= actual-ratio minimum-ratio)
      (fail-check
       (string-append "Module "
                      (symbol->string module-name)
                      " does not document at least "
                      (number->string (exact->inexact (* 100 minimum-ratio)))
                      "% of its bindings, only documents "
                      (number->string (exact->inexact (* 100 actual-ratio)))
                      "%")))))
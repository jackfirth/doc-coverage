#lang racket

(require raco/command-name
         racket/cmdline
         rackunit/docs-complete
         "main.rkt")

(module+ main

  (define binding (make-parameter #f))
  (define ratio (make-parameter #f))
  (define ignore (make-parameter #f))
  (define error-on-exit? (make-parameter #f))

  (define args
    (command-line
     #:program (short-program+command-name)
     #:once-any
     [("-b" "--binding") b
      "Check the documentation for a specific binding"
      (binding (string->symbol b))]
     [("-r" "--ratio") r
      "Specify required documentation ratio"
      (ratio (string->number r))]
     [("-s" "--skip") s
      "Specify regex of bindings to ignore"
      (ignore (regexp s))]
     #:args (file . files)
     (cons file files)))

  (for ([a (in-list args)])
    (let/ec break

      (with-handlers ([exn:fail? (lambda (e)
                                   (set! a (string->symbol a)))])
        (namespace-require a))
      (with-handlers ([exn:fail? (lambda (e)
                                   (fprintf (current-error-port) "Module ~a can not be loaded~n" a)
                                   (error-on-exit? #t)
                                   (break))])
        (namespace-require a))

      (cond [(binding)
             (cond [(set-member? (module->all-exported-names a) (binding))
                    (define b* (has-docs? a (binding)))
                    (cond [b* (printf "Module ~a has documentation for ~a~n" a (binding))]
                          [else (printf "Module ~a is missing documentation for ~a~n" a (binding))
                                (error-on-exit? #t)])]
                   [else
                    (fprintf (current-error-port) "Module ~a does not export ~a~n" a (binding))
                    (error-on-exit? #t)])]
            [(ratio)
             (define r* (module-documentation-ratio a))
             (printf "Module ~a document aatio: ~a~n" a r*)
             (when (r* . < . (ratio))
               (error-on-exit? #t))]
            [(ignore)
             (define missing
               (with-output-to-string
                 (lambda ()
                   (parameterize ([current-error-port (current-output-port)])
                     (check-docs a #:skip (ignore))))))
             (match missing
               ["" (printf "Module ~a is documented~n" a)]
               [else (printf "Module ~a is missing documentation for ~a~n" a missing)])]
            [else
             (define undoc (module->undocumented-exported-names a))
             (cond [(set-empty? undoc)
                    (printf "Module ~a is completely documented~n" a)]
                   [else
                    (printf "Module ~a is missing documentation for: ~a~n" a undoc)
                    (error-on-exit? #t)])])))

  (when (error-on-exit?)
    (exit 1)))

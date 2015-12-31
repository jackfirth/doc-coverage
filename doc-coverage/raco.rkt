#lang racket

(require raco/command-name
         racket/cmdline
         rackunit/docs-complete
         "main.rkt")

(module+ test
  (require rackunit
           rackunit/text-ui
           compiler/find-exe))

; do-ignore! : (U string symbol) regex -> boolean
(define (do-ignore! mod ignore)
  (error "Ignore not implemented yet")
  #f
  #;(define missing
    (with-output-to-string
      (lambda ()
        (parameterize ([current-error-port (current-output-port)])
          (check-docs mod #:skip ignore)))))
  #;(match missing
    ["" (printf "Module ~a is documented~n" a) #t]
    [else (printf "Module ~a is missing documentation for ~a~n" a missing) #f]))

; do-binding! : (U string symbol) symbol -> boolean
(define (do-binding! mod binding)
  (cond [(set-member? (module->all-exported-names mod) binding)
         (define b* (has-docs? mod binding))
         (cond [b* (printf "Module ~a has documentation for ~a~n" mod binding)
                   #t]
               [else (printf "Module ~a is missing documentation for ~a~n" mod binding)
                     #f])]
        [else
         (fprintf (current-error-port) "Module ~a does not export ~a~n" mod binding)
         #f]))

; try-namespace-require : string -> (U string symbol #f)
(define (try-namespace-require mod)
  (let/ec return
    (with-handlers ([exn:fail? (lambda (e)
                                 (set! mod (string->symbol mod)))])
      (namespace-require mod)
      (return mod))
    (with-handlers ([exn:fail? (lambda (e)
                                 (fprintf (current-error-port) "Module ~a can not be loaded~n" mod)
                                 (return #f))])
      (namespace-require mod)
      (return mod))))

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

  ; Loop over all found modules
  (for ([a (in-list args)])

    ; Determin if module exists
    (define mod (try-namespace-require a))

    ; If we succeeded in importing the module run the correct operation
    (when mod
      (cond [(binding)
             (when (do-binding! mod (binding))
               (error-on-exit? #t))]
            [(ratio)
             (define r* (module-documentation-ratio mod))
             (printf "Module ~a document ratio: ~a~n" mod r*)
             (when (r* . < . (ratio))
               (error-on-exit? #t))]
            [(ignore)
             (when (do-ignore! mod (ignore))
               (error-on-exit? #t))]
            [else
             (define undoc (module->undocumented-exported-names mod))
             (cond [(set-empty? undoc)
                    (printf "Module ~a is completely documented~n" mod)]
                   [else
                    (printf "Module ~a is missing documentation for: ~a~n" a undoc)
                    (error-on-exit? #t)])])))

  (when (error-on-exit?)
    (exit 1)))

(module+ test
  (check-equal?
   (with-output-to-string
     (lambda () (system* (find-exe) "-l" "raco" "doc-coverage" "racket/base")))
   "Module racket/base is missing documentation for: (expand-for-clause for-clause-syntax-protect syntax-pattern-variable?)\n")
  (check-equal?
   (with-output-to-string
     (lambda () (system* (find-exe) "-l" "raco" "doc-coverage" "-r" "0.5" "racket/match")))
   "Module racket/match document ratio: 28/29\n")
  (check-equal?
   (with-output-to-string
     (lambda () (system* (find-exe) "-l" "raco" "doc-coverage" "-b" "match" "racket")))
   "Module racket has documentation for match\n"))


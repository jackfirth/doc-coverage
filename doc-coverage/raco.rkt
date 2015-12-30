#lang racket

(require raco/command-name
         racket/cmdline
         rackunit/docs-complete
         "main.rkt")

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

; try-namespace-require : string -> (U 'string 'symbol #f)
(define (try-namespace-require mod)
  (let/ec return
    (with-handlers ([exn:fail? (lambda (e)
                                 (set! mod (string->symbol mod)))])
      (namespace-require mod)
      (return 'string))
    (with-handlers ([exn:fail? (lambda (e)
                                 (fprintf (current-error-port) "Module ~a can not be loaded~n" mod)
                                 (return #f))])
      (namespace-require mod)
      (return 'symbol))))

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
    (define mod-exists? (try-namespace-require a))

    ; If the module was required a symbol, we must convert `a` to a symbol too.
    (when (equal? mod-exists? 'symbol)
      (set! a (string->symbol a)))

    ; If we succeeded in importing the module run the correct operation
    (when mod-exists?
      (cond [(binding)
             (when (do-binding! a (binding))
               (error-on-exit? #t))]
            [(ratio)
             (define r* (module-documentation-ratio a))
             (printf "Module ~a document ratio: ~a~n" a r*)
             (when (r* . < . (ratio))
               (error-on-exit? #t))]
            [(ignore)
             (when (do-ignore! a (ignore))
               (error-on-exit? #t))]
            [else
             (define undoc (module->undocumented-exported-names a))
             (cond [(set-empty? undoc)
                    (printf "Module ~a is completely documented~n" a)]
                   [else
                    (printf "Module ~a is missing documentation for: ~a~n" a undoc)
                    (error-on-exit? #t)])])))

  (when (error-on-exit?)
    (exit 1)))

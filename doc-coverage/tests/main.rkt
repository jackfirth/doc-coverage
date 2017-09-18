#lang racket

(provide undocumented-binding)

(module+ test
  (require doc-coverage
           rackunit))


(define undocumented-binding #f)

(module+ test
  (check-equal? (module->all-exported-names 'doc-coverage)
                '(has-docs?
                  module->all-exported-names
                  module->documented-exported-names
                  module->undocumented-exported-names
                  module-documentation-ratio
                  module-num-documented-exports
                  module-num-exports
                  module-num-undocumented-exports
                  check-all-documented
                  check-documentation-ratio
                  check-documented))
  (check-all-documented 'doc-coverage)
  (check-documented 'doc-coverage 'check-documented)
  (check-documentation-ratio 'doc-coverage 1)
  (check-documentation-ratio 'doc-coverage/tests/main 0)
  (check-equal? (module-num-exports 'doc-coverage) 11)
  (check-equal? (module-num-documented-exports 'doc-coverage)
                (module-num-exports 'doc-coverage))
  (check-equal? (module-num-undocumented-exports 'doc-coverage) 0)
  (check-equal? (module-num-undocumented-exports 'doc-coverage/tests/main) 1)
  (check-equal? (module-documentation-ratio 'doc-coverage) 1)
  (check-equal? (module-documentation-ratio 'doc-coverage/tests/main) 0))

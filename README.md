doc-coverage [![Build Status](https://travis-ci.org/jackfirth/doc-coverage.svg)](https://travis-ci.org/jackfirth/doc-coverage) [![codecov](https://codecov.io/gh/jackfirth/doc-coverage/branch/master/graph/badge.svg)](https://codecov.io/gh/jackfirth/doc-coverage)
=====================================================
[Documentation](http://pkg-build.racket-lang.org/doc/doc-coverage/index.html)

A Racket package for inspecting and testing the number of documented exports of a module

Examining module documentation information:

```racket
> (module->all-exported-names 'racket/promise)
'(force
  promise-forced?
  promise-running?
  promise?
  delay
  delay/thread
  delay/name
  lazy
  delay/sync
  delay/strict
  delay/idle)
> (module->undocumented-exported-names 'racket/match)
'(match-...-nesting)
```

Testing module documentation coverage

```racket
> (check-all-documented 'racket/base)
--------------------
FAILURE
name:       check-all-documented
location:   (unsaved-editor307 30 2 704 35)
expression: (check-all-documented 'racket/base)
params:     (racket/base)

Module racket/base has 3 undocumented bindings:

expand-for-clause
for-clause-syntax-protect
syntax-pattern-variable?
--------------------
> (check-documentation-ratio 'racket/match .99)
--------------------
FAILURE
name:       check-documentation-ratio
location:   (unsaved-editor307 45 2 1113 45)
expression: (check-documentation-ratio 'racket/match 0.99)
params:     (racket/match 0.99)

Module racket/match does not document at least 99.0% of its bindings, only documents 96.42857142857143%
--------------------
```

To install, `run raco pkg install doc-coverage`. Then to use in a module, `(require doc-coverage)`.

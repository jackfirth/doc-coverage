#lang scribble/manual

@(require scribble/eval
          (for-label doc-coverage
                     racket/base))

@title{doc-coverage}

@(define the-eval (make-base-eval))
@(the-eval '(require "main.rkt"))

@defmodule[doc-coverage]

@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

This library provides functions for inspecting the number of 
bindings a module exports with and without corresponding
Scribble documentation, as well as Rackunit tests based on
this information. This allows a module author to enforce in
a test suite that their modules provide no undocumented
bindings.

source code: @url["https://github.com/jackfirth/package-name"]

@section{Basic Module Documentation Reflection}

@defproc[(has-docs? [mod symbol?] [binding symbol?]) boolean?]{
  Returns @racket[#t] if the module @racket[mod] provides
  @racket[binding] with documentation, and @racket[#f]
  otherwise.
  @examples[#:eval the-eval
    (has-docs? 'racket/list 'second)
    (has-docs? 'racket/match 'match-...-nesting)
]}
#lang scribble/manual

@(require scribble/eval
          (for-label doc-coverage
                     racket/base))

@title{package-name}

@(define the-eval (make-base-eval))
@(the-eval '(require "main.rkt"))

@defmodule[doc-coverage]

@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

source code: @url["https://github.com/jackfirth/package-name"]
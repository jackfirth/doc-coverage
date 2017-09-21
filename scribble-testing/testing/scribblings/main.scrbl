#lang scribble/manual
@(require "base.rkt")

@(define source-url "https://github.com/jackfirth/doc-coverage")
@(define license-url
   "https://github.com/jackfirth/doc-coverage/blob/master/LICENSE")

@title{Testing Scribble Documentation}
@defmodule[scribble/testing]
@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

This library provides @racketmodname[rackunit] checks and @exp-tech{
 expectations} for testing various properties of Scribble documentation. With
these tools it is possible to:

@(itemlist
  @item{Enforce that all exported identifiers of a module, collection, or
 package have accompanying documentation.}
  @item{Enforce that documentation does not document identifiers or modules that
 do not exist.}
  @item{Enforce that bindings provided from multiple modules (for example,
 @racketmodname[racket] reprovides everything in
 @racketmodname[racket/contract/base]) are properly documented.}
  @item{Enforce that documented procedures are provided with contracts.}
  @item{Enforce that documented procedures have an appropriate
 @racket[object-name].})

Source code for this library is available @hyperlink[source-url]{on Github} and
is provided under the terms of the @hyperlink[license-url]{Apache License 2.0}.

@section{Testing Docs with Rackunit}

@defproc[(check-binding-indexed [sym symbol?]
                                [mod-path module-path?]
                                [msg string? ""])
         void?]{
 A @racketmodname[rackunit] check that asserts that the binding named
 @racket[sym] provided from @racket[mod-path] is documented.}

- check-binding-indexed? sym mod-path
- check-module-indexed? mod-path
  - check that modules actual exports are all indexed
  - also check that all indexed entries that claim to be from mod-path actually are
- check-package-indexed? package-name
  - calls check-module-indexed? on all "public modules" of package-name

@section{Testing Docs with Expectations}

@section{Controlling Cross Reference Tables}

@defparam[current-xref-promise xref-promise (promise/c xref?)
          #:value (delay (load-collections-xref))]{
 A @param-tech{parameter} that controls what cross reference table is consulted
 by @racketmodname[scribble/testing]. This parameter is a promise to ensure that
 loading an @racket[xref?] object only occurs once, as it is potentially
 expensive. Note that @racket[load-collections-xref] internally caches the
 cross reference table it produces.}

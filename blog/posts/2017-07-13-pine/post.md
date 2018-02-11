---
title: Build me a DSL for great good [1]
comments: true
---

## Haskell intrigues me

Haskell is one of those languages that has a crazy learning curve - at least I
have been struggling with it. However, the idea that one should first focus on
the type of data in the domain and only then figure out transformations between
them really appeals to me. It might be that after getting a good enough
understanding of language, I'll settle for something else like a more dynamic
and permissive language for everyday hacking (like Clojure) but my curiosity for
all the ideas that Haskell has to offer doesn't seem to fade away - so I'll
continue to bang my head against the wall...

## Build me a DSL : "pine"

I have started building a domain specific language that will let me interact
with rest APIs in a more intuitive manner. This is what I want to do:

Let's say I have the following resources in my API

- **Customer:**
    * id
    * name
- **User:**
    * id
    * name
    * customerId
- **Address:**
    * id
    * street
    * userId

I would like to write something like this using the language:

``` bash
customers "Acme Inc." | addresses
```

and the language should be able to figure out the relationship between the
customer "Acme" and all the addresses that belong to the users of the company.
The runtime should fire the relevant requests using the rest API and find me
what I need. I want to **combine any number of resources and filter the data**.
It is basically **unix pipes that work with types** and have filtering
functionality built in.

At a later point, I would like to separate the data fetching layer (that fires
API requests) and build a SQL component as well which will make it possible to
fetch data from a database instead of only HTTP requests.

To begin with, I'll target Penneo's public API for this experiment. Inspired by
pipes and focusing on Penneo's API as a starting point, I have named the
language **pine**. Also, pine trees look kind of like pipes :)

You can follow the project here: **[pine][pine]**

I'll be writing about my progress related to building this language and share
those 'aha' moments from time to time...

## 1. Using Stack instead of Cabal
Stack is the new way of setting up projects and I'll use that from now on
instead of cabal. Stack groks the cabal format (as it is the same on some
level). Setting up a project in stack is simple:

``` bash
stack new app
cd app
stack build app
stack exec app-exe
```

## 2. Adding dependencies in Stack is inconvenient
Adding dependencies in stack is not as simple as it is when using npm (node) or
composer (php). I would expect to add a dependency like this:

``` bash
stack install --save lib # --save switch doesn't exist !!
```

I have to manually update the .cabal file for the project e.g. `app.cabal` that
stack uses.

The reason for this could be that stack sets up dependencies for all the things
that it builds and therefore keeps the dependencies separate. Just using a
`--save` switch without specifying the dependent module doesn't make sense.


Here is an issue open related to
this:
[stack install package --save to add a dependency to the cabal file][stack-dep]

Anyway, here is a snippet from the pine's cabal file (`pine.cabal`) that I had
to modify manually:

```
library
  ... 
  exposed-modules:     Lib
                     , Model
  build-depends:       base >= 4.7 && < 5
                     , lens
                     , aeson

executable pine-exe
  ...
  main-is:             Main.hs
  ...
  build-depends:       base
                     , pine
                     , bytestring
```

I think this makes it possible for to use two different versions of the same
library in the project. Anyway, adding a dependency to stack becomes a little
bit inconvenient because of this

## 3. Find the versions for dependencies

Once you have dependencies installed and given that no version is specified in the cabal file, they can be found as follows:

``` bash
stack list-dependencies | grep mysql-simple
```

## 4. Language Extensions
Haskell's default behavior is quite restrictive. In order to loosen the behavior
and make some cases more convenient to write, language extensions can be enabled
either by using switches from the command line (`ghc` supports this, not sure
about `hugs` and other compilers) or by adding language directives / `LANGUAGE
PRAGMA` at the top of the file e.g. implicit conversion between different string
types in haskell can be achieved by adding the following at the top of the file:

``` haskell
{-# LANGUAGE OverloadedStrings #-}
```


## What's next?

- Use the `wreq` library to make API requests and the `lens` library to parse the responses
- Make authenticated requests to the server
- Write the basic domain model (with just one data type) and try to convert the
  json responses that type
- Use the `parsec` library to write the parser. I won't focus on that part until
  I have the basic functionality in place

Stay tuned!

[pine]: https://github.com/ahmadnazir/pine
[stack-dep]: https://github.com/commercialhaskell/stack/issues/1933


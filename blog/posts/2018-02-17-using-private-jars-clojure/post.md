---
title: Using private jars in Clojure
---

One of the many things that makes clojure an extremely practical tool is that it can be used to explore other java libraries - no compiling needed - *a faster feed back loop!* However, we need to ensure a few things before loading *private* jar files into clojure. In this post, I am documenting what works for me for a test project packaged as `com.acme.soup`.

Let's say that we have the following:

``` java
package com.acme.soup;

public class Soup
{
    public void make()
    {
        System.out.println( "Making soup!" );
    }
}
```

The objective is to call `make` on an instance of `Soup` inside Clojure.

For Java projects, I am using [maven][maven] and for Clojure I am using [leiningen][leiningen].

## Create the jars from the maven project ##

The jars can be created using:

```
mvn package
```

However, this doesn't create the check sums (which is needed by leiningen in order to load the jar files). So, we can call `install` with the `createChecksum` switch:

```
mvn install -DcreateChecksum=true
```


Considering that the project is packaged as `com.acme.soup`, all relevant files will be available at `~/.m2/repository/com/acme/soup`

## Using the jars in the leiningen project ##

### Create a directory structure that acts as a local repository ###

```
mkdir localrepo
```

The local repository can't just contain plain jar files, the structure needs to match the package structure of the jars being imported. Once you have copied the files, it should like like this:

```
tree localrepo -L 5

localrepo
└── com
    └── acme
        └── soup
            └── soup
                ├── 1.0-SNAPSHOT
                ├── maven-metadata-local.xml
                ├── maven-metadata-local.xml.md5
                └── maven-metadata-local.xml.sha1
```


### Configure leiningen###

The local repository needs to be added to the project so that leiningen knows where to load the dependencies from, in case they are not found in any public maven repository or clojars. The following needs to be added to the `project.clj` file:

``` clojure
  :repositories {"project" "file:repo"}
```

Continue to add the dependencies you would normally do:

``` clojure
  :dependencies [
    [com.acme.soup/soup "1.0-SNAPSHOT"]
  ]
```

### Loading the dependency in clojure code ###

The dependency needs to be *imported*, e.g. if the namespace is `com.acme.soup` and the class is `Soup`, then the following needs to be added to the `ns` expression

``` clojure
(ns soup.core
  (:import [com.acme.soup Soup]))
```

A new instance of `Soup` is created as follows:

``` clojure
(.make (Soup.))
```

or something that I prefer:

``` clojure
(-> (Soup.)  ;; Create a instance of soup
    (.make)) ;; Call native functions on it
```

That makes me very *happy happy joy joy!* :D

[maven]: https://maven.apache.org/
[leiningen]: https://leiningen.org/

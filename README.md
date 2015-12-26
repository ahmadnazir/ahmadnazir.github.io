Porting the original blog (ahmadnazir.github.io) that was using jekyll to hakyll

# Setup

```
cabal sandbox init
cabal install hakyll
.cabal-sandbox/bin/hakyll-init blog
cabal exec ghc blog/site.hs
```

# Adding posts

Once a post is added, the site has to be built again. This can be done
by either running the `build` target or the `watch` target`.

```
cd blog
./site build
```

or

```
./site watch # localhost:8000
```

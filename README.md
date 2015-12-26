Porting the original blog (ahmadnazir.github.io) that was using jekyll to hakyll

# Setup

```
cabal sandbox init
cabal install hakyll
.cabal-sandbox/bin/hakyll-init blog
cd blog
./site build
./site watch # localhost:8000
```

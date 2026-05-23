# blog.neil.mayhew.name #

## Local Development ##

### Content ###

```sh
nix build
result/bin/site watch
```

Open <http://localhost:8000/>

### Haskell ###

```sh
nix develop .#dynamic
cabal run -- site watch
```

Open <http://localhost:8000/>

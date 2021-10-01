## setting up

in a shell:

```
rm README.md 
mv README_template.md README.md
```

## adding packages

in R console:

```R
renv::init()
```

## managing the repo

in a shell:

```
git add -A && git commit -m "init repo"
git push
git tag -a 0.0.1 -m "++" && git push --tags
```

## commit message format

see https://github.com/tercen/generate-changelog-action
see https://github.com/lob/generate-changelog#usage


# OpenSAFELY Research Action

This repo provides a GitHub Action for verifying that
[OpenSAFELY](https://docs.opensafely.org/) research repos can run
correctly.

It is written as a "[composite run steps][1]" action.


## Tests

The action is tested in CI by running it against a known good commit of
a testing project. You can test it locally by running:
```
./test.sh
```

[1]: https://docs.github.com/en/actions/creating-actions/creating-a-composite-run-steps-action

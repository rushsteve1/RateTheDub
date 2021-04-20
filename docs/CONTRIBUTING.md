# Contributing Guidelines

First of all, thank you for thinking about contributing to RateTheDub! This
project is a labor of love by it's developers, so any and all help is greatly
appreciated!

At present we do not yet have a Code of Conduct. It may be added at a later date
if deemed necessary.

**All development and contributions are to be conduction in English.**
For better or worse this has become the Lingua Franca of the software
development world.

## Bug Reports and Feature Suggestions

Please use the
[RateTheDub GitHub Issue Tracker](https://github.com/rushsteve1/RateTheDub/issues)
for any bug reports and feature requests. Please fill out the templates and
provide as much information as possible.

For feature requests in particular if you can explain the "what, why, and how"
of the feature your proposing and to explain it as clearly as possible. This
helps us to understand exactly what you want so that we can implement it.

## Database Change Requests

**Please do not open GitHub issues for Database Changes**

Requests for changes to the official database, such as missing or incorrect
information about anime series, can be made by messaging the [RateTheDub Twitter
Account](https://twitter.com/RateTheDub) for now. We intend to have a more
official means of taking change requests in the future.

## Translations

Translation support is currently a Work-In-Progress, so more on this is coming
soon!

## Contributing Code

Thank you in advance for wanted to contribute code to RateTheDub! Every
contribution, big or small, makes a difference!

Contributions are accepted as Pull Requests on the
[RateTheDub GitHub Repo](https://github.com/rushsteve1/RateTheDub).

Unless otherwise state all contributions are licensed under the
[Apache 2.0 license](../LICENSE)
that this project is under. We reserve the right to reject contributions due to
licensing issues.

### Getting Setup

Read the [installation guide](./INSTALL.md) to get setup with dependencies and
get things up and running. The [`README`](../README.md) also has some
documentation on the [Phoenix Framework](https://phoenixframework.org/) that
this project uses.

### Style and Linting

Code style and linting are already setup at the project level. All contributions
should have run `mix format` prior to submission. Ideally developers should
also run `mix credo` and fix any lint issues that are reported.

As a few general rules...

- [Snake-case](https://en.wikipedia.org/wiki/Snake_case)
  variable and function names `that_look_like_this`
- Avoid short variable and function names. Names should properly explain what it
  is and does.
- Many small functions are better than a few big ones. Make use of `defp` to
  keep things clean.
- Clear code is better than clever code. Take a few extra lines to make what
  you're doing obvious.

## Reporting Security Vulnerabilities

Please see the [Security Policy](./SECURITY.md).

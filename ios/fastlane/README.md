fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Push a new beta build to TestFlight

### ios beta_with_changelog

```sh
[bundle exec] fastlane ios beta_with_changelog
```

Build and upload to TestFlight with custom changelog

### ios release

```sh
[bundle exec] fastlane ios release
```

Build app for App Store

### ios match_setup

```sh
[bundle exec] fastlane ios match_setup
```

Setup certificates and provisioning profiles for the first time

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

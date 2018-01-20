# validate_app plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-validate_app)
[![CircleCI](https://circleci.com/gh/thii/fastlane-plugin-validate_app.svg?style=svg)](https://circleci.com/gh/thii/fastlane-plugin-validate_app)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To
get started with `fastlane-plugin-validate_app`, add it to your project by
running:

```bash
fastlane add_plugin validate_app
```

## About validate_app

This plugin validates your ipa file using Application Loader's command line
tool `altool`. By default, it will take your Apple ID username from your
Appfile and password from yoru Keychain. You may specify a password directly or
pass it via `FASTLANE_PASSWORD` or `DELIVER_PASSWORD` environment variables.
Your password will not be printed out to build console log.

Returns `nil` if build is valid, and an array of error objects if
build is invalid

## Example

```
errors = validate_app(
  ipa: "YourApp.ipa"
)

if errors.nil?
  upload_to_testflight
else
  UI.user_error! "IPA file did not pass validation."
end
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this
repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins
Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out
the [Plugins
documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for
your iOS and Android apps. To learn more, check out
[fastlane.tools](https://fastlane.tools).

# Dictionary (MyOrdbok)

![alt text][logo]

MyOrdbok is 'A comprehensive Myanmar online dictionary', and providing parts of speech, thesaurus and synonyms. It is aimed to help learning english, as well as burmese vocabularies and expressions. We have 57223 primary words with over 103787 definitions which can be used to lookup with over 200000 words. Our web app supports 24 languages.

...at [App Store][appstore],
[Google play][playStore],
or [clone](#how-would-i-clone-correctly), [privacy][privacy].

Feature:

- Definition
- Example(usage)
- Parts of speech
- Thesaurus and synonyms
- Bookmark
- Search (instant suggestion and result)
- Open Source
- Offline
- Customizable
- Elegant
- No authentication require
- No Ads
- Free

As it is active in develpment, please feel free to rate/write yours review, so that we can bring a better Dictionary app.

Any concerning data [Privacy & Security][privacy].

![alt text][license]
![alt text][flutterversion]

## analytics (debug on windows)

```sh
# cd \dev\android-sdk\platform-tools
cd /dev/android-sdk/platform-tools
adb shell setprop debug.firebase.analytics.app "com.myordbok.app"
```

## How would I clone correctly

All you need is basically a Github command line, flutter, and modify a few settings, such as version, packageName for Android or Bundle Identifier for iOS. Since `com.myordbok.app` has already taken you would need you own. It does not need to be a domain path but just uniqueid, so you should not take "~~com.google~~" or anything that you don't own!

Rename `assets/mock-env.json` to **assets/env.json** and `assets/mock-word.db` to **assets/word.db**.

There isn't an easy way to separate ui and logic in flutter, any related dart scripts that plays primary logic in this application are moved to [lidea repo][lidea] as a seperated package. But they will work the same as bundle scripts.

In `pubspec.yaml` remove local package `lidea` and uncomment git

```yaml
dependencies:
  flutter:
    sdk: flutter
  ...
  # Local lidea package, only in development
  # lidea:
  #   path: ../lidea
  # Github lidea package, uncomments lines below
  lidea:
    git:
      url: git://github.com/laisiangtho/lidea.git
      ref: main
  ...
```

...you will need your own configuration in the following files, for more info please run `flutter doctor` and see if you get it right.

- `android/local.properties`

```sh
sdk.dir       = <android-sdk-path>
flutter.sdk   = <flutter-sdk-path>
```

- `android/key.properties`

```sh
storePassword = <store-file-password>
keyPassword   = <key-file-password>
keyAlias      = <key-alias-name>
storeFile     = <path-of-jks>
```

- `android/app/google-services.json`

This is a JSON formated file, you can get it from `Google console -> IAM & ADMIN -> Service Accounts` or Firebase.

## Build and config

[Android][tool-android], [iOS][tool-ios]

[appStore]: https://apps.apple.com/us/app/myordbok/id1570959654
[playStore]: https://play.google.com/store/apps/details?id=com.myordbok.app
[playStore Join]: https://play.google.com/apps/testing/com.myordbok.app/join

[webapp]: https://www.myordbok.com/
[Home]: https://github.com/laisiangtho/dictionary

[lidea]: https://github.com/laisiangtho/lidea
[tool-android]: https://github.com/laisiangtho/lidea/blob/main/TOOL.md#android
[tool-ios]: https://github.com/laisiangtho/lidea/blob/main/TOOL.md#ios

[privacy]: /PRIVACY.md

[logo]: https://raw.githubusercontent.com/laisiangtho/dictionary/master/myordbok.png "MyOrdbok"
[license]: https://img.shields.io/badge/License-MIT-yellow.svg "License"
[flutterversion]: https://img.shields.io/badge/flutter-%3E%3D%202.12.0%20%3C3.0.0-green.svg "Flutter version"

# Dictionary (MyOrdbok)

MyOrdbok is 'A comprehensive Myanmar online dictionary', and providing parts of speech, thesaurus and synonyms. It is aimed to help learning english, as well as burmese vocabularies and expressions. We have 57223 primary words with over 103787 definitions which can be used to lookup with over 200000 words. Our web app supports 24 languages.

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

## Todo

- [x] Definition makeup
- [ ] none result lookup
- [x] Cart
- [ ] analytics
- [x] History (Recent searches)
- [ ] Like
- [x] Improve scroll for NestedScrollView
- [ ] History navigator
- [ ] History view sort
- [ ] gist backup

> Flutter SDK command line tools

```shell
flutter channel stable
flutter upgrade
flutter config --enable-web
cd into project directory
flutter create .
flutter run -d chrome
```

## Android

### minSdkVersion=16

- [x] `flutter build appbundle --release`
- [ ] `flutter build appbundle --target-platform android-arm,android-arm64`
- [ ] `flutter build apk --release --target-platform=android-arm`
- [ ] `flutter build appbundle --release --target-platform=android-arm`
- [ ] `flutter run --release --target-platform=android-arm`

### minSdkVersion=21

- [ ] `flutter build appbundle --release --target-platform=android-arm64`
- [ ] `flutter build apk --release --target-platform=android-arm64`
- [ ] `flutter run --target-platform=android-arm64`
- [ ] `flutter run --enable-software-rendering --target-platform=android-arm64`
- [ ] `flutter build appbundle --release --target-platform=android-arm64`
- [ ] `flutter build apk --split-per-abi --release`

### analytics (debug on windows)

```Shell
cd C:\dev\android-sdk\platform-tools
adb shell setprop debug.firebase.analytics.app "com.myordbok.app"
```

### Directory

- (production) android/key.properties
- (development) android/local.properties
- build/app/outputs/apk/release/app-release.apk
- android\gradle.properties
- android\app\build.gradle

### Android->release

  versionCode android-arm
  versionCode++ android-arm64

```Shell
git commit -m "Update docs to wiki"
git push origin master

git add .
git commit -a -m "commit" (do not need commit message either)
git push
```

## Re-Useable

- [`idea`](#idea)
- [`scroll`](#scroll)
- [`util`](#util)

### idea

... Top layer responsible for theme color and font-size

### scroll

... Primary view scroll gesture for bar, body bottom

### util

... reading and writing file

## How would I clone correctly

All you need is basically a Github command line, flutter, and modify a few settings, such as version, packageName for Android or Bundle Identifier for iOS. Since `com.laisiangtho.bible` has already taken you would need you own. It does not need to be a domain path but just uniqueid, so you should not take "~~com.google~~" or anything that you don't own!

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

...you will need your own configuration in the following files

- `android/local.properties`

  ```Shell
  sdk.dir=pathOf-android-sdk
  flutter.sdk=pathOf-flutter-sdk
  ```

- `android/key.properties`

  ```Shell
  storePassword = STORE-FIILE-PASSWORD
  keyPassword = KEY-FIILE-PASSWORD
  keyAlias = KEY-ALIAS-NAME
  storeFile = PATH-OF-JKS
  ```

- `android/app/google-services.json`

  This is a JSON formated file, you can get it from `Google console -> IAM & ADMIN -> Service Accounts`

### for iOS

- ?

[playStore]: https://play.google.com/store/apps/details?id=com.laisiangtho.bible
[playStore Join]: https://play.google.com/apps/testing/com.laisiangtho.bible/join
[Home]: https://github.com/laisiangtho/development
[lidea]: https://github.com/laisiangtho/lidea

[logo]: https://raw.githubusercontent.com/laisiangtho/development/master/bible.png "Lai Siangtho"

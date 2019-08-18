# spirit

A Flutter app to manage your festival. Feel free to fork and change it for your need.

## How to build

`flutter run`

## How to release

Inc build number
 
`flutter build apk --target-platform android-arm,android-arm64 --split-per-abi`

Upload to playstore.

## How to regenerate app icons

```
flutter pub get
flutter pub pub run flutter_launcher_icons:main
```

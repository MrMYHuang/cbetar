#!/bin/sh
flutter build apk --split-per-abi
adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk

#!/bin/bash

# Debug
set -o xtrace

flutter build apk --multidex --no-tree-shake-icons
flutter build web --web-renderer html --base-href "/admin/"
cp build/app/outputs/flutter-apk/app-release.apk ../menu_firebase/public/admin.apk
rm -rf ../menu_firebase/public/admin
cp -r build/web ../menu_firebase/public/admin
pushd ../menu_firebase
firebase deploy
popd


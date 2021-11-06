# dh_playground

funktioniert mit erstellten und pre defined keys

https://pub.dev/packages/flutter_sodium

https://github.com/firstfloorsoftware/flutter_sodium

flutter_sodium: ^0.2.0

in iOS podfile ergänzen

    # 兼容 Flutter 2.5
        target.build_configurations.each do |config|
    #       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'
        end


complete part

post_install do |installer|
installer.pods_project.targets.each do |target|
flutter_additional_ios_build_settings(target)
# 兼容 Flutter 2.5
target.build_configurations.each do |config|
#       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'
end    






cryptography does not support ecdh on mobile, only web

https://pub.dev/packages/cryptography/

cryptography: ^2.0.2


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

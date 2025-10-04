# photos_viewer

A Flutter project for Photos List.

## Getting Started

This project is a Flutter application displaying a list of photos and view each photo description. It also include search function.

## Setup
This Flutter Application is using Flutter 3.10.0, Dart 3.0. 
To avoid different version from the operation system, it can install FVM [here](https://fvm.app/documentation/getting-started/installation).
For specify the target Flutter version, go to the Flutter Project directory in Terminal/Command Prompt:
```
fvm install 3.10.1
fvm use 3.10.1
```

Then, clean the Flutter cache. Next, to install plugins and generate the model class,
```
fvm flutter pub cache clean
fvm flutter pub get
fvm dart run build_runner build
```

For running in iOS devices, go to ./ios directory in Terminal and run the following: 
```
pod insatall
pod update
```



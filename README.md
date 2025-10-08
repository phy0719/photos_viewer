# photos_viewer

A Flutter project for Photos List.

## Getting Started

This project is a Flutter application displaying a list of photos by different locations and viewing each photo description. It contains search function allowing to search keywords in either location and createdBy. It also bookmark function to save the favorite photos.

<img width="375" height="755" alt="Screenshot 2025-10-08 at 02 27 19" src="https://github.com/user-attachments/assets/7e62aef4-37fa-41a0-9f8d-1d72b9d5cd7d" />
<img width="375" height="737" alt="Screenshot 2025-10-08 at 02 27 42" src="https://github.com/user-attachments/assets/3215bde6-8c23-4b28-ad25-ae1fb50592a0" />
<img width="372" height="750" alt="Screenshot 2025-10-08 at 02 28 00" src="https://github.com/user-attachments/assets/1ccd3830-0eb3-4032-a62d-13c1c696f710" />

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

## Building Tools
### Android Studio (For Flutter development and app building)
Android Studio Giraffe | 2022.3.1 Patch 4
Build #AI-223.8836.35.2231.11090377, built on November 14, 2023
Runtime version: 17.0.6+0-17.0.6b829.9-10027231 x86_64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.

Non-Bundled Plugins:
Dart (223.8977)
com.intellij.plugins.macoskeymap (223.7571.117)
idea.plugin.protoeditor (223.8214.6)
com.jetbrains.kmm (0.8.1(223)-26)
io.flutter (77.1.1)

### Xcode (For Building iOS application)
Xcode Version (16.4)(16F6)
MacOS Sequoia Version 15.6 (24G84)

## Testing Devices
iPhone Simulator 15(iOS 17.5)
Android Emulator: Pixel 6a with Google Play (API level 34)
Real Device: iPhone 15 Pro(iOS 18.6.2)

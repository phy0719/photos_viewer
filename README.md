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



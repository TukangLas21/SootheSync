# SootheSync

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-2.x-blue)](https://dart.dev)

SootheSync Mobile App is a mobile application that's built with Flutter for ITB IEEE's ProtoTech Contest. This app is part of SootheSync, a system to help users regulate and manage their anxiety medication. SootheSync Mobile App functions as a bridge between two hardwares, a smart wristband and a smart pillbox. For more information about SootheSync itself, you can check out the `doc` folder.

## Features

- Anxiety attack data storage
- Pill regulation and management 
- Real-time data synchronization with Google Firebase Firestore
- Calendar to track and log previous anxiety attacks

## Screenshots
Screenshots will follow soon!

## Getting Started

### Prerequisites

- Flutter SDK [3.29.2]
- Dart [3.7.2]

### Installation

1. Clone the repository and navigate to project directory
   ```sh
   git clone https://github.com/TukangLas21/SootheSync.git
   cd SootheSync/soothesync
   ```
2. Install dependencies
   ```sh
   flutter pub get
   ```
3. Run the app
   ```sh
   flutter run
   ```
Make sure you have your phone or emulator connected before running this project. You can also run this in Android Studio.

### Building
If you wish to build this project in Android, type in: 
```sh
flutter build apk
```
and navigate to `soothesync/build/app/outputs/flutter-apk/` to find the built APK Release file.

## Project Structure
```sh
lib/
├── main.dart                # Entry point
├── home.dart                # Home page
├── history.dart             # Anxiety attack history page
├── medication.dart          # Medication modification page
├── addpill.dart             # Add pills page
├── editpill.dart            # Edit pills page
├── calendar.dart            # Calendar page
└── firebase_options.dart    # Firebase helper
```

## Author
This mobile application is made entirely by TukangLas21. <br>
Feel free to contact me through:
- [![Email](https://img.shields.io/badge/Email-Contact%20Me-red?style=flat&logo=gmail)](mailto:judhistiraaria@gmail.com)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/aria-judhistira-918892267)

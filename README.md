# send-money-app

This is a send money application for a technical exam.

---

### Prerequisites

1. Before running the application or the tests, ensure you have the following installed:
   1. Flutter SDK
   2. Dart SDK
   3. Xcode (for iOS development)
   4. Android Studio or VSCode
   5. Git
2. To verify if Flutter is properly set up, run `flutter doctor`.

### Steps on how to run the flutter application

1. Open your IDE and navigate to your project directory. You may run this command on the terminal `cd your-repo-name`.
2. Run `git clone <repository URL>`
3. If you have successfully clone the github repository, run `flutter pub get`.
4. Open your Android emulator or iOS simulator.
5. To run the app:
   1. Run `flutter run`.
   2. If you want to specify the device, run `flutter run -d <device_id>`.
   3. In VSCode, select one device from the list of available ones on the bottom status bar. Then, click the run and debug from the side bar.

---

### Steps on how to run the unit test

1. To run all unit tests in the test/ directory, run `flutter test`.
2. If you want to run a specific test file, provide the path to that test file by running `flutter test test/path_to_your_test_file.dart`.

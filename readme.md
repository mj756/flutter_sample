#Getting started
1. Change package name of this project using change_app_package_name library (preferred)
2. Create new project in firebase and add debug sha1 and release sha1 keys.
3. Add google services.json and key.jks file in android/app folder.
4. Set your own credential in key.properties file


#how to generate sha1 and sha256 keys
keytool -genkey -v -keystore D:/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias android

#How to read content from jks file
keytool -list -v -keystore D:/key.jks -alias android -storepass android -keypass android

#Important commands
* For generate APK => flutter build apk
  => flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

#For generate AppBundle 
flutter build appbundle


* Generate JSON serialization code for models:
    1. One-time code generation: flutter pub run build_runner build --delete-conflicting-outputs
    2. Generating code continuously: flutter pub run build_runner watch --delete-conflicting-outputs

* For get ip address of Android 10+ devices: adb shell ip -f inet addr show

----------------------------------------------------------------------------------------------------

#iOS app
Bundle id: com.flutter

Commands:
export PATH="$PATH:`pwd`/Downloads/flutter/bin"
open -a Simulator

#For update app version name and version code
Step 1: Goto "ios" folder and open "Runner.xcworkspace" file in Xcode by double click on it
Step 2: Select "Runner" from targets -> Goto "General" tab

#Create iOS build using terminal
Step 1: open terminal and goto project directory and then run below commands in terminal
1.  flutter clean
2.  flutter pub get
3.  flutter pub upgrade
4.  cd ios
5.  pod install
6.  pod update
7.  cd ..
8.  flutter build ipa
Step 2: Goto "build >> ios >> archive" folder and open "Runner.xcarchive" file by double click on it
Step 3: Click on "Distribute App" button, display on right side panel
Step 4: Follow instructions and upload build on App Store

#Create iOS build using Xcode
Step 1: open terminal and goto project directory and then run below commands in terminal
1.  flutter clean
2.  flutter pub get
3.  flutter pub upgrade
4.  cd ios
5.  pod install
6.  pod update
7.  cd ..
8.  flutter build ios
Step 2: Goto "ios" folder and open "Runner.xcworkspace" file in Xcode by double click on it
Step 3: Choose "any iOS device" from header
Step 4: Open menu: Product >> Archive
Step 5: Follow instructions and upload build on App Store

Question: How can I delete a bundle identifier managed by Xcode 8.1?
Answer: https://stackoverflow.com/questions/41490878/how-can-i-delete-a-bundle-identifier-managed-by-xcode-8-1

----------------------------------------------------------------------------------------------------

#Testing and code coverage
(1) Plugin: Flutter Enhancement Suite
(2) Command line:
Step 1: Generate code coverage: flutter test --coverage
Step 2: Convert to HTML using Git BASH shell: ./genhtml.perl ./coverage/lcov.info -o coverage/html

https://stackoverflow.com/questions/67366702/flutter-mockito-with-null-safety-throws-null-type-error
run "flutter pub run build_runner build --delete-conflicting-outputs" for build runner to build the stub files for you





# Important notes :
if  we add google login in our app then we need to add release sha1 key and debug sha1(usually in C:\Users\UserName\.android\debug.keystore
) key other wise it will generate apiexception 10 while debug mode.


# Generate key hash for facebook,microsoft login
keytool -exportcert -alias SIGNATURE_ALIAS -keystore "C:\Users\User\Documents\GitHub\flutter_sample\android\app\key.jks" | openssl sha1 -binary | openssl base64







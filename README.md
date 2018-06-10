# SocialMediaApp
Social Media App with Firebase Database - Udemy iOS Tutorial
SocialMediaApp
Social media app where you can post images, app captions, and like images. The app uses Firebase Database.

Getting Started
The app uses Firebase for its backend. Firebase is a fully managed platform for building iOS, Android, and web apps that provides automatic data synchronization, authentication services, messaging, file storage, analytics, and more.

Go to Firebase's homepage here. Create new iOS project. Copy in your iOS bundle ID. Click the Add APP button. Download the GoogleService-Info.plist file and copy it into the root section of your project file.

Firebase uses CocoaPods to install and manage dependencies.

Prerequisites
Before you start coding, setup Firebase in your xCode project file. Follow directions above.

Also add the SwiftKeychainWrapper pod to your xCode project file here.

Podfile Installs
Add the pods below to your podfile:

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'FBSDKLoginKit'
pod 'SwiftKeychainWrapper'
Built With
Udemy's DevSlopes Tutorial - The tutorial used to build this app
Authors
Andrew Jenson - Initial work - SocialMediaApp
License
This project is licensed under the MIT License - see the LICENSE.md file for details

Acknowledgments
*I would like to thank Udemy and the iOS 10 & Swift 3: From Beginner to Paid Professional course that I used to learn how to build this app.

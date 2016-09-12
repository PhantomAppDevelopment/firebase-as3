# Firebase in ActionScript

Firebase is a back end platform that offers several services to aid in the development of software, especially the ones that rely on server side infraestructure.

Some of its services can be accesed by using RESTful techniques. This repository contains detailed guides and examples explaining how to use those services in your `Adobe AIR ` projects.

You won't need an `ANE` for these guides, all of them work only using `StageWebView`, `URLRequest` and `URLLoader`.

## Firebase Auth
*Main guide: [Firebase Auth](./auth)*

This service allows you to securely authenticate users into your app. It uses Google Identity Toolkit to provide this service. Some of its key features are:

* Leverages the use of OAuth, saving time and effort.
* Authenticate with `Facebook`, `Google`, `Twitter`, `Email`, `Anonymous` and more.
* Generates a `tokenId` that can be used for Firebase Storage and Firebase Database.

## Firebase Database
*Main guide: [Firebase Database](./database)*

This service allows you to save and retrieve text based data. Some of its key features are:

* Securely save and retrieve data using rules and Firebase Auth.
* Listen to changes in realtime, useful for chat based apps.
* Data is generated in JSON, making it lightweight and fast to load.
* Easy to model and understand data structures.
* Filter, organize and query the data.

## Firebase Storage
*Main guide: [Firebase Storage](./storage)*

This service allows you to upload and maintain all kind of files, including images, sounds, videos. It uses Google Cloud Messaging to provide this service. Some of its key features are:

* Securely save and retrieve files using rules and Firebase Auth.
* Load end edit metadata from files.

## Getting Started

This guide assumes you want to use the 3 services in the same application, you will be able to use them with a free account.

Before you start coding you need to follow these steps to prepare your application for Firebase:

1. Create or open a project in the [Firebase Console](https://firebase.google.com)
2. You will be presented with 3 options for adding your app to `iOS`, `Android` or `Web`.
3. Click `Web`, a popup will appear with information about your project. Copy down your `apiKey` and `authDomain`.

From the `authDomain` we only need the id of the project, an example of an id is: `my-app-12345`.

You can read the guides in any order but it is recommended to start with the [Firebase Auth guide](./auth).

## Donations

Feel free to support the development of free guides and examples. Your donations are greatly appreciated.

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MQPLL355ZAKXW)
# Examples

In this folder you will find several examples on how to use the Firebase services with ActionScript 3.

It is strongly recommended to use recent versions of `Adobe AIR` and `Apache Flex`.

## SimpleChat.mxml

An Apache Flex example that demonstrates how to use the Firebase Database with realtime data and Email auth.

You will require to enable the `Email` provider for your project, you will also require the following Database Rules:

```json
{
    "rules": {
        "messages": {
            ".read": "auth != null",
            ".write": "auth != null"
        }
    }
}
```

## SimpleCRUD.mxml

An Apache Flex example that demonstrates how to use the Firebase Database with non realtime data.

You will only require the following Database Rules:

```json
{
    "rules": {
        "journal": {
            ".read": "true",
            ".write": "true"
        }
    }
}
```

## FederatedCRUD.mxml

An Apache Flex example that demonstrates how to use Federated Login with the Firebase Database to manage a private journal. Each user can only read and modify their own journal.

You will require to enable the `Facebook`, `Twitter` or `Google` providers for your project, you will also require the following Database Rules:

```json
{
    "rules": {
        "journal": {
            "$user_id": {
                ".read": "$user_id === auth.uid",
                ".write": "$user_id === auth.uid"
            }
        }
    }
}
```

## FileManager.mxml

An Apache Flex example that demonstrates how to use Firebase Auth, Firebase Storage and Firebase Database to store and manage user images.
Every user will have their own private folder where they will be able to upload, download and delete their images.

You will require to enable the `Email` provider for your project, you will also require the following Database Rules:

```json
{
    "rules": {
        "images": {
            "$user_id": {
                ".read": "$user_id === auth.uid",
                ".write": "$user_id === auth.uid"
            }
        }
    }
}
```

You will require the following Storage Rules:

```
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /images/{userId}/{allPaths=**} {
            allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## EmailLogin.mxml

An Apache Flex example that demonstrates how to perform most operations from the Email Auth service.

You will only require to provide your Firebase API Key and enable the `Email & Password` auth provider.

## FederatedLogin.mxml

An Apache Flex example that demonstrates how to perform log-in using Google, Twitter and Facebook providers within the same app.

You will only require to provide your Firebase API Key and enable the providers of your choice.

## ToDo app
*Main repository: [ToDo App](https://github.com/PhantomAppDevelopment/todo-app)*

ToDo App is a mobile application developed with Starling Framework and FeathersUI. It showcases how to use Firebase services with ActionScript to create simple and secure CRUD system.

## Pizza App
*Main repository: [Pizza App](https://github.com/PhantomAppDevelopment/pizza-app)*

Pizza App is a mobile application developed with Starling Framework and FeathersUI. It showcases how to use Firebase services with ActionScript to create a small social network.
# Examples

In this folder you will find several examples on how to use the Firebase services with ActionScript 3.

It is strongly recommended to use recent versions of `Adobe AIR` and `Apache Flex`.

## SimpleChat.mxml

An Apache Flex example that demonstrates how to use the Firebase Database with realtime data and Email auth. This project makes use of the `Responses.as` file that can be found in the [utils folder](./../utils).

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

## FileManager.mxml

An Apache Flex example that demonstrates how to use Firebase Auth, Firebase Storage and Firebase Database to store and manage user images. Every user will have their own private folder where they will be able to upload, doanload and delete their images.

You will require the following Database Rules:

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

## EmailExample.mxml

An Apache Flex example that demonstrates how to perform most operations from the Email Auth service.

You will only require to provide your Firebase API Key and enable the `Email & Password` auth provider.

## FederatedExample.mxml

An Apache Flex example that demonstrates how to perform log-in using Google, Twitter and Facebook providers within the same app.

You will only require to provide your Firebase API Key and enable the providers of your choice.
# Examples

In this folder you will find several examples on how to use the Firebase services with ActionScript 3.

It is strongly recommended to use recent versions of `Adobe AIR` and `Apache Flex`.

## SimpleChat.mxml

An Apache Flex example that demonstrates how to use the Firebase Database with realtime data and Email auth. This project makes use of the `Responses.as` file that can be found in the [utils folder](./../utils).

You will require to enable the `Email` provider for your project, you will also require the following Database rules in your project:

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

An Apache Flex example that demonstrates how to use the Firebase Database with non realtime data. You only require the following Database rules in your project:

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

## EmailExample.mxml

An Apache Flex example that demonstrates how to perform most operations from the Email Auth service, you will only require to provide your Firebase API Key.

## FederatedExample.mxml

An Apache Flex example that demonstrates how to perform log-in using Google, Twitter and Facebook providers within the same app, you will only require to provide your Firebase API Key.
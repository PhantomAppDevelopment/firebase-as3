# Firebase Storage

Firebase Storage is based on Google Cloud Storage, a very easy and flexible solution for storing all kinds of files.

Files are stored the same way as in your personal computer, using a tree hierarchy. This means there's a root folder which can contain more folders and those folders can contain additional folders and files.

It is strongly recommended to avoid the use of special characters when naming files and folders.

You will need special care for the slash character `(/)`. I recommend using this helper function to URL encode them:

```actionscript
private function formatUrl(url:String):String
{
    return url.replace(/\//g, "%2F");
}
```

In the context of this guide a `bucket` is a synonymous to your Firebase project.

## Firebase Rules

The Firebase Rules are a flexible way to set permissions on who can access certain files and data.

By default all the data is private and can only be accessed by Authenticated users.

To modify the Rules follow these steps:

1. Open the [Firebase console](https://firebase.google.com)
2. Select your project.
3. Click on the Storage option from the left side menu.
4. Click on `RULES` from the top menu.

## Default Rules

```
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

These rules are very similar to the `Auth` default rules. They mean that any authenticated user can upload, delete and modify all files from your bucket.

## Public Reading and Writing

The following rules allows any user to upload, delete and modify files from your entire bucket. Use this only while developing and testing.

```
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}
```

## Public Reading

Use the following rules if you need to host some files that anyone on the Internet can download, such as images, documents, audio and video.

```
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /{allPaths=**} {
      allow read;
    }
  }
}
```

The following rules will allow anyone to read but not to write the contents of a folder named `public`.

```
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /public/} {
      allow read;
    }
  }
}
```

## Prerequisites


Since Firebase returns useful error information we will use the following `Event.COMPLETE` and `IOErrorEvent.IOERROR` listeners in all of our requests.

```actionscript
private function taskComplete(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}

private function errorHandler(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}
```

## Uploading a File

To upload a file with `URLLoader` you require to send it as a `ByteArray`.

If you upload the same file to the same location, it will be replaced with new metadata.

In this example we are uploading a file from a predefined location. A common example is syncing a save game after a game session.

```actionscript
private function uploadFile():void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    			
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);			
}
```

A successful response will look like the following JSON structure:

```json
{
    "name": "savegames/savegame.data",
    "bucket": "<YOUR-PROJECT-ID>.appspot.com",
    "generation": "1473948546121000",
    "metageneration": "1",
    "contentType": "text/plain",
    "timeCreated": "2016-09-15T14:09:06.053Z",
    "updated": "2016-09-15T14:09:06.053Z",
    "storageClass": "STANDARD",
    "size": "10450",
    "md5Hash": "7aIjAPS+Sd0DaF5SmGTUYw==",
    "contentEncoding": "identity",
    "crc32c": "DObTDw==",
    "etag": "CKj6iJzGkc8CEAE=",
    "downloadTokens": "7232aa46-f2e1-4df5-9698-d9c77b88ad5f"
}
```

Your new file and a `savegames` folder will instantly appear in the Storage section from the Firebase console.

The `contentType` doesn't need to be accurate, but it is recommended to set it properly.

## Uploading with Progress Indicator

You can also upload files using the `upload` and `uploadUnencoded` methods from the `File` and `FileReference` classes.

This example will demonstrate how to upload a file from a fixed location and retrieve the upload progress.

```actionscript
private function uploadFile():void
{
    var file:File = File.applicationStorageDirectory.resolvePath("heavy_picture.jpg");
    file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);

    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);

    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();

    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/pictures%2F"+"heavy_picture.jpg");
    request.method = URLRequestMethod.POST;
    request.data = bytes.toString();
    request.contentType = "image/jpeg";

    file.uploadUnencoded(request);
}

private function progressHandler(event:ProgressEvent):void
{
    var progress:Number = Math.round((event.bytesLoaded/event.bytesTotal)*100);
    trace("Upload Progress: " + progress + "%");
}

private function uploadCompleteDataHandler(event:DataEvent):void
{
    trace(event.data); //Here you will receive the file metadata from Firebase Storage.
}
```

It is required to send the file as a `String` that represents the file bytes and use the `uploadUnencoded` method.

## Uploading a File with Auth

Authorizing requests for Firebase Storage is a bit different than in Firebase Database. Instead of adding an `auth` parameter in the URL with the `authToken`, we add it into a header.

```actionscript
private function uploadFile(authToken:String):void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
    
    var header:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+authToken);			

    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    request.requestHeaders.push(header);

    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);			
}
```

A successful response will look like the following JSON structure:

```json
{
    "name": "savegames/savegame.data",
    "bucket": "<YOUR-PROJECT-ID>.appspot.com",
    "generation": "1473948546121000",
    "metageneration": "1",
    "contentType": "text/plain",
    "timeCreated": "2016-09-15T14:09:06.053Z",
    "updated": "2016-09-15T14:09:06.053Z",
    "storageClass": "STANDARD",
    "size": "10450",
    "md5Hash": "7aIjAPS+Sd0DaF5SmGTUYw==",
    "contentEncoding": "identity",
    "crc32c": "DObTDw==",
    "etag": "CKj6iJzGkc8CEAE=",
    "downloadTokens": "7232aa46-f2e1-4df5-9698-d9c77b88ad5f"
}
```

## Deleting a File

Deleting a file is very simple, you only need to send a `DELETE` request with the file you want to delete.

Instead of using a `DELETE` request we are going to use an alternative but valid approach, the `"X-HTTP-Method-Override", "DELETE"` header.

The reason to use the header is to have consistency with the Firebase Database guide.

```actionscript
private function deleteFile():void
{
    var header:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "DELETE");			
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.requestHeaders.push(header);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

A successful response will return an [empty String](https://cloud.google.com/storage/docs/json_api/v1/objects/delete).

## Deleting a File with Auth

To delete a file with authentication you only need to provide an `authToken` in the `Authorization` header and the file path in a `DELETE` request.

```actionscript
private function deleteFile(authToken:String):void
{
    var header:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "DELETE");			
    var header2:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+authToken);			
			
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.requestHeaders.push(header);
    request.requestHeaders.push(header2);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

## Updating Metadata

To modify the metadata generated after your upload a file you will only require to `JSON` encode which fields do you need to update and send them in a `PATCH` request. This is very similar as updating the Firebase Database data.

Click [here](https://firebase.google.com/docs/storage/web/file-metadata) for a list of all the fields that can be modified. In the following example we are going to change the `contentType`.

```actionscript
private function updateMetadata():void
{
    var myObject:Object = new Object();
    myObject.contentType = "application/binary";
				
    var header:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "PATCH");			
    var header2:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/"+"savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = JSON.stringify(myObject);
    request.requestHeaders.push(header);
    request.requestHeaders.push(header2);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

A successful response will look like the following JSON structure:

```json
{
    "name": "savegames/savegame.data",
    "bucket": "<YOUR-PROJECT-ID>.appspot.com",
    "generation": "1473948546121000",
    "metageneration": "2",
    "contentType": "application/binary",
    "timeCreated": "2016-09-15T14:09:06.053Z",
    "updated": "2016-09-16T02:46:44.439Z",
    "storageClass": "STANDARD",
    "size": "10450",
    "md5Hash": "7aIjAPS+Sd0DaF5SmGTUYw==",
    "contentEncoding": "identity",
    "crc32c": "DObTDw==",
    "etag": "CKj6iJzGkc8CEAE=",
    "downloadTokens": "7232aa46-f2e1-4df5-9698-d9c77b88ad5f"
}
```

## Updating Metadata with Auth

To update metadata with authentication you need to provide an `authToken` in the `Authorization` header.

You will also require to `JSON` encode which fields do you need to update and send them in a `PATCH` request.

```actionscript
private function updateMetadata(authToken:String):void
{
    var myObject:Object = new Object();
    myObject.contentType = "application/binary";
				
    var header:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "PATCH");			
    var header2:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");
    var header3:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+authToken);         
		
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = JSON.stringify(myObject);
    request.requestHeaders.push(header);
    request.requestHeaders.push(header2);
    request.requestHeaders.push(header3);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

## Downloading a File

To download files from your Firebase Storage bucket you only require to send a `GET` request with the full path of the file and the parameter `alt=media`.
You will also require the followinv values from the `JSON` structure.

Name | Description
---|---
`name` | The path of the file including its name.
`bucket` | Your Firebase Project ID plus the `appspot.com` domain.
`downloadTokens` | A String used for downloading private files.

```json
{
    "name": "savegames/savegame.data",
    "bucket": "<YOUR-PROJECT-ID>.appspot.com",
    "generation": "1473948546121000",
    "metageneration": "1",
    "contentType": "text/plain",
    "timeCreated": "2016-09-15T14:09:06.053Z",
    "updated": "2016-09-15T14:09:06.053Z",
    "storageClass": "STANDARD",
    "size": "10450",
    "md5Hash": "7aIjAPS+Sd0DaF5SmGTUYw==",
    "contentEncoding": "identity",
    "crc32c": "DObTDw==",
    "etag": "CKj6iJzGkc8CEAE=",
    "downloadTokens": "7232aa46-f2e1-4df5-9698-d9c77b88ad5f"
}
```

There are several ways to download files using the AIR runtime, we are going to use the easiest one: `navigateToURL()`.

The following example downloads a `public` file:

```actionscript
private function downloadFile():void
{
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data"+"?alt=media");
    navigateToURL(request);
}
```

## Downloading a Private File

Downloading `private` files doesn't require the `Authorization` header. You only require to provide the `token` parameter and the file path.

The `token` parameter is the `downloadTokens` value from the `JSON` response when you upload a file.

```actionscript
private function downloadFile(downloadTokens:String):void
{
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data"+"?alt=media&token="+downloadTokens);
    navigateToURL(request);
}
```

## Downloading Metadata

You can download the information of any file in JSON format without downloading the file itself.

To download the metadata of a `public` file you only require to send a `GET` request with the full file path.

```actionscript
private function downloadMetadata():void
{
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.event.COMPLETE, metadataLoaded);
    loader.load(request);
}

private function metadataLoaded(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}
```

## Downloading Private Metadata

To download metadata from `private` files you require to provide an `authToken` in the `Authorization` header.

```actionscript
private function downloadMetadata(authToken:String):void
{
    var header:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+authToken);         
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.requestHeaders.push(header);

    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.event.COMPLETE, metadataLoaded);
    loader.load(request);
}

private function metadataLoaded(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}
```

## User Specific Files

So far we have worked with the same file (`savegame.data`) in the same location (`savegames` folder),
now we are going to step it up and make it so every registered user can have their own folder with their respective `savegame.data` file.

The following rules specify that only authenticated users can read and write the file `savegame.data` that will be located inside a folder named the same as their `uid` (`localId`):

```
service firebase.storage {
    match /b/<YOUR-PROJECT-ID>.appspot.com/o {
        match /savegames/{userId}/savegame.data {
            allow read, write: if request.auth.uid == userId;
        }
    }
}
```

We can use the following rules if we want users to have control over their complete folder:

```
service firebase.storage {
    match /b/<YOUR-PROJECT-ID>.appspot.com/o {
        match /savegames/{userId}/{allPaths=**} {
            allow read, write: if request.auth.uid == userId;
        }
    }
}
```

The following snippet requires that you already have a valid `authToken` and a `localId`.

The `localId` can be obtained after a successful `Sign In`, `Sign Up` or `Get Account Info` request.

The `auth` value can be obtained after a successful `Refresh Token` request.

For more information on these values you can read the [Firebase Auth guide](./../auth/).

```actionscript
private function uploadPersonalFile(authToken:String, localId:String):void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
				
    var header:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+authToken);			
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2F"+localId+"%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    request.requestHeaders.push(header);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, taskComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);				
}
```

A successful response will look like the following JSON structure:

```json
{
    "name": "savegames/ktfSpKHar2fW1fcZePigI0Zr0bP2/savegame.data",
    "bucket": "<YOUR-PROJECT-ID>.appspot.com",
    "generation": "1473948546121000",
    "metageneration": "1",
    "contentType": "text/plain",
    "timeCreated": "2016-09-15T14:09:06.053Z",
    "updated": "2016-09-16T02:46:44.439Z",
    "storageClass": "STANDARD",
    "size": "10450",
    "md5Hash": "7aIjAPS+Sd0DaF5SmGTUYw==",
    "contentEncoding": "identity",
    "crc32c": "DObTDw==",
    "etag": "CKj6iJzGkc8CEAE=",
    "downloadTokens": "7232aa46-f2e1-4df5-9698-d9c77b88ad5f"
}
```

You will notice that the `localId` value has been added to the name.
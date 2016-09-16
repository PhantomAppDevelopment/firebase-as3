# Firebase Storage

Firebase Storage is based on Google Cloud Storage, a very easy and flexible solution for storing all kinds of files.

Files are stored the same way as in your personal computer, using a tree hierarchy. This means there's a root folder, which can contain more folders and those folders can contain additional folders and files.

It is strongly recommended to avoid the use of special characters when naming files and folders.

You need to have specific care for the slash character `(/)`. I recommend using this helper function to URL encode them:

```actionscript
private function formatUrl(url:String):String
{
    return url.replace("/", "%2F");
}
```

In the context of this guide a `bucket` is a synonymous to your Firebase project.

## Firebase Rules

The Firebase Rules are a flexible way to set permissions on who can access certain data.

By default all the data is private and can only be accessed by Authenticated users.

To modify the Rules follow these steps:

1. Open the [Firebase console](https://firebase.google.com)
2. Select your project.
3. Click on the Storage option from the left side menu.
4. Click on `RULES` from the top menu.

## Default Rules

```language
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

The following rules allows any user to upload, delete and mofify files from your entire bucket. Use this only while developing and testing.

```language
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

```language
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /{allPaths=**} {
      allow read;
    }
  }
}
```

These rules will allow anyone to read the contents of a folder named `public`.

```language
service firebase.storage {
  match /b/<YOUR-PROJECT-ID>.appspot.com/o {
    match /public/} {
      allow read;
    }
  }
}
```

## Uploading a File

To upload a file you require to send it as a `ByteArray`. The following snippets show the most common scenarios.

All of the following examples use the following `Event.COMPLETE` and `IOErrorEvent.IOERROR` listeners.

```actionscript
private function uploadComplete(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}

private function errorHandler(event:flash.events.Event):void
{
    trace(event.currentTarget.data);
}
```

If you upload the same file to the same location, it will be replaced with new metadata.

### Uploading from a fixed location

In this example we are uploading a file from a predefined location. A common example is syncing a save game after a game session:

```actionscript
private function uploadFile():void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/"+"savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    			
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, uploadComplete);
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

Your new file and `savegames` folder will instantly appear in the Storage section from the Firebase console.

The download link for this specific file would be:

`https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2Fsavegame.data?alt=media`

The metadata link for this specific file would be:

`https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2Fsavegame.data`

Notice that you need to provide the `?alt=media` parameter in order to download the actual file.

You will also need to replace all the `/` for `%2F` after the bucket name. Otherwise it will return an error.

The `contentType` doesn't need to be accurate, but it is recommended to set it properly.

### Uploading with Auth

Authorizing requests for Firebase Storage is a bit different than in Firebase Database. Instead of adding an `auth` parameter in the URL with the `idToken`, we add it into an `URLRequestHeader`.

```actionscript
private function uploadFile(idToken:String):void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
    
    var header:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+idToken);			

    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/"+"savegames%2F"+"savegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    request.requestHeaders.push(header);

    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, uploadComplete);
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
				
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2Fsavegame.data");
    request.method = URLRequestMethod.POST;
    request.requestHeaders.push(header);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, deleteComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

A successful response will return an [empty String](https://cloud.google.com/storage/docs/json_api/v1/objects/delete).

Use the following snippet if you want to delete the same file using authentication:

```actionscript
private function deleteFile(idToken:String):void
{
    var header:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "DELETE");			
    var header2:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+idToken);			
			
    var request:URLRequest = new URLRequest("https://firebasestorage.googleapis.com/v0/b/<YOUR-PROJECT-ID>.appspot.com/o/savegames%2Fsavegame.data");
    request.method = URLRequestMethod.POST;
    request.requestHeaders.push(header);
    request.requestHeaders.push(header2);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, deleteComplete);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
    loader.load(request);
}
```

## Updating Metadata

To modify the metadata generated after your upload a file you will only require to indicate which fields do you need to update. This is very similar as updating the Firebase Database data.

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
    loader.addEventListener(flash.events.Event.COMPLETE, updateComplete);
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

### User specific files

So far we have worked with the same file (`savegame.data`) in the same location (`savegames` folder),
now we are going to step it up and make it so every registered user can have their own folder with their respective `savegame.data` file.

The following rules specify that only authenticated users can read and write the file `savegame.data` that will be located inside a folder named the same as their `uid` (`localId`):

```json
service firebase.storage {
    match /b/<YOUR-PROJECT-ID>.appspot.com/o {
        match /savegames/{userId}/savegame.data {
            allow read, write: if request.auth.uid == userId;
        }
    }
}
```

We can use the following rules if we want users to have control over their complete folder:

```json
service firebase.storage {
    match /b/<YOUR-PROJECT-ID>.appspot.com/o {
        match /savegames/{userId}/{allPaths=**} {
            allow read, write: if request.auth.uid == userId;
        }
    }
}
```

The following snippet requires that you already have an `idToken` and a `localId`. You can obtain those after a successful Log In or Sign Up. For more information you can read the [Firebase Auth guide](./../auth).

```actionscript
private function uploadPersonalFile(idToken:String, localId:String):void
{
    var file:File = File.applicationStorageDirectory.resolvePath("savegame.data");
				
    var fileStream:FileStream = new FileStream();
    fileStream.open(file, FileMode.READ);
    var bytes:ByteArray = new ByteArray();
    fileStream.readBytes(bytes);
    fileStream.close();
				
    var header:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer "+idToken);			
				
    var request:URLRequest = new URLRequest(FIREBASE_STORAGE_URL+"savegames%2F"+localId+"%2Fsavegame.data");
    request.method = URLRequestMethod.POST;
    request.data = bytes;
    request.contentType = "text/plain";
    request.requestHeaders.push(header);
				
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(flash.events.Event.COMPLETE, uploadComplete);
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

You will notice that the `localId` has been added to the name.
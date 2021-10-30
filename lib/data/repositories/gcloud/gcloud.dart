import 'dart:core';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class GcloudApi {
  var _credentials;
  var _client;

  String gcloudimagepath = '';

  Future<void> spawnclient() async {
    rootBundle
        .loadString('lib/core/constants/credentials.json')
        .then((json) async {
      _credentials = auth.ServiceAccountCredentials.fromJson(json);
      // Create a client
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    });
  }

  Future<ObjectInfo> save(
    String directorypath,
    Uint8List imgBytes,
  ) async {
    // Create a client
    //_client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');

    // Save to bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(directorypath.split('/').last);
    return await bucket.writeBytes(directorypath, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }

  Future<void> saveMany(List<XFile> images, String directory) async {
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    images.forEach((element) async {
      if (element != null) {
        var _image = File(element.path);
        var _imageBytes = _image.readAsBytesSync();
        String _imageName = _image.path.split('/').last;
        await save(
          directory + _imageName,
          _imageBytes,
        );
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Page<BucketEntry>> getPage(int size, String directory) async {
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');
    Page<BucketEntry> page =
        await bucket.page(prefix: directory, pageSize: size);
    return page;
  }

  Future<Page<BucketEntry>> nextPage(Page<BucketEntry> page, int size) async {
    return page.next(pageSize: size);
  }

  Future<List<String>> returnFilename(String directory) async {
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    List<String> filename = [];
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');
    Stream<BucketEntry> stream = bucket.list(prefix: directory);
    await for (var event in stream) {
      if (event.name != directory) {
        filename.add(event.name);
      }
    }
    return filename;
  }

  Future<List<String>> returnallFilename() async {
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    List<String> filename = [];
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');
    List<String> filenames = [];
    await returnFoldernames().then((value) async {
      for (int i = 0; i < value.length; i++) {
        await returnFilename(value[i]).then((value) {
          filenames.addAll(value);
          if (i == (value.length - 1)) {
            return filenames;
          }
        });
      }
    });
    return filenames;
  }

  Future<List<String>> returnFoldernames() async {
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    List<String> foldername = [];
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');
    Stream<BucketEntry> stream = bucket.list(prefix: '');
    await for (var event in stream) {
      if (!event.isObject) foldername.add(event.name);
    }
    return foldername;
  }

  Future<Uint8List> read(String webpath) async {
    // Create a client
    //_client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    if (_client == null)
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('ritikawedding');
    final bytesBuilder = BytesBuilder();
    var stream = bucket.read(webpath);
    await for (var event in stream) {
      bytesBuilder.add(event);
    }
    Uint8List byteList = bytesBuilder.toBytes();
    return byteList;
  }

  Future<List<XFile>> readSave({
    required String directory,
    required int startIndex,
    required int readsize,
  }) async {
    print(startIndex);
    print(readsize);
    List<String> filename = await returnFilename(directory);
    List<XFile> files = [];
    for (int i = startIndex; i < (readsize); i++) {
      if (i < filename.length) {
        files.add(await writeToFile(await read(filename[i]), filename[i]));
        print(i);
      }
    }
    return files;
  }

  Future<List<XFile>> readallSave({
    required int startIndex,
    required int readsize,
  }) async {
    print(startIndex);
    print(readsize);
    List<String> filename = await returnallFilename();
    List<XFile> files = [];
    for (int i = startIndex; i < (readsize); i++) {
      if (i < filename.length) {
        files.add(await writeToFile(await read(filename[i]), filename[i]));
        print(i);
      }
    }
    return files;
  }

  Future<XFile> writeToFile(Uint8List data, String webpath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    final buffer = data.buffer;

    File newfile = File(dir.path + '/' + webpath.split('/').last);
    newfile.writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return XFile(newfile.path);
  }

  Future<Uint8List> readFromFile(File file) async {
    var contents = await file.readAsBytes();
    return (contents);
  }
}

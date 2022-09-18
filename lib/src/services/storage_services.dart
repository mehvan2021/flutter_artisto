import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';

class CloudStorage {
  Future uploadFile(BuildContext context,
      {required PlatformFile platformFile,
      required MyTitle,
      required MyUser}) async {
    final fileName = platformFile.name;
    final file = File(platformFile.path!);
    final storageRef = FirebaseStorage.instance.ref();
    final firebaseStorageRef =
        storageRef.child("sounds/$MyUser/$MyTitle/Clipboard/$MyTitle");

    try {
      await firebaseStorageRef.putFile(file).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files Uploaded Successully!")));
      });
    } on firebase_core.FirebaseException catch (e) {
      debugPrint("task failed !!!!!!!!!!!!!!!!!!!!!!!!    $e");
    }
  }

  Future<List<Reference>> showFiles() async {
    final fireStorage = FirebaseStorage.instance.ref().child("sounds");
    var listResult = await fireStorage.list();

    return listResult.items;
  }
}

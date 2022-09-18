import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';

import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserProfileImage {
  String? downloadURL;

  final String ProfilePic;
  UserProfileImage({required this.ProfilePic});

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("images/$ProfilePic")
        .getDownloadURL();

    debugPrint(downloadURL.toString());
  }
}

class UserAlbumPoster {
  String? downloadURL;

  final String MyUser;

  final String MyTitle;
  UserAlbumPoster({required this.MyUser, required this.MyTitle});

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("sounds/$MyUser/$MyTitle/Clipboard/$MyTitle")
        .getDownloadURL();

    debugPrint(downloadURL.toString());
  }
}

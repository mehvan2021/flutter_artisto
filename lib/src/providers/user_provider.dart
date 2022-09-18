import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';

class UserProvider extends ChangeNotifier {
  ArtistooUser? Artistoo_User;

  setArtistoo_User(ArtistooUser user) {
    Artistoo_User = user;
    debugPrint('from provider : ' + Artistoo_User.toString());
    notifyListeners();
  }
}

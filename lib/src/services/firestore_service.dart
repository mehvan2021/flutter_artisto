import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add user with initial information to database

  Future<ArtistooUser> addUserWithInitialInformationToDB(
      {required User user,
      required String userName,
      String? phoneNumber}) async {
    ArtistooUser Artistoo_User = ArtistooUser(
      name: userName,
      createdAt: DateTime.now(),
      email: user.email!,
      phone: phoneNumber,
      uid: user.uid,
      ArtCoin: 10,
      inlist: ['0'],
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(Artistoo_User.toMap());
    return Artistoo_User;
  }

  Future<DocumentReference> addNewPost(Artistoo Artistoo) async {
    return await _firestore.collection('posts').add(Artistoo.toMap());
  }

  updateUserInformationFromCreateProfile(
      {required ArtistooUser Artistoo_User}) {}
}

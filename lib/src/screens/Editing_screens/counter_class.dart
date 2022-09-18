import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Add_ArtCoin.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class CounterClass extends GetxController {
  StreamController<int> streamController = StreamController<int>.broadcast();
  final _firestore = FirebaseFirestore.instance;

  // int fileName = a!;

  void streamCount() async {
    try {
      await for (var snapshot in _firestore
          .collection('users')
          .where('uid', isEqualTo: auid)
          .snapshots()) {
        for (var countdt in snapshot.docs) {
          streamController.sink.add(countdt.data()['ArtCoin']);
        }
      }
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  void updateCount(int count) {
    try {
      Map<String, int> upDated = {"ArtCoin": count + 1};
      _firestore.collection("users").doc(auid).update(upDated);
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  void minusCount(int count) {
    try {
      Map<String, int> upDated = {"ArtCoin": count - 1};
      _firestore.collection("users").doc(auid).update(upDated);
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  @override
  void onClose() {
    streamController.close();
    streamController = StreamController.broadcast();
  }
}

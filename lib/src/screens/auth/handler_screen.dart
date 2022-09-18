import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Artisto%20Handle%20Screen/New_Post_screen_view.dart';
import 'package:flutter_artisto/src/screens/auth/login_screen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/create_profile.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';

class HandlerScreen extends StatefulWidget {
  HandlerScreen({Key? key}) : super(key: key);

  @override
  State<HandlerScreen> createState() => _HandlerScreenState();
}

class _HandlerScreenState extends State<HandlerScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  ArtistooUser? thArtistoo_User;

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth(auth service) =>
    // FirebaseFirestore(database service) =>
    // save it on a global object as provider to use it on all the app sections

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          //TODO:  check if loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else if (snapshot.data == null) {
            return LoginScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('error'));
          }

          return FutureBuilder<ArtistooUser>(
              future: getUser(snapshot.data!),
              builder: (context, snapshotFromFuture) {
                if (snapshotFromFuture.connectionState ==
                    ConnectionState.waiting) {
                  return LoadingIndicator();
                } else if (snapshotFromFuture.hasError) {
                  return Center(
                    child: Text(snapshotFromFuture.error.toString()),
                  );
                } else if (snapshotFromFuture.data == null) {
                  //TODO: go to create Profile

                  // Get.to(()=> CreateProfileScreen(Artistoo_User: Artistoo_User, isUpdate: isUpdate))
                }
                return ArtistoHomeScreen();
              });
        },
      ),
    );
  }

  Future<ArtistooUser> getUser(User user) async {
    ArtistooUser Artistoo_User = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => ArtistooUser.fromSnapShot(value));

    Provider.of<UserProvider>(context, listen: false)
        .setArtistoo_User(Artistoo_User);

    return Artistoo_User;
  }
}

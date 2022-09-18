import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Add_ArtCoin.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Artisto_data_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class BidInfos extends StatefulWidget {
  final Artistoo Bids;
  const BidInfos({
    Key? key,
    required this.Bids,
  }) : super(key: key);

  @override
  State createState() => _BidInfos(Bids);
}

class _BidInfos extends State {
  Artistoo Bids;
  _BidInfos(this.Bids);
  StreamController<int> streamController = StreamController<int>.broadcast();
  final _firestore = FirebaseFirestore.instance;

  PlatformFile? file;
  bool colorSwitch = true;
  Color? color1 = Colors.grey[200];
  Color? color2 = Colors.grey[300];

  bool AlbumOwener = false;
  bool AlbumBought = false;
  bool AlbumBuy = false;

  @override
  Widget build(BuildContext context) {
    ArtistooUser Artistoo_User = context.watch<UserProvider>().Artistoo_User!;

    if (Artistoo_User.email == Bids.user.email) {
      AlbumBought = true;
      AlbumBuy = false;
    } else if (Artistoo_User.inlist!.indexOf(Bids.title) >= 0) {
      AlbumBought = true;
      AlbumBuy = false;
    } else if (Bids.AlbumPrice == "") {
      AlbumBought = true;
      AlbumBuy = false;
    } else {
      AlbumBought = false;
      AlbumBuy = true;
    }
    if (Artistoo_User.name == Bids.user.name) {
      AlbumOwener = true;
    } else {
      AlbumOwener = false;
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('user.email', isEqualTo: Bids.user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SelectableText(snapshot.error.toString()),
                      );
                    }
                    int asd = snapshot.data!.docs.length;

                    List<Artistoo> _Posts = snapshot.data!.docs
                        .map(
                          (e) => Artistoo.fromMap(
                            e.data(),
                          ),
                        )
                        .toList();

                    String SongPrice = "free";
                    if (Bids.AlbumPrice == "") {
                      SongPrice = "Free";
                    } else {
                      SongPrice = Bids.AlbumPrice.toString();
                    }
                    return Column(children: [
                      SizedBox(
                        height: 25,
                      ),
                      // show user and album informations > (header) container.
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              side: BorderSide(width: 1, color: Colors.red)),
                          color: Color.fromARGB(255, 231, 231, 231),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 100,
                                      child: FutureBuilder(
                                        future: UserAlbumPoster(
                                                MyUser: Bids.user.email,
                                                MyTitle: Bids.title)
                                            .getData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                              "Something went wrong",
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Container(
                                              width: 100,
                                              child: Image.network(
                                                snapshot.data.toString(),
                                              ),
                                            );
                                          }

                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Bids.user.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(179, 0, 0, 0),
                                        fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 140,
                                  child: Column(
                                    children: [
                                      Text(
                                        Bids.type,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 100, 1, 1),
                                            fontSize: 20),
                                      ),
                                      Text(Bids.title),
                                      Text(Bids.SongLang),
                                      Text("Price is $SongPrice"),
                                      Visibility(
                                        visible: AlbumBuy,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            var ref = FirebaseFirestore.instance
                                                .collection("users");
                                            ref.doc(Artistoo_User.uid).update(
                                              {
                                                "inlist": FieldValue.arrayUnion(
                                                    [Bids.title]),
                                              },
                                            );
// add to bought list

                                            //  increaase
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(Bids.user.uid)
                                                .update({
                                              "ArtCoin": FieldValue.increment(
                                                  Bids.AlbumPrice)
                                            });
// decrease//decrease
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(Artistoo_User.uid)
                                                .update({
                                              "ArtCoin": FieldValue.increment(
                                                  -Bids.AlbumPrice)
                                            });

                                            Get.to(() => ArtistoHomeScreen());
                                          },
                                          child: Text("Buy"),
                                        ),
                                      ),
                                      Visibility(
                                        //visible: AlbumOwener,
                                        visible: false,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            var ref = FirebaseFirestore.instance
                                                .collection("posts");
                                            ref.doc().delete();
                                            Get.to(() => ArtistoHomeScreen());
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // sections screen column > (body) .
                    ]);
                  }),
            ),

            Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('user.email', isEqualTo: Bids.user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SelectableText(snapshot.error.toString()),
                      );
                    }

                    List<Artistoo> _Posts = snapshot.data!.docs
                        .map(
                          (e) => Artistoo.fromMap(
                            e.data(),
                          ),
                        )
                        .toList();

                    return Column(children: [
                      // sections screen column > (body) .
                    ]);
                  }),
            ),

            // Show this album files
            Expanded(
              child: Visibility(
                visible: AlbumBought,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: color1,
                        ),
                        child: FutureBuilder<List<Reference>>(
                          future: AlbumFilesShow().showFiles(context,
                              MyTitle: Bids.title, MyUser: Bids.user.email),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((context, index) {
                                  colorSwitch = !colorSwitch;
                                  if (index % 2 == 0) {
                                    return Container(
                                      color: color1,
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text(
                                              snapshot.data![index].name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              var url = Uri.parse(await snapshot
                                                  .data![index]
                                                  .getDownloadURL());
                                              if (!await launchUrl(url,
                                                  mode: LaunchMode
                                                      .platformDefault)) {}
                                              debugPrint(url.toString());
                                            },
                                            icon: const Icon(
                                              Icons.download,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container(
                                    color: color2,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            snapshot.data![index].name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var url = Uri.parse(await snapshot
                                                .data![index]
                                                .getDownloadURL());
                                            if (!await launchUrl(url,
                                                mode: LaunchMode
                                                    .platformDefault)) {}
                                            debugPrint(url.toString());
                                          },
                                          icon: const Icon(
                                            Icons.download,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return const Center(
                              child: Text("Network Failed!"),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            //upload new files
//if (Artistoo_User.name == ""){}
            Visibility(
              visible: AlbumOwener,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    file?.name ?? "No File Selected",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            file = result.files.first;
                            setState(() {});
                          } else {
                            debugPrint("Process canceled");
                          }
                        },
                        child: Text(
                          "Select File",
                        ),
                      ),
                      SizedBox(
                        width: 22,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await AlbumFilesShow().uploadFile(context,
                              platformFile: file!,
                              MyTitle: Bids.title,
                              MyUser: Bids.user.email);
                          Navigator.pop(context);
                        },
                        child: const Text("Upload File"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumFilesShow {
  Future uploadFile(BuildContext context,
      {required PlatformFile platformFile,
      required MyTitle,
      required MyUser}) async {
    final fileName = platformFile.name;
    final file = File(platformFile.path!);
    final storageRef = FirebaseStorage.instance.ref();
    final firebaseStorageRef =
        storageRef.child("sounds/$MyUser/$MyTitle/$fileName");

    try {
      await firebaseStorageRef.putFile(file).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files Uploaded Successully!")));
      });
    } on firebase_core.FirebaseException catch (e) {
      debugPrint("task failed !!!!!!!!!!!!!!!!!!!!!!!!    $e");
    }
  }

  Future<List<Reference>> showFiles(BuildContext context,
      {required MyTitle, required MyUser}) async {
    final fireStorage =
        FirebaseStorage.instance.ref().child("sounds/$MyUser/$MyTitle");
    var listResult = await fireStorage.list();

    return listResult.items;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_artisto/src/common/strings.dart';
import 'package:flutter_artisto/src/common/widgets/general_drop_down_widget.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void _OpenLink(String url) async {
// ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    print('error');
    throw 'Error Occured';
  }
}

class PublisherBio extends StatelessWidget {
  PublisherBio({
    Key? key,
    required this.Bids,
  }) : super(key: key);

  final Artistoo Bids;

  AuthService _authService = AuthService();
  List<Artistoo> filteredPosts = [];
  String? selectedCategory;
  Color _post_color = Color.fromARGB(255, 81, 71, 71);

  @override
  Widget build(BuildContext context) {
    String UserPhone = Bids.user.phone.toString();
    String UserEmail = Bids.user.email;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 33,
              ),
              Row(
                children: [
                  Column(
                    children: [],
                  ),
                ],
              ),

              //is for list view of posts
              Expanded(
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
                        // sections screen column > (header) container.
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
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: FutureBuilder(
                                        future: UserProfileImage(
                                                ProfilePic: Bids.user.email)
                                            .getData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                              "Something went wrong",
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Image.network(
                                              snapshot.data.toString(),
                                            );
                                          }

                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                    Text(
                                      Bids.user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(179, 0, 0, 0),
                                          fontSize: 15.0),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _OpenLink(
                                                  'https:/wa.me/$UserPhone?text=Hellooo');
                                            },
                                            child: Container(
                                              width: 33,
                                              height: 25,
                                              child: Icon(
                                                color: Color.fromARGB(
                                                    255, 64, 205, 83),
                                                size: 22,
                                                FontAwesomeIcons.whatsapp,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _OpenLink('tel:$UserPhone');
                                            },
                                            child: Container(
                                              width: 33,
                                              height: 25,
                                              child: Icon(
                                                color: Color.fromARGB(
                                                    255, 204, 206, 203),
                                                size: 22,
                                                Icons.phone,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _OpenLink('mailto:${UserEmail}');
                                            },
                                            child: Container(
                                              width: 33,
                                              height: 25,
                                              child: Icon(
                                                color: Color.fromARGB(
                                                    255, 35, 224, 193),
                                                size: 22,
                                                Icons.email,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 140,
                                    width: 190,
                                    child: Column(
                                      children: [
                                        Text(
                                          "User Info",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 100, 1, 1),
                                              fontSize: 20),
                                        ),
                                        Flexible(
                                            child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              new Text(Bids.user.name),
                                              new Text(Bids.user.email),
                                              new Text(
                                                  Bids.user.phone.toString()),
                                            ],
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // sections screen column > (body) .
                        Expanded(
                            child: snapshot.data == null ||
                                    snapshot.data!.docs.isEmpty
                                ? Container(
                                    child: Center(
                                      child: Text('empty'),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: (filteredPosts.length == 0
                                            ? _Posts
                                            : filteredPosts)
                                        .length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      indent: 90,
                                      endIndent: 20,
                                      thickness: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      return PostUsersContainer(
                                          UserPost: (filteredPosts.length == 0
                                              ? _Posts
                                              : filteredPosts)[index]);
                                    },
                                  ))
                      ]);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostUsersContainer({required Artistoo UserPost}) {
    if (UserPost.type == 'Full Time') {
      _post_color = Color.fromARGB(255, 222, 30, 16);
    } else {
      _post_color = Color.fromARGB(255, 39, 2, 170);
    }
    IconData favIcon = Icons.favorite_outline;
    IconData favIconFill = Icons.favorite;
    return Container(
      padding: EdgeInsets.all(3),
      child: Card(
        elevation: 5,
        shape: Border(right: BorderSide(color: _post_color, width: 5)),
        color: Color.fromARGB(255, 231, 231, 231),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 132,
                width: 100,
                child: InkWell(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: FutureBuilder(
                          future:
                              UserProfileImage(ProfilePic: UserPost.user.email)
                                  .getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                "Something went wrong",
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Image.network(
                                snapshot.data.toString(),
                              );
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Text(
                        UserPost.user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12.0),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ),

//space between container photo and subject
            SizedBox(
              width: 5,
            ),

            InkWell(
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 22,
                    child: Row(
                      children: [
                        Text(
                          " ${UserPost.title} / ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                        Text(
                          UserPost.type,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 85,
                    child: Text(
                      UserPost.description,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),
// posts list
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      color: Color.fromARGB(255, 193, 196, 202),
                      width: 40,
                      height: 22,
                      child: Center(
                        child: Text(
                          '\$',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      color: Color.fromARGB(255, 85, 138, 244),
                      width: 40,
                      height: 22,
                      child: Center(
                        child: Text(
                          UserPost.AlbumPrice.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      color: Color.fromARGB(255, 247, 76, 76),
                      width: 40,
                      height: 22,
                      child: Center(
                        child: Text(
                          UserPost.SongLang,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 5,
                    ),
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

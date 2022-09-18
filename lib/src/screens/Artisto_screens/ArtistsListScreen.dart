import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistScreen2.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_My_Posts.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/SongScreen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/create_profile.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/strings.dart';
import 'package:flutter_artisto/src/common/widgets/general_drop_down_widget.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/fav_screen/fav_screen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/button_value_changer.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class PublisherList extends StatefulWidget {
  const PublisherList({Key? key}) : super(key: key);

  @override
  State<PublisherList> createState() => _PublisherListState();
}

class _PublisherListState extends State<PublisherList> {
  AuthService _authService = AuthService();
  List<ArtistooUser> filteredUserss = [];
  String? selectedCategory;
  Color _post_color = Color.fromARGB(255, 81, 71, 71);

  @override
  Widget build(BuildContext context) {
    final ArtistooUser Artistoo_User =
        Provider.of<UserProvider>(context).Artistoo_User!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Artist List',
            style: TextStyle(
                color: Color.fromARGB(255, 238, 234, 234),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.red,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        index: 2,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          //Handle button tap
          if (index == 0) {
            Navigator.of(context).pushNamed('/');
          } else if (index == 1) {
            Get.to(() => FavoritesScreen());
          } else if (index == 2) {
            Get.to(() => PublisherList());
          } else if (index == 3) {
            Get.to(() => ArtistoMyHomeScreen());
          }
        },
      ),

      // sections screen [column].
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(snapshot.error.toString()),
              );
            }

            List<ArtistooUser> _Userss = snapshot.data!.docs
                .map(
                  (e) => ArtistooUser.fromMap(
                    e.data(),
                  ),
                )
                .toList();

            return Column(children: [
              // sections screen column > (header) container.

              Expanded(
                  child: snapshot.data == null || snapshot.data!.docs.isEmpty
                      ? Container(
                          child: Center(
                            child: Text('empty'),
                          ),
                        )
                      : ListView.separated(
                          itemCount: (filteredUserss.length == 0
                                  ? _Userss
                                  : filteredUserss)
                              .length,
                          separatorBuilder: (context, index) => const Divider(
                            indent: 90,
                            endIndent: 20,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            return postUserssContainer(
                                UserPost: (filteredUserss.length == 0
                                    ? _Userss
                                    : filteredUserss)[index]);
                          },
                        ))
            ]);
          }),
    );

    //to test provider
    // body: Column(
    //   children: [Expanded(child: ClassOne())],
    // ),
  }

// ##widget custome card Text() widget
  Widget customeText(
      {required String name,
      required double fontSize,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing),
        ),
        const SizedBox(
          height: 7,
        )
      ],
    );
  }

// ##widget this widget is returned by itemBuilder inside listview.seperated
  Widget postUserssContainer({required ArtistooUser UserPost}) {
    if (UserPost.email == 'Album') {
      _post_color = Color.fromARGB(255, 222, 30, 16);
    } else {
      _post_color = Color.fromARGB(255, 39, 2, 170);
    }
    IconData favIcon = Icons.favorite_outline;
    IconData favIconFill = Icons.favorite;

    if (UserPost.email == null) {
      UserPost.email = "assets/images/logo2.jpg";
    }

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
                height: 120,
                width: 100,
                child: InkWell(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: FutureBuilder(
                          future: UserProfileImage(ProfilePic: UserPost.email)
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
                        UserPost.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12.0),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PublisherBio2(
                                  Userinf: UserPost,
                                )));
                  },
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
                          " ${UserPost.name} / ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                        Text(
                          "Kurdistan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _post_color,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 85,
                    child: Column(
                      children: [
                        Text(
                          UserPost.phone.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 12.0),
                        ),
                        Text(
                          UserPost.email,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublisherBio2(
                              Userinf: UserPost,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}

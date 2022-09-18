import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistScreen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_My_Posts.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistsListScreen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Dlmusic_screen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/SongScreen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/create_profile.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/strings.dart';
import 'package:flutter_artisto/src/common/widgets/general_drop_down_widget.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Artisto%20Handle%20Screen/New_Post_screen_view.dart';
import 'package:flutter_artisto/src/screens/fav_screen/fav_screen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/button_value_changer.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BoughtScreen extends StatefulWidget {
  const BoughtScreen({Key? key}) : super(key: key);
  @override
  State<BoughtScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BoughtScreen> {
  AuthService _authService = AuthService();
  List<Artistoo> filteredUserss = [];
  String? selectedCategory;
  Color _post_color = Color.fromARGB(255, 81, 71, 71);

  @override
  Widget build(BuildContext context) {
    final ArtistooUser Artistoo_User =
        Provider.of<UserProvider>(context).Artistoo_User!;

    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Get.to(() => CreatePostScreen());
          },
          child: Text('Add Post')),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            children: [
              SizedBox(
                height: 45,
                child: Image.asset(
                  "assets/images/logo2.jpg",
                ),
              ),
              SizedBox(
                width: 65,
              ),
              Text(
                'Artisto',
                style: TextStyle(
                    color: Color.fromARGB(255, 238, 234, 234),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await _authService.logout();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.red,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        index: 0,
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
            hasNotificationFunction(); // #temporary
            // TODO: open favorite screen

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
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('skills', arrayContains: "7777")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(snapshot.error.toString()),
              );
            }

            List<Artistoo> _Userss = snapshot.data!.docs
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
                      SizedBox(
                        height: 130,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Sponsered \nCompany ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(179, 0, 0, 0),
                                        fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      SizedBox(
                        width: 155,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: Color.fromARGB(255, 154, 7, 7),
                              elevation: 4,
                              child: Column(
                                children: [
                                  Container(
                                    height: 88,
                                    child: Image.asset(
                                      "assets/images/DLMUSIC.png",
                                    ),
                                  ),
                                  Container(
                                    height: 22,
                                    child: Text(
                                      "DL Music Co.  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(179, 0, 0, 0),
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Get.to(() => DlmusicScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(
                    left: 10, top: 5, bottom: 5, right: 10),
                // color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: 33,
                        child: GeneralDropDownButton(
                          itemsList: RequiredStrings.postCategories,
                          selectedItem: selectedCategory,
                          valueChanged: (value) {
                            setState(() {
                              if (value == 'All') {
                                selectedCategory = null;
                              } else {
                                selectedCategory = value;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // sections screen column > (body) .
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
  Widget postUserssContainer({required Artistoo UserPost}) {
    if (UserPost.type == 'Album') {
      _post_color = Color.fromARGB(255, 222, 30, 16);
    } else {
      _post_color = Color.fromARGB(255, 39, 2, 170);
    }

    String SongPrice = "free";
    if (UserPost.AlbumPrice == "") {
      SongPrice = "Free";
    } else {
      SongPrice = UserPost.AlbumPrice.toString();
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
                height: 120,
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

                        //Image.asset(  vacancy.user.imgUrl.toString(),
                        // "assets/images/logo2.jpg",
                        //    "_Bids[index].profileImage",
                        //),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PublisherBio(
                                  // before using model   index: index,
                                  Bids: UserPost,
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
                          " ${UserPost.title} / ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 15.0),
                        ),
                        Text(
                          '${UserPost.type[0]}',
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
                    height: 35,
                    child: Text(
                      UserPost.description,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: FutureBuilder(
                      future: UserAlbumPoster(
                              MyUser: UserPost.user.email,
                              MyTitle: UserPost.title)
                          .getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                            "Something went wrong",
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            width: 100,
                            child: Image.network(
                              snapshot.data.toString(),
                            ),
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BidInfos(
                      Bids: UserPost,
                    ),
                  ),
                );
              },
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
                          SongPrice,
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
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            final box = Hive.box('favBox');
                            box.put(UserPost.createdAt.toIso8601String(),
                                UserPost.toMap());

                            final dataFromBox =
                                box.get(UserPost.createdAt.toIso8601String());
                            Artistoo _PostFromBox =
                                Artistoo.fromMap(dataFromBox);

                            print(_PostFromBox.toString());
                          });
                        },
                        icon: Icon(favIconFill, color: Colors.red),
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

// ##widget this widget handle the notificationIconButton state if it has notification or not.
  Widget notificationIconButton() {
    IconData notificationIcon = Icons.notifications_outlined; // off
    IconData hasNotificationIcon = Icons.notifications_active; // on

    return IconButton(
      onPressed: () {
        if (ButtonValueChanger.hasNotification) {
          setState(() {
            ButtonValueChanger.hasNotification = false;
          });
        }
        debugPrint('notifications icon clicked');
        debugPrint(
            'ValueChanger.hasNotification= ${ButtonValueChanger.hasNotification.toString()}');
        // TODO: open notification list here
      },
      icon: Icon(
          ButtonValueChanger.hasNotification
              ? hasNotificationIcon
              : notificationIcon,
          size: 30),
    );
  }

// ###method this hasNotificationFunction function is used to change notification icon status, while invoking it.
  void hasNotificationFunction() {
    setState(() {
      ButtonValueChanger.hasNotification = true;
    });
    debugPrint(
        'hasNotificationFunction() executed •• ValueChanger.hasNotification= ${ButtonValueChanger.hasNotification.toString()}');
  }
}

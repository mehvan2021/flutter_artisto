import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistScreen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_My_Posts.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistsListScreen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/SongScreen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/button_value_changer.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/create_profile.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);
  Color _post_color = Color.fromARGB(255, 81, 71, 71);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Favourite List',
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
        index: 1,
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
            Get.to(() => FavoritesScreen()); // TODO: open favorite screen

          } else if (index == 2) {
            Get.to(() => PublisherList());
          } else if (index == 3) {
            Get.to(() => ArtistoMyHomeScreen());
          }
        },
      ),
      body: Container(
          child: ValueListenableBuilder<Box>(
        valueListenable: Hive.box('favBox').listenable(),
        builder: (context, box, widget) {
          return Center(
            child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> _data = box.getAt(index);
                  Artistoo _Artistoo =
                      Artistoo.fromMap(_data.cast<String, dynamic>());
                  if (_Artistoo.type == 'Music') {
                    _post_color = Color.fromARGB(255, 222, 30, 16);
                  } else {
                    _post_color = Color.fromARGB(255, 39, 2, 170);
                  }

                  return Container(
                    padding: EdgeInsets.all(3),
                    child: Card(
                      elevation: 5,
                      shape: Border(
                          right: BorderSide(color: _post_color, width: 5)),
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
                                        future: UserProfileImage(
                                                ProfilePic:
                                                    _Artistoo.user.email)
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

                                      //Image.asset(  vacancy.user.imgUrl.toString(),
                                      // "assets/images/logo2.jpg",
                                      //    "_Bids[index].profileImage",
                                      //),
                                    ),
                                    Text(
                                      _Artistoo.user.name,
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
                                                Bids: _Artistoo,
                                              )));
                                },
                              ),
                            ),
                          ),
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
                                        " ${_Artistoo.title} / ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(179, 0, 0, 0),
                                            fontSize: 15.0),
                                      ),
                                      Text(
                                        //'${UserPost.name[0]}',
                                        _Artistoo.type,
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
                                        _Artistoo.description,
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => BidInfos(
                              //       // before using model   index: index,
                              //       Bids: _Artistoo,
                              //     ),
                              //   ),
                              // );
                            },
                          ),

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
                                        //  mockData[index]["singer_name"].toString(),
                                        'Bids',

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
                                        //  mockData[index]["first_bid"].toString(),
                                        _Artistoo.SongLang,
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
                                        //  mockData[index]["first_bid"].toString(),
                                        _Artistoo.AlbumPrice.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(179, 0, 0, 0),
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

// bid list
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      )),
    );
  }
}

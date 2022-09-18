// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/ArtistsListScreen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/Image_Storage.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/upload_image_screen_view.dart';
import 'package:flutter_artisto/src/screens/fav_screen/fav_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/strings.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';
import 'package:flutter_artisto/widget/create_profile_textfield.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key, required this.isUpdate})
      : super(key: key);

  final bool isUpdate;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController SocialAccController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();

  //* put first value of the item list in dropdownValue.
  String dropdownValue = 'Select City';
  @override
  Widget build(BuildContext context) {
    ArtistooUser Artistoo_User = context.watch<UserProvider>().Artistoo_User!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile info',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          Container(
            width: 75,
            margin: EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: ElevatedButton(
              onPressed: () async {
                ArtistooUser newArtistoo_User = ArtistooUser(
                  name: nameController.text.isEmpty
                      ? Artistoo_User.name
                      : nameController.text,
                  createdAt: DateTime.now(),
                  uid: Artistoo_User.uid,
                  email: Artistoo_User.email,
                  ArtCoin: Artistoo_User.ArtCoin,
                  website: websiteController.text,
                  SocialAcc: SocialAccController.text,
                  phone: whatsAppController.text.isEmpty ||
                          whatsAppController.text.length < 7
                      ? Artistoo_User.phone
                      : whatsAppController.text,
                  inlist: ['0'],
                );

                //TODO: update the current user with the new data
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(Artistoo_User.uid)
                    .update(
                      newArtistoo_User.toMap(),
                    )
                    .then((value) => Get.to(ArtistoHomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 0),
                  primary: Color.fromARGB(255, 229, 61, 61),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // <-- Radius
                  ),
                  elevation: 0),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //         Text(Artistoo_User.name),
            //       Text(Artistoo_User.email),
            //     Text(Artistoo_User.uid),
            SizedBox(height: 20),
            Container(
              color: Color.fromARGB(255, 179, 177, 177),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          maxRadius: 40,
                          backgroundColor: Colors.grey[500],
                          child: Container(
                            child: FutureBuilder(
                              future: UserProfileImage(
                                      ProfilePic: Artistoo_User.email)
                                  .getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Image.asset(
                                    "assets/images/logo2.jpg",
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
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Column(
                      children: [
                        Text(
                          "Profile Picture",
                          style: TextStyle(
                              //   color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.to(() => UploadImageScreen());
                              },
                              icon: Icon(Icons.upload),
                              label: Text(
                                'Upload',
                                style: TextStyle(fontSize: 12),
                              ),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
              child: Row(
                children: [
                  Text(
                    "Name / ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                  Text(
                    Artistoo_User.name,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                ],
              ),
            ),
            CustomTextFieldForm(
              controller: nameController,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 10),
              child: Text(
                "City",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
              ),
            ),
            Container(
              width: 365,
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Color(0xffF6FAFB),
                  filled: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                iconSize: 27,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: RequiredCity.UserCity.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
              child: Row(
                children: [
                  Text(
                    "Website / ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                  // Text(
                  //   Artistoo_User.website!,
                  //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  // ),
                ],
              ),
            ),
            CustomTextFieldForm(
              controller: websiteController,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
              child: Row(
                children: [
                  Text(
                    "Instagram / ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                  // Text(
                  //   Artistoo_User.SocialAcc!,
                  //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  // ),
                ],
              ),
            ),
            CustomTextFieldForm(
              controller: SocialAccController,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
              child: Row(
                children: [
                  Text(
                    "whatsapp / ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                  // Text(
                  //   Artistoo_User.phone!,
                  //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  // ),
                ],
              ),
            ),
            CustomTextFieldForm(
              controller: whatsAppController,
            ),
          ],
        ),
      ),
    );
  }
}

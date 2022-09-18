import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';
import 'package:flutter_artisto/src/services/storage_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/strings.dart';
import 'package:flutter_artisto/src/common/widgets/general_drop_down_widget.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => deferent();
}

class deferent extends State<CreatePostScreen> {
  FireStoreService _fireStoreService = FireStoreService();

  PlatformFile? file;
  bool colorSwitch = true;
  Color? color1 = Colors.grey[200];
  Color? color2 = Colors.grey[300];

  List<String> SongsLang = [
    'kurdish',
    'English',
    'Arabic',
    'Persian',
    'Turkish',
    'Cocktail',
    'Melody',
  ];
  List<String> typeList = ['Album', 'Single'];

  String? selectedtypeOfPost;
  String? SongLangSelected = 'kurdish';

  String? selectedCategory = RequiredStrings.postCategories.first;

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController AlbumPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.red,
        title: Text(
          'POST INFO',
          style: headerTextStyle(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headerInformationOfInputs(name: 'Type'),
                  // space between header and Input.
                  spaceBetweenHeaderAndInput(),
                  // DropDown Button for Type of album.
                  GeneralDropDownButton(
                      selectedItem: selectedtypeOfPost,
                      itemsList: typeList,
                      valueChanged: (Post) => selectedtypeOfPost = Post),

                  //* Title of the post
                  // space between header and Input.
                  spaceBetweenHeaderAndInput(),
                  // TextField for title of the post
                  textField(
                      name: 'Title',
                      textController: titleTextEditingController),

                  ///
                  ///
                  ///

                  //* Description of post
                  // space between header and input widget
                  spaceBetweenHeaderAndInput(),
                  textField(
                      textController: descriptionTextEditingController,
                      name: 'Description'),

                  // space between header and input widget
                  spaceBetweenHeaderAndInput(),
                  // DropDown Button for Language
                  GeneralDropDownButton(
                      selectedItem: SongLangSelected,
                      itemsList: SongsLang,
                      valueChanged: (Langs) => setState(() {
                            SongLangSelected = Langs;
                          })),

                  // Space between 2 input Widget
                  spaceBetweenHeaderAndInput(),
                  // DropDown Button for price
                  textField(
                      textController: AlbumPriceController, name: 'Price'),

// select album picture
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  file?.name ?? "No File selected",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                  child: const Text(
                                    "Select Album Clipboard",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //  viewdata and share
                  spaceBetweenHeaderAndInput(),

                  ElevatedButton.icon(
                      onPressed: () {
                        ArtistooUser? Artistoo_User =
                            context.read<UserProvider>().Artistoo_User;
                        if (Artistoo_User != null) {
                          Artistoo _MyPosts = Artistoo(
                              type: selectedtypeOfPost ?? typeList.first,
                              title: titleTextEditingController.text,
                              description:
                                  descriptionTextEditingController.text,
                              AlbumPrice: int.parse(AlbumPriceController.text),
                              SongLang: SongLangSelected ??
                                  SongsLang.firstWhere(
                                      (element) => element == 'Kurdish'),
                              category: selectedCategory ??
                                  RequiredStrings.postCategories.first,
                              createdAt: DateTime.now(),
                              expDate: DateTime.now().add(Duration(days: 15)),
                              user: Artistoo_User);

                          Get.defaultDialog(
                            title: 'values',
                            content: Container(
                              height: 500,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(_MyPosts.type.toString()),
                                      Text(_MyPosts.title.toString()),
                                      Text(_MyPosts.description.toString()),
                                      Text(_MyPosts.SongLang.toString()),
                                      Text(_MyPosts.AlbumPrice.toString()),
                                    ],
                                  )),
                                  ElevatedButton(
                                      onPressed: () async {
                                        //TODO: _loading

                                        await _fireStoreService
                                            .addNewPost(_MyPosts)
                                            .then((value) {
                                          debugPrint(" ref id  :  " + value.id);

                                          CloudStorage().uploadFile(context,
                                              platformFile: file!,
                                              MyTitle: _MyPosts.title,
                                              MyUser: Artistoo_User.email);
                                          Get.to(() => ArtistoHomeScreen());
                                        });
                                      },
                                      child: Text('Share'))
                                ],
                              ),
                            ),
                          );
                        } else {
                          Get.snackbar('Error',
                              'You don\'t have the privileges to do that ');
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text('View data before share')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // this is the style of header text
  // Have Font Weight Bold and font Size 20
  TextStyle headerTextStyle() {
    return TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  // Information Header Text Style
  // Font Weight is BOLD.
  TextStyle informationHeaderOfInputsTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  // this is the header of the text field and drop down button.
  Widget headerInformationOfInputs({required String name}) {
    return Container(
      margin: EdgeInsets.only(right: 250, left: 24),
      child: Text(
        name,
        style: informationHeaderOfInputsTextStyle(),
      ),
    );
  }

  // space between the header and input widget
  Widget spaceBetweenHeaderAndInput() {
    return SizedBox(
      height: 15,
    );
  }

  // space between 2 input widget
  Widget spaceBetweenTwoInput() {
    return SizedBox(
      height: 40,
    );
  }

  // text field
  Widget textField(
      {required TextEditingController textController, required String name}) {
    return Container(
      width: 340,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.red),
            label: Text(name),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),
      ),
    );
  }
}

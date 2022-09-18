import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool isLoading = false;
  String? downloadUrl;

  String ProfilePic = "";

  // String ProfilePic = Artistoo_User.email;

  @override
  Widget build(BuildContext context) {
    ArtistooUser Artistoo_User = context.watch<UserProvider>().Artistoo_User!;
    ProfilePic = Artistoo_User.email;

    return Scaffold(
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _selectedImage == null
                      ? Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Center(
                              child: Column(
                            children: [
                              //    Image.file(File(_selectedImage!.path)),
                              Text(Artistoo_User.email),

                              Text('please select an image'),
                            ],
                          )),
                        )
                      : Container(
                          child: Image.file(File(_selectedImage!.path)),
                        ),
                  ElevatedButton(
                      onPressed: () async {
                        XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        setState(() {
                          _selectedImage = image;
                        });

                        //TODO: select an image
                      },
                      child: Text('select profile image')),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      setState(() {});
                      uploadImage(File(_selectedImage!.path));
                    },
                    child: Text('apply profile image'),
                  ),
                  downloadUrl == null
                      ? Container()
                      : SelectableText("your profile changed successfully"),
                ],
              ),
            ),
    );
  }

  uploadImage(File file) async {
    //TODO: _loading when image i being uploaded
    String fileName = ProfilePic.toString();
    final storageRef = FirebaseStorage.instance.ref();
    //if we have a user you can do it like this
    final imagesRef = storageRef.child("images/$fileName");
    imagesRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          debugPrint('running');
          break;
        case TaskState.paused:
          setState(() {
            isLoading = false;
          });
          debugPrint('paused');
          break;
        case TaskState.success:
          downloadUrl = await imagesRef.getDownloadURL();

          setState(() {
            isLoading = false;
          });
          debugPrint('success, download url : $downloadUrl');
          break;
        case TaskState.canceled:
          debugPrint('cancel');
          setState(() {
            isLoading = false;
          });
          break;
        case TaskState.error:
          setState(() {
            isLoading = false;
          });
          debugPrint('error');
          break;
      }
    });
  }
}

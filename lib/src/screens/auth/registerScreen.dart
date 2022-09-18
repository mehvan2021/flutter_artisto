import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/common/widgets/loading_indicator.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';

import 'package:flutter_artisto/src/screens/auth/login_screen.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/create_profile.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:flutter_artisto/src/services/firestore_service.dart';
import 'package:flutter_artisto/widget/costum_button.dart';
import 'package:flutter_artisto/widget/costum_textField.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthService authService = AuthService();
  FireStoreService fireStoreService = FireStoreService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? LoadingIndicator()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child: Image.asset(
                        "assets/images/logo2.jpg",
                      ),
                    ),
                    Align(
                      alignment: Alignment(-1, -1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Form(
                          child: Column(
                        children: [
                          CostumeTextField(
                            hint: 'User Name',
                            control: userNameController,
                            icon: Icon(Icons.person),
                          ),
                          CostumeTextField(
                            hint: 'Email',
                            control: emailController,
                            icon: Icon(Icons.alternate_email),
                          ),
                          CostumeTextField(
                            hint: 'Password',
                            control: passwordController,
                            icon: Icon(Icons.lock_outline),
                          ),
                        ],
                      )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CostumeButton(
                      onPressedd: () async {
                        setState(() {
                          isLoading = true;
                        });
                        //first step firebase auth to register user with the auth
                        await authService
                            .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text)
                            .then((userCredential) async {
                          //second step
                          if (userCredential != null &&
                              userCredential.user != null) {
                            await fireStoreService
                                .addUserWithInitialInformationToDB(
                                    user: userCredential.user!,
                                    userName: userNameController.text)
                                .then((Artistoo_User) {
                              context
                                  .read<UserProvider>()
                                  .setArtistoo_User(Artistoo_User);

                              setState(() {
                                isLoading = false;
                              });

                              Get.to(() => CreateProfileScreen(
                                    isUpdate: false,
                                  ));
                            });
                            setState(() {
                              isLoading = false;
                            });
                          }

                          // navigate to next screen

                          // Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CreateProfileScreen()));
                        });
                      },
                      color: Colors.red,
                      text: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Already have account ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromARGB(255, 21, 116, 224),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

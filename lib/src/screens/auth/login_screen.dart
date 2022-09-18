import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/auth/forgot_pass_screen.dart';
import 'package:flutter_artisto/src/screens/auth/handler_screen.dart';
import 'package:flutter_artisto/src/screens/auth/registerScreen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:flutter_artisto/widget/costum_button.dart';
import 'package:flutter_artisto/widget/costum_textField.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Form(
                    child: Column(
                  children: [
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
                    Align(
                      alignment: Alignment(1, 1),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ForgotPassScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: 15,
              ),
              CostumeButton(
                onPressedd: () async {
                  //First step auth with firebase auth
                  await authService
                      .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text)
                      .then((value) => Get.to(() => HandlerScreen()));
                },
                color: Colors.red,
                text: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Don't Have An Account ? ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Register',
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

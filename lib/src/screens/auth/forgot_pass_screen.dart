import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/screens/auth/login_screen.dart';
import 'package:flutter_artisto/src/services/auth_service.dart';
import 'package:flutter_artisto/widget/costum_button.dart';

import '../../../widget/costum_textField.dart';

class ForgotPassScreen extends StatefulWidget {
  ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController emailController = TextEditingController();
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
                'https://image.freepik.com/free-vector/forgot-password-concept-isolated-white_263070-194.jpg'),
            Column(
              children: [
                Align(
                  alignment: Alignment(-1, -1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Forgot Passowrd ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment(-1, -1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Don't worry it happens, please enter email associated with your account ",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                ),
              ],
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CostumeButton(
              onPressedd: () {
                auth.forgetPassword(email: emailController.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
              },
              color: Colors.red,
              text: Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

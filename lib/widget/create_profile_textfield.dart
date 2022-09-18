import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CustomTextFieldForm extends StatelessWidget {
  const CustomTextFieldForm({
    Key? key,
    this.controller,
    this.validator,
    this.text,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? text;
  @override
  Widget build(BuildContext context) {
    ArtistooUser Artistoo_User = context.watch<UserProvider>().Artistoo_User!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color.fromARGB(220, 197, 197, 197),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

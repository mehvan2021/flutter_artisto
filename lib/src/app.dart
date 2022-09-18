import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_artisto/src/screens/auth/forgot_pass_screen.dart';
import 'package:flutter_artisto/src/screens/auth/handler_screen.dart';
import 'package:flutter_artisto/src/screens/Artisto_screens/Artisto_Home_screen.dart';
import 'package:flutter_artisto/src/screens/screenHandler.dart';

class ArtistooApp extends StatelessWidget {
  const ArtistooApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //change to Getmaterial app to use the get package
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ArtistooApp',
        theme: ThemeData(
          // brightness: Brightness.dark,
          fontFamily: GoogleFonts.roboto().fontFamily,
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            titleMedium: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.roboto().fontFamily),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.red,
            titleTextStyle: TextStyle(
              color: Colors.grey[800],
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                buttonColor: Colors.amber,
                textTheme: ButtonTextTheme.primary,
              ),
        ),
        home: HandlerScreen());
  }
}

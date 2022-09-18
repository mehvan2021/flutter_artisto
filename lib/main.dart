import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_artisto/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_artisto/src/models/Artisto_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  final favBox = await Hive.openBox('favBox');
  // favBox.delete('jobId');
  // debugPrint(favBox.get('jobId'));

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: ArtistooApp(),
    ),
  );
}

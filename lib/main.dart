import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/registration.dart';
import 'package:flutter_app/authorization.dart';
import 'package:flutter_app/viewimages.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter PR3',
        theme: ThemeData(scaffoldBackgroundColor: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        home: PageView(children: const [
          Authorization(), //экран 1
          Registration(), //экран 2
          ViewImages(), //экран 3
        ]));
  }
}

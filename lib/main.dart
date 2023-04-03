import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/registration.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'authorization.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
//навигация
  final GoRouter _newRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const EmailAuth(),
        routes: [
          GoRoute(
            path: "email",
            builder: (context, state) => const Authorization(),
          )
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter PR3',
      theme: ThemeData(scaffoldBackgroundColor: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      routerConfig: _newRouter,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ));
  }
}

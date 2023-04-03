import 'package:universal_html/html.dart' as unhtml;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

import 'package:path/path.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({Key? key}) : super(key: key);

  @override
  State<EmailAuth> createState() => MyApp();
}

String email = '';

class MyApp extends State<EmailAuth> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.blueAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    setState(() {
      email = unhtml.window.location.href
          .substring(36, unhtml.window.location.href.length);
    });
  }

  GlobalKey<FormState> _key = GlobalKey();
  //При изменении ввода в текстовом поле связанный объект TextEditingController уведомляет слушателей об изменении, и хранит соотвествующие данные
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _userNameSingIn = TextEditingController();
  TextEditingController _passwordSingIn = TextEditingController();
  TextEditingController _userNameSingUp = TextEditingController();
  TextEditingController _passwordSingUp = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    //патерн regex валидации адреса почты
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Адрес электронной почты неверного формата!'
          : null;
    }

    void searchEmail() async {
      String address = unhtml.window.location.href
          .substring(36, unhtml.window.location.href.length);
      print(address);
    }

//функция регистрации
    void signUpEmailPassword() async {
      try {
        //создание пользоватля по почте и паролю
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _userNameSingUp.text, password: _passwordSingUp.text);
        // всплывающие сообщения об успешной регистрации
        const snackBar = SnackBar(
          content: Text('Успешная регистрация'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } //при ошибке не создает пользоватлея и выводит смс о неправильнстии ввода данных
      on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('Данные введены неверно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

//функция авторизации
    void signInEmailPassword() async {
      try {
        //авторизация пользоватля по почте и паролю
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _userNameSingIn.text, password: _passwordSingIn.text);
        print(user.user?.email);
        print(user.user?.uid);
        const snackBar = SnackBar(
          content: Text('Авторизация прошла успешно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } //при ошибке не авторизирует пользоватлея и выводит смс о неправильнстии ввода данных
      on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('Данные введены неверно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Text('Успешная авторизация пользователя $email по Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
              ]),
        ),
      ),
    );
  }
}

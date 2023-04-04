import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';

//класс авторизации
class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => MyApp();
}

class MyApp extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Авторизации',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
  //При изменении ввода в текстовом поле связанный объект TextEditingController уведомляет слушателей об изменении, и хранит соотвествующие данные
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _userNameSignIn = TextEditingController();
  TextEditingController _passwordSignIn = TextEditingController();
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

//функция авторизации
    void signInEmailPassword() async {
      try {
        //авторизация пользоватля по почте и паролю
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _userNameSignIn.text, password: _passwordSignIn.text);
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

//функция анонимного входа
    void signInAnonimous() async {
      try {
        //авторизация пользоватля анонимно
        final user = await FirebaseAuth.instance.signInAnonymously();
        print(user.user?.uid);
        const snackBar = SnackBar(
          content: Text('Авторизация под анонимом прошла успешно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } //при ошибке не авторизирует пользоватлея и выводит смс об ошибке
      on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('Error!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

//оформление страницы
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Авторизация",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: _userNameSignIn,
              autovalidateMode: AutovalidateMode.always,
              validator: validateEmail,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Введите электронную почту',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: _passwordSignIn,
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Введите пароль',
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton(
                onPressed: () {
                  signInEmailPassword();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Авторизация",
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton(
                onPressed: () {
                  signInAnonimous();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Вход в систему(аноним)",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

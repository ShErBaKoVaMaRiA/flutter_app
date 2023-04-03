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
  //При изменении ввода в текстовом поле связанный объект TextEditingController уведомляет слушателей об изменении, и хранит соотвествующие данные
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _userNameSignIn = TextEditingController();
  TextEditingController _passwordSignIn = TextEditingController();
  TextEditingController _userNameSignUp = TextEditingController();
  TextEditingController _passwordSignUp = TextEditingController();
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

//функция регистрации
    void signUpEmailPassword() async {
      try {
        //создание пользоватля по почте и паролю
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _userNameSignUp.text, password: _passwordSignUp.text);
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
        child: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            SizedBox(height: 20.0),
            const Text('Авторизация',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        //Интерфейс навигации основан на всплывающие элементы и вкладки
                        child: const TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: "Регистрация"),
                            Tab(text: "Авторизация"),
                          ],
                        ),
                      ),
                      Container(
                          height: 700, //height of TabBarView
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          //содержкание вкладок
                          child: TabBarView(children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Регистрация",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16),
                                    child: TextFormField(
                                      controller: _userNameSignUp,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: validateEmail,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Введите электронную почту',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: _passwordSignUp,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Введите пароль',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          signUpEmailPassword();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text("Регистрация",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Авторизация",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: TextFormField(
                                        controller: _userNameSignIn,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: validateEmail,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText:
                                              'Введите электронную почту',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
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
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            signInEmailPassword();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text("Вход в систему",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black)),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            signInAnonimous();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.indigo),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text("Вход в систему(аноним)",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black)),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ]))
                    ])),
          ]),
        ),
      ),
    );
  }
}

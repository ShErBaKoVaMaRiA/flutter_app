import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/profileUser.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/userspage.dart';
import 'package:flutter_app/imagespage.dart' as imagepage;

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<Menu> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text("Меню",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AllUsers()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Все пользователи",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ]),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Профиль",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ]),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Выход",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ]),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const imagepage.MyApp()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Мои картинки",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ]),
            ),
          ),
        ),
      ])),
    );
  }
}

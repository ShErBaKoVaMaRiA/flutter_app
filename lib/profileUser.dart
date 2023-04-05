import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/main.dart';

QuerySnapshot? querySnapshot;
CollectionReference users = FirebaseFirestore.instance.collection('users');

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController _email = new TextEditingController();
  TextEditingController _oldPassword = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(_setscreen);
  }

  Future<void> _setscreen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences!.getString('users'));
    querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: sharedPreferences!.getString('users'))
        .get();
    _email.text = querySnapshot?.docs.first.get('name');
  }

  void refreshProfile() async {
    if (querySnapshot?.docs.first.get('password') == _oldPassword.text) {
      querySnapshot?.docs.forEach((doc) {
        users.doc(doc.id).update({'password': _newPassword.text});
      });
      final User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(_newPassword.text);
    } else {
      const snackBar = SnackBar(
        content: Text('Неверный пароль'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: Colors.grey,
          title: const Text(
            'Профиль',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    controller: _oldPassword,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Введите старый пароль',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    controller: _newPassword,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Введите новый пароль',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        refreshProfile();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          )),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Изменить данные профиля",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ]),
                    ),
                  ),
                ),
              ],
            )),
          ],
        )));
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
QuerySnapshot? querySnapshot;
SharedPreferences? sharedPreferences;
List<Map<String, dynamic>> userList = [];
CollectionReference usersImage =
    FirebaseFirestore.instance.collection('images');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ViewImages());
}

class ViewImages extends StatelessWidget {
  const ViewImages({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Картинки'),
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
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController _nameController = new TextEditingController();
  int _counter = 0;

  // void _incrementCounter() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     dialogTitle: 'Выбор файла',
  //   );
  //   if (result != null) {
  //     final size = result.files.first.size;
  //     final file = io.File(result.files.single.path!);
  //     final fileExtensions = result.files.first.extension!;
  //     print("размер:$size file:${file.path} fileExtensions:${fileExtensions}");
  //     String names = getRandomString(5);
  //     await FirebaseStorage.instance.ref().child(names).putFile(file);

  //     final urlFile =
  //         await FirebaseStorage.instance.ref().child(names).getDownloadURL();
  //     final imagesAdd = fireStore.collection('images');
  //     imagesAdd
  //         .add(
  //           {
  //             'name': names,
  //             'nameFile': names,
  //             'size': result.files.first.size,
  //             'url': urlFile,
  //             'user': sharedPreferences!.getString('users')
  //           },
  //         )
  //         .then((value) => print('Add image'))
  //         .catchError((error) => print('Faild add: $error'));
  //   } else {}
  //   initImage();
  // }

  // Future<void> DeleteImage() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   await FirebaseStorage.instance.ref("/" + fullname).delete();
  //   if (link != '') {
  //     querySnapshot = await FirebaseFirestore.instance
  //         .collection('images')
  //         .where('url', isEqualTo: link)
  //         .get();
  //     fullpath.clear();

  //     querySnapshot?.docs.forEach((doc) async {
  //       await usersImage.doc(doc.id).delete();
  //     });
  //   }
  //   initImage();
  // }

  String link = '';
  String fullname = '';
  List<ModelImages> fullpath = [];

  // Future<void> UpdateImage() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   if (link != '') {
  //     querySnapshot = await FirebaseFirestore.instance
  //         .collection('images')
  //         .where('url', isEqualTo: link)
  //         .get();
  //     fullpath.clear();

  //     querySnapshot?.docs.forEach((doc) async {
  //       await usersImage.doc(doc.id).update({'nameFile': _nameController.text});
  //     });
  //   }
  //   initImage();
  // }

  // final _chars =
  //     'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // Random _rnd = Random();
  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> initImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    querySnapshot = await FirebaseFirestore.instance.collection('images').get();
    fullpath.clear();

    final storageReference = querySnapshot!.docs.toList();
    final list = await storageReference;
    list.forEach((element) async {
      final url = await element.get('url');
      final name = await element.get('nameFile');
      final nameFile = await element.get('name');
      final size = await element.get('size');
      fullpath.add(ModelImages(url, name, size, nameFile));
      setState(() {
        link = '';
        _nameController.text = '';
      });
    });
  }

  @override
  void initState() {
    initImage().then(
      (value) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
        title: const Text(
          'Картинки',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: fullpath.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.network(
                            fullpath[index].url,
                            errorBuilder: (context, error, stackTrace) {
                              return Text('');
                            },
                          ),
                        ),
                        title: Text("Название: " + fullpath[index].name),
                        subtitle: Text("Размер: " +
                            fullpath[index].size.toString() +
                            " Ссылка: " +
                            fullpath[index].url),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelImages {
  final String url;
  final String name;
  final String nameFile;
  final int size;

  ModelImages(this.url, this.name, this.size, this.nameFile);
}

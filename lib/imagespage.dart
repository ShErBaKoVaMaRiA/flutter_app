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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Мои картинки'),
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

  void _incrementCounter() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Выбор файла',
    );
    if (result != null) {
      final size = result.files.first.size;
      final file = io.File(result.files.single.path!);
      final fileExtensions = result.files.first.extension!;
      print("размер:$size file:${file.path} fileExtensions:${fileExtensions}");
      String names = getRandomString(5);
      await FirebaseStorage.instance.ref().child(names).putFile(file);

      final urlFile =
          await FirebaseStorage.instance.ref().child(names).getDownloadURL();
      final imagesAdd = fireStore.collection('images');
      imagesAdd
          .add(
            {
              'name': names,
              'nameFile': names,
              'size': result.files.first.size,
              'url': urlFile,
              'user': sharedPreferences!.getString('users')
            },
          )
          .then((value) => print('Add image'))
          .catchError((error) => print('Faild add: $error'));
    } else {}
    initImage();
  }

  Future<void> DeleteImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await FirebaseStorage.instance.ref("/" + fullname).delete();
    if (link != '') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('url', isEqualTo: link)
          .get();
      fullpath.clear();

      querySnapshot?.docs.forEach((doc) async {
        await usersImage.doc(doc.id).delete();
      });
    }
    initImage();
  }

  String link = '';
  String fullname = '';
  List<ModelImages> fullpath = [];

  Future<void> UpdateImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (link != '') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('url', isEqualTo: link)
          .get();
      fullpath.clear();

      querySnapshot?.docs.forEach((doc) async {
        await usersImage.doc(doc.id).update({'nameFile': _nameController.text});
      });
    }
    initImage();
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> initImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('user', isEqualTo: sharedPreferences!.getString('users'))
        .get();
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
          'Картинки пользователя',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
          ),
        ],
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
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  link = fullpath[index].url;
                                  fullname = fullpath[index].nameFile;
                                  await DeleteImage();
                                }),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    link = fullpath[index].url;
                                    _nameController.text = fullpath[index].name;
                                  });
                                })
                          ],
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
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Название файла',
                        ),
                      ),
                    ),
                    Image.network(
                      link,
                      width: 150,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Картинка не выбрана');
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          await UpdateImage();
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ))
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

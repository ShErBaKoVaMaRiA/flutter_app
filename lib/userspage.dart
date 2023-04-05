import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AllUsersState();
}

class AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('users');

    Future<void> getData() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();
      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      print(allData);
    }

    print("-----------");
    getData();
    Future getDocs() async {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        print(a.id);
      }
    }

    print("-----------");
    getDocs();

    getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
      return snapshot.data!.docs
          .map((doc) => ListTile(
                title: Text(doc["name"]),
                subtitle: Text(doc["password"].toString()),
              ))
          .toList();
    }

    print("-----------");
    return Scaffold(
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text("There is no expense");
                return ListView(children: getExpenseItems(snapshot));
              }),
        ),
      ),
    );
  }
}


//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         foregroundColor: Colors.grey,
//         title: const Text(
//           'Пользователи',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//          child: ListView(
//               children: allData.data!.docs
//                   .map((DocumentSnapshot document) {
//                       List<DocumentSnapshot> items = allData;
//                     return Card(
//                       child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: Text(
//                               usersStream['name'].toString().substring(0, 1),
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20),
//                             ),
//                           ),
//                           title: Text(usersStream.first.hashCode('name'))),
//                     );
//                   })
//                   .toList()
//                   .cast(),
//       )
//     );
//   }
// }
  

//     // return Scaffold(
//     //   appBar: AppBar(
//     //     automaticallyImplyLeading: false,
//     //     foregroundColor: Colors.green,
//     //     title: const Text(
//     //       'Пользователи',
//     //       style: TextStyle(color: Colors.white),
//     //     ),
//     //     centerTitle: true,
//     //   ),
//     //   // body: Center(
//     //   //   child: StreamBuilder<QuerySnapshot>(
//     //   //     stream: usersStream,
//     //   //     builder: (context, snapshot) {
//     //   //       return ListView(
//     //   //         children: snapshot.data!.docs
//     //   //             .map((DocumentSnapshot document) {
//     //   //                 List<DocumentSnapshot> items = snapshot.data.docs;
//     //   //               return Card(
//     //   //                 child: ListTile(
//     //   //                     leading: CircleAvatar(
//     //   //                       backgroundColor: Colors.white,
//     //   //                       child: Text(
//     //   //                         usersStream['name'].toString().substring(0, 1),
//     //   //                         style: const TextStyle(
//     //   //                             color: Colors.white,
//     //   //                             fontWeight: FontWeight.bold,
//     //   //                             fontSize: 20),
//     //   //                       ),
//     //   //                     ),
//     //   //                     title: Text(usersStream.first.hashCode('name'))),
//     //   //               );
//     //   //             })
//     //   //             .toList()
//     //   //             .cast(),
//     //   //       );
//     //   //     },
//     //   //   ),
//     //   // ),
//     // );
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseServices {
//   final String? uid;
//   DatabaseServices({this.uid});

//   final CollectionReference usercollection =
//       FirebaseFirestore.instance.collection("users");
//   final CollectionReference groupcollection =
//       FirebaseFirestore.instance.collection("group");

//   Future updateUserdata(String fullname, String id) async {
//     return await usercollection
//         .doc(uid)
//         .set({"fullname": fullname, "email": id, "groups": [], "uid": uid});
//   }

//   Future creategroup(String username, String id, String groupName) async {
//     DocumentReference documentReference = await usercollection.add({
//       "email":groupName,

//     });
//   }
// }

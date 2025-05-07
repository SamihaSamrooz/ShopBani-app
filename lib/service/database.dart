import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getItems(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getCart(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }
}

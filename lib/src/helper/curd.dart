import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CrudMethods {
  Future<void> addData(feedData) async {
    print(feedData);
    FirebaseFirestore.instance
        .collection("allFeeds")
        .add(feedData)
        .then((value) => print(value))
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("allFeed").get();
  }
}

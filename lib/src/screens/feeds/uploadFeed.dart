import 'dart:io';
import 'package:alumni_portal/src/helper/sharedPref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:sizer/sizer.dart';

class UploadMyFeed extends StatefulWidget {
  @override
  _UploadMyFeedState createState() => _UploadMyFeedState();
}

class _UploadMyFeedState extends State<UploadMyFeed> {
  String? myProfilePic, author, currentCompany;

  Future<void> _getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        author = value.data()!['name'].toString();
        myProfilePic = (value.data()!['profilePicUrl']) ?? '';
        currentCompany = (value.data()!['currentCompany']);
      });
    });
  }

  void _submit() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myposts")
        .doc(DateTime.now().toString())
        .set({
      "Company": companyTextEditingController.text,
      "Exp": expTextEditingController.text,
      "author": author,
      "Year": yearTextEditingController.text,
      "userUID": FirebaseAuth.instance.currentUser!.uid,
      "currentCompany": currentCompany,
      "profilePicUrl": myProfilePic
    });

    await FirebaseFirestore.instance.collection("feeds").doc().set({
      "Company": companyTextEditingController.text,
      "author": author,
      "Exp": expTextEditingController.text,
      "Year": yearTextEditingController.text,
      "userUID": FirebaseAuth.instance.currentUser!.uid,
      'profilePic': myProfilePic,
      "currentCompany": currentCompany,
    });

    Navigator.pop(context);
  }

  Widget _submitButton() {
    return Container(
        child: Container(
      height: 50,
      width: 50.w,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 1, 81, 230),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          child: Text(
            'Post',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: (() {
            _submit();
          })),
    ));
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  TextEditingController expTextEditingController = new TextEditingController();
  TextEditingController yearTextEditingController = new TextEditingController();
  TextEditingController companyTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 15, 33, 231),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 142, 142, 142),
                      width: 2,
                    ),
                    color: Color.fromARGB(217, 254, 254, 250),
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextField(
                      controller: companyTextEditingController,
                      decoration: InputDecoration(hintText: "Company"),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 142, 142, 142),
                      width: 2,
                    ),
                    color: Color.fromARGB(217, 254, 254, 250),
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextField(
                      controller: yearTextEditingController,
                      decoration: InputDecoration(hintText: "Year"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 142, 142, 142),
                      width: 2,
                    ),
                    color: Color.fromARGB(217, 254, 254, 250),
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextField(
                      controller: expTextEditingController,
                      decoration:
                          InputDecoration(hintText: "Experience/Other Details"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                _submitButton(),
              ],
            )),
      ),
    );
  }
}

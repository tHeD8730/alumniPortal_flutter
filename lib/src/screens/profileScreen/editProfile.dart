import 'dart:io';

import 'package:alumni_portal/src/screens/homePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name,
      profilePicUrl = '',
      currentcompany = '',
      role = '',
      linkedIn = '',
      github = '',
      codeforces = '',
      codechef = '',
      graduationYear = '';
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      final imageSelected = File(image!.path);
      setState(() {
        this.image = imageSelected;
      });
    } on PlatformException catch (e) {
      print("Failed");
    }
  }

  void uploadDetails() async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child("profile")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .putFile(File(image!.path));
    } on FirebaseException catch (e) {
      print(e.toString());
    }
    try {
      await FirebaseStorage.instance
          .ref()
          .child("profile")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .getDownloadURL()
          .then((value) {
        profilePicUrl = value;
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc((await FirebaseAuth.instance.currentUser!.uid))
          .update(
        {
          'name': name,
          'profilePicUrl': profilePicUrl,
          'currentCompany': currentcompany,
          'graduationYear': graduationYear,
          'role': role,
          'github': github,
          'linkedIn': linkedIn,
          'codeforces': codeforces,
          'codechef': codechef
        },
      );
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser)!.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['name'].toString();
        profilePicUrl = (value.data()!['profilePicUrl']) ?? '';
        currentcompany = (value.data()!['currentCompany']) ?? '';
        role = value.data()!['role'] ?? '';
        linkedIn = value.data()!['linkedIn'] ?? '';
        github = value.data()!['github'] ?? '';
        codeforces = value.data()!['codeforces'] ?? '';
        codechef = value.data()!['codechef'] ?? '';
        graduationYear = value.data()!['graduationYear'] ?? '';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Color.fromARGB(255, 15, 33, 231),
        centerTitle: true,
        title: Text("Edit Profile", style: TextStyle(fontSize: 21)),
      ),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 0.02.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: GestureDetector(
                              child: CachedNetworkImage(
                                height: 12.h,
                                width: 12.h,
                                imageUrl: profilePicUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Center(
                                  child: image != null
                                      ? Image.file(image!)
                                      : Image.asset(
                                          'assets/images/user_default.jpg'),
                                ),
                                placeholder: (context, url) => Center(
                                  child: image != null
                                      ? Image.file(image!)
                                      : Image.asset(
                                          'assets/images/user_default.jpg'),
                                ),
                              ),
                              onTap: () {
                                pickImage();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            initialValue: name,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            // readOnly: true,
                            onSaved: (value) => name = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is Required";
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Graduation Year'),
                            initialValue: graduationYear,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (value) => graduationYear = value,
                            validator: (value) {
                              if (value!.length == 4 && value != null) {
                                graduationYear = value;
                              } else {
                                return "Graduation year is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            initialValue: currentcompany,
                            onSaved: (value) => currentcompany = value,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'Company Name'),
                            validator: (value) {
                              if (value != null) {
                                currentcompany = value;
                              } else {
                                return "Company name is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Role'),
                            initialValue: role,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            validator: (value) {
                              if (value != null) {
                                role = value;
                              } else {
                                return "Role is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            initialValue: linkedIn,
                            onSaved: (value) => linkedIn = value,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'LinkedIn URL link'),
                            validator: (value) {
                              if (value != null) {
                                linkedIn = value;
                              } else {
                                return "LinkedIn URL link is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            initialValue: github,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'GitHub URL link'),
                            validator: (value) {
                              if (value != null) {
                                github = value;
                              } else {
                                return "GitHub URL link is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            initialValue: codeforces,
                            onSaved: (value) => codeforces = value,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'Codeforces URL link'),
                            validator: (value) {
                              if (value != null) {
                                codeforces = value;
                              } else {
                                return "Codeforces URL link is required";
                              }
                            }),
                        SizedBox(height: 6),
                        TextFormField(
                            initialValue: codechef,
                            onSaved: (value) => codechef = value,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'CodeChef URL link'),
                            validator: (value) {
                              if (value != null) {
                                codechef = value;
                              } else {
                                return "CodeChef URL link is required";
                              }
                            }),
                        SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              primary: Color(0Xff15609c),
                              padding: EdgeInsets.all(12),
                              // padding: const EdgeInsets.all(10),
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 38)),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );

                              uploadDetails();
                              // Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            } else {
                              print("Not validated");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

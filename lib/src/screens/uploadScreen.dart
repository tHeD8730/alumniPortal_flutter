import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  State<ImageUploads> createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {

  // @override
  // void initState() async{
  //  {
  //    WidgetsFlutterBinding.ensureInitialized();
  //    await Firebase.initializeApp();
  //   }
  //   super.initState();
  // }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                imgFromCamera();
                Navigator.of(context).pop();
              },
              child: Text('Camera'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                imgFromGallery();
                Navigator.of(context).pop();
              },
              child: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }
}

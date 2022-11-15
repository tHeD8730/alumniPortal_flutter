// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'dart:io';
// import 'package:path/path.dart' as Path;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
//
// class DownloadFile extends StatefulWidget {
//   const DownloadFile({Key? key}) : super(key: key);
//
//   @override
//   State<DownloadFile> createState() => _DownloadFileState();
// }
//
// class _DownloadFileState extends State<DownloadFile> {
//
//
//   // @override
//   // void initState() async{
//   //  {
//   //    WidgetsFlutterBinding.ensureInitialized();
//   //    await Firebase.initializeApp();
//   //   }
//   //   super.initState();
//   // }
//
//   Future<void> downloadFile() async {
//     final firebase_storage.Reference ref = firebase_storage
//         .FirebaseStorage.instance
//         .ref('panduan/Pedoman_pemantauan.pdf');
//     //replace ‘’panduan/Pedoman_pemantauan.pdf’ with the location where your files are stored in your firebase storage
//
//     final Directory appDocDir = await getApplicationDocumentsDirectory();
//     final String appDocPath = appDocDir.path;
//     final File tempFile = File(appDocPath + '/' + 'Pedoman_Pemantauan.pdf');
//     // replace ‘Pedoman_Pemantauan.pdf’ with the file name you want to save when the file is downloaded
//     try {
//       await ref.writeToFile(tempFile);
//       await tempFile.create();
//       await OpenFile.open(tempFile.path);
//     } on FirebaseException catch (e){
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Error, file tidak bisa diunduh',
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//         ),
//       );
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content:Text(
//             'File Berhasil diunduh',
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Theme.of(context).primaryColorLight,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0))),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: Theme.of(context).buttonColor,
//           shadowColor: Theme.of(context).shadowColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//         ),
//         onPressed: () async {
//           await downloadFile();
//         },
//         child:Text(
//           "Unduh Panduan",
//           style: Theme.of(context).textTheme.button!.copyWith(
//             color: Theme.of(context).scaffoldBackgroundColor,
//           ),
//         )
//     );
//   }
// }

//======================

import 'package:alumni_portal/src/screens/resourceScreen/uploadScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alumni_portal/src/download/firebase_api.dart';
import 'package:alumni_portal/src/download/firebase_file.dart';
import 'package:alumni_portal/src/download/image_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../chatScreen/chatListScreen.dart';
import '../feeds/allFeed.dart';

class DownloadFile extends StatefulWidget {
  const DownloadFile({Key? key}) : super(key: key);

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  late Future<List<FirebaseFile>> futureFiles;
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    AllFeed(),
    DownloadFile(),
    HomeChat(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      // print(index);
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll('files/');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // bottomNavigationBar: BottomNavigationBar(
        //   iconSize: 4.h,
        //   selectedIconTheme:
        //       IconThemeData(color: Color.fromARGB(255, 15, 33, 231), size: 40),
        //   showSelectedLabels: false,
        //   showUnselectedLabels: false,
        //   // this will be set when a new tab is tapped
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Feed',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.document_scanner),
        //       label: 'Resources',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        //   currentIndex: _currentIndex,
        //   onTap: _onTapTapped,
        // ),
        appBar: AppBar(
          title: Text('Downloads'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 15, 33, 231),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadFile(),
                      ));
                },
                icon: Icon(Icons.upload_file))
          ],
        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return buildFile(context, file);
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      );

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Color.fromARGB(255, 11, 11, 11),
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePage(file: file),
        )),
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: Color.fromARGB(255, 221, 221, 221),
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Color.fromARGB(255, 12, 12, 12),
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 7, 7, 7),
          ),
        ),
      );
}

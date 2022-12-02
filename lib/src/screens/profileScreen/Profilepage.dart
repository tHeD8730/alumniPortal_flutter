import 'dart:ffi';
import 'package:alumni_portal/src/screens/feeds/uploadFeed.dart';
import 'package:alumni_portal/src/screens/profileScreen/editProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Widget/textWrapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../feeds/allFeed.dart';

class Profilepage extends StatefulWidget {
  Profilepage({Key? key, this.title, required this.userUID}) : super(key: key);
  String? title;
  String? userUID;
  @override
  State<Profilepage> createState() => _ProfileState();
}

class _ProfileState extends State<Profilepage> {
  String? name,
      currentcompany,
      role,
      linkedIn,
      github,
      codeforces,
      codechef,
      graduationYear,
      email;
  String profilePic = "";
  bool dateSelected = false;

  Future<void> _getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUID)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['name'].toString();
        email = value.data()!['email'].toString();
        profilePic = (value.data()!['profilePicUrl']).toString();
        currentcompany = (value.data()!['currentCompany']).toString();
        role = value.data()!['role'].toString();
        linkedIn = value.data()!['linkedIn'].toString();
        github = value.data()!['github'].toString();
        codeforces = value.data()!['codeforces'].toString();
        codechef = value.data()!['codechef'].toString();
        graduationYear = value.data()!['graduationYear'].toString();
      });
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _getPosts() async {
    stream = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUID)
        .collection("myposts")
        .snapshots();
  }

  DateTime selectedDate = DateTime.now();
  late String _hour, _minute, _time;

  DateTime dateTime = DateTime.now();
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color(0Xff19B38D), //Color(0Xff15609c)
            onSurface: Color(0Xff15609c),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);

        _selectTime(context);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color(0Xff19B38D), //Color(0Xff15609c)
            onSurface: Color(0Xff15609c),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [
          hh,
          ':',
          nn,
        ]).toString();
        appointmentReschedule(context, name!, email!);
      });
    //Navigator.of(context).pop();
  }

  Future<dynamic> appointmentReschedule(
      BuildContext context, String name, String email) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Apppointment Request",
              style: TextStyle(fontSize: 16, color: Color(0Xff15609c)),
            ),
            content: Container(
              child: Text(
                'Send apppointment request for ${_timeController.text} on ${_dateController.text}.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style:
                              TextStyle(fontSize: 14, color: Colors.red[700]))),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.userUID)
                            .collection("appointments")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          "timestamp": DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute),
                          "isRequestApproved": false,
                          "RequestFrom-Name": name,
                          "RequestFrom-userUID":
                              FirebaseAuth.instance.currentUser!.uid,
                          "RequestFrom-Email": email,
                        });
                        Fluttertoast.showToast(
                            msg: "Request Sent Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }

  var stream;
  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _getPosts();
  }

  Widget _showDrivers() {
    //check if querysnapshot is null {
    return Container(
      height: 30.h,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    primary: false,
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, i) {
                      final postItem = snapshot.data!.docs[i];
                      return BlogTile(
                        profilePicUrl: postItem["profilePicUrl"],
                        currentCompanyName: postItem["currentCompany"],
                        author: postItem["author"],
                        exp: postItem["Exp"],
                        year: postItem["Year"],
                        Company: postItem["Company"],
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }

  // DateTime dateTime = DateTime.now();

  // Future PickDateTime() async {
  //   DateTime? date = await pickDate();
  //   if (date == null) {
  //     return;
  //   }

  //   TimeOfDay? time = await pickTime();
  //   if (time == null) {
  //     return;
  //   }

  //   final dateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     time.hour,
  //     time.minute,
  //   );
  //   setState(() async {
  //     this.dateTime = dateTime;
  //   });
  //   // print(dateTime);
  // }

  // Future<dynamic> _showDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(dateTime.toString()),
  //           actions: <Widget>[
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: new Text("OK")),
  //           ],
  //         );
  //       });
  // }

  // Widget _buildPopupDialog(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text('Popup example'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: const <Widget>[
  //         Text('Date-Time'),
  //         // Text(dateTime.toString());
  //       ],
  //     ),
  //     actions: <Widget>[
  //       ElevatedButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: const Text(
  //           'Done',
  //           style: TextStyle(
  //             color: Colors.amber,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: dateTime,
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 15, 33, 231)),
          ),
          Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadMyFeed(),
                  ),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Color.fromARGB(255, 15, 33, 231),
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 85.w, top: 7.h),
                  child: Column(
                    children: [
                      FirebaseAuth.instance.currentUser!.uid == widget.userUID
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit))
                          : Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                      // await FirebaseFirestore.instance
                                      //     .collection("users")
                                      //     .doc(FirebaseAuth
                                      //         .instance.currentUser!.uid)
                                      //     .collection("appointments")
                                      //     .doc(widget.userUID)
                                      //     .set({
                                      //   "timestamp": dateTime,
                                      //   "isRequestApproved": false,
                                      //   "RequestFrom-Name": name,
                                      //   "RequestFrom-userUID": FirebaseAuth
                                      //       .instance.currentUser!.uid,
                                      //   "RequestFrom-Email": email,
                                      // });
                                      // await PickDateTime();
                                      // setState(() {
                                      //   if (dateTime != DateTime.now()) {
                                      //     _showDialog(context);
                                      //   }
                                      // }
                                      // );
                                    },
                                    icon: Icon(Icons.access_time_rounded)),
                                Text('Book')
                              ],
                            ),

                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Color.fromARGB(255, 252, 252, 253),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 40.0, vertical: 20.0),
                      //     shape: CircleBorder(),
                      //   ),
                      //   onPressed: () async {
                      //     setState(() {
                      //       if (dateTime != DateTime.now())
                      //         _showDialog(context);
                      //     });
                      //     await PickDateTime();
                      //   },
                      //   child: Text(
                      //     'Book',
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                  child: CachedNetworkImage(
                                    height: 12.h,
                                    width: 12.h,
                                    imageUrl: profilePic!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                    placeholder: (context, url) =>
                                        const Center(child: Icon(Icons.person)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    name ?? 'Loading',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _launchUrl(linkedIn!);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/linkedin_icon1.svg",
                                          height: 3.h,
                                          width: 3.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchUrl(github!);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/github_icon1.svg",
                                          height: 3.h,
                                          width: 3.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchUrl(codeforces!);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/codechef.icon.svg",
                                          height: 3.h,
                                          width: 3.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchUrl(codeforces!);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/codeforces_icon.svg",
                                          height: 3.h,
                                          width: 3.h,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 3.h, bottom: 3.h),

                          margin: EdgeInsets.only(
                              bottom: 5, right: 5, left: 5, top: 5),
                          // decoration: BoxDecoration(
                          //  color: Colors.white,
                          // borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              headerChild('Current Company',
                                  currentcompany ?? "Loading"),
                              headerChild('Role', role ?? "Loading"),
                              headerChild('Graduation Year',
                                  graduationYear ?? "Loading")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35.h),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 37.h),
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(children: [
                        Text(
                          "User Posts",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        _showDrivers(),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerChild(String header, String value) => Expanded(
          child: Column(
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            header,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 12.sp,
            ),
          ),
        ],
      ));
}

class BlogTile extends StatelessWidget {
  final String? year, Company, exp, author, currentCompanyName;
  String profilePicUrl;

  BlogTile(
      {@required this.year,
      @required this.Company,
      @required this.exp,
      @required this.author,
      @required this.currentCompanyName,
      required this.profilePicUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      //color: Colors.grey[300],
      margin: EdgeInsets.only(bottom: 5, right: 5, left: 5, top: 5),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  child: CachedNetworkImage(
                    height: 5.h,
                    width: 5.h,
                    imageUrl: profilePicUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/user_default.jpg'),
                    placeholder: (context, url) =>
                        const Center(child: Icon(Icons.person)),
                  ),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(author!,
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500)),
                  Text(currentCompanyName!)
                ],
              )
            ],
          ),
          Divider(
            height: 2.h,
          ),
          SizedBox(height: 16),
          Text(
            Company!,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 4),
          Text(
            '$year',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          exp!.length > 20
              ? TextWrapper(text: '$exp')
              : Text(
                  '$exp',
                  style: TextStyle(fontSize: 14),
                ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}

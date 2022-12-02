import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class ConfirmedAppointments extends StatefulWidget {
  const ConfirmedAppointments({Key? key}) : super(key: key);

  @override
  _ConfirmedAppointmentsState createState() => _ConfirmedAppointmentsState();
}

class _ConfirmedAppointmentsState extends State<ConfirmedAppointments> {
  String? officenumber, phonenumber, facultyName, facultyEmail, name;

  //////
  var stream;
  String? getcurrentusername, getcurrentname, getcurrentemail;

  void initState() {
    ///
    super.initState();
    // getfacultyDetails;
    stream = FirebaseFirestore.instance
        .collection("users")
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .collection("appointments")
        .where("isRequestApproved", isEqualTo: true)
        .where("RequestFrom-userUID",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        // .orderBy("guestappointdatetime", descending: false)
        // .orderBy("guestappointtime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Pending Appointments"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 15, 33, 231)),
        body: StreamBuilder(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                int value;
                value = snapshot.data!.docs.length;
                if (value == 0) {
                  print("issssss$value");
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 150),
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: 266.h),
                            Icon(
                              Icons.notification_important,
                              color: Color(0Xff14619C),
                              size: 200,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text("No Appointment!",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0Xff14619C),
                                )),
                          ],
                        ),
                      ));
                }
                return ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final chatItem = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Card(
                        elevation: 2,
                        child: SizedBox(
                          height: 135,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ListTile(
                                title: Text(
                                  "${chatItem["RequestFrom-Name"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                //Phone number and Time
                                subtitle: Container(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_alarm,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          chatItem["timestamp"] == null
                                              ? "NA | NA"
                                              : "${DateFormat('HH:mm').format(chatItem["timestamp"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["timestamp"].toDate())}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            backgroundColor: Color(0XffD1F0E8),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                //Id Image
                                //Room Number
                                trailing: SizedBox(
                                  width: 85,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //SizedBox(height: cardheight * 0.07),
                                      // SizedBox(height: 13),
                                      // Text(
                                      //   chatItem["isStudent"]
                                      //       ? "Student"
                                      //       : "Guest",
                                      //   style: TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.w600),
                                      // ),
                                      // SizedBox(height: cardheight * 0.07),
                                      SizedBox(height: 3),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Description",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0Xff15609c)),
                                                  ),
                                                  // content: Container(
                                                  //   child: Text(
                                                  //     '${chatItem["guestpurpose"]}',
                                                  //     //softWrap: true,
                                                  //     style: TextStyle(
                                                  //       color: Colors.black,
                                                  //       fontSize: 13.sp,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .arrowtriangle_down_circle_fill,
                                              size: 12,
                                              color: Color(0Xff14619C),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              "Description",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0Xff15609c)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}

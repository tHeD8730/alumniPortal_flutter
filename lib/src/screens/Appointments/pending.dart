import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({Key? key}) : super(key: key);

  @override
  _AppointmentRequestState createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  String? officenumber, phonenumber, facultyName, facultyEmail, name;
  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  reschedulesendMail(
    String guestemail,
    String date,
    String phonenumber,
    String officenumber,
    String facultyName,
    String facultyEmail,
  ) async {
    final Email email = Email(
      body:
          '<p>Greetings for the day!</p> <p>It is to inform you that your appointment has rescheduled to <b>$date</b> in Room no.: $officenumber.<br>Apologies  for the inconvenience caused. Please be present accordingly! <br>Thank You.</p><p>Regards,<br>$facultyName <br>Phone No.: +91$phonenumber <br>Email: $facultyEmail</p>',
      subject: 'Appointment Rescheduled!',
      recipients: [guestemail],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  Future<Null> _selectDate(
      BuildContext context, String name, String email) async {
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

        _selectTime(context, name, email);
      });
  }

  Future<Null> _selectTime(
      BuildContext context, String name, String email) async {
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
        appointmentReschedule(context, name, email);
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
              "Reschedule",
              style: TextStyle(fontSize: 16, color: Color(0Xff15609c)),
            ),
            content: Container(
              child: Text(
                'Reschedule Appointment with $name at ${_timeController.text} on ${_dateController.text}.',
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
                        FirebaseFirestore.instance
                            .collection('facultyUser')
                            .doc((FirebaseAuth.instance.currentUser!).email)
                            .collection("guestemail")
                            .doc(email)
                            .update({
                          'guestappointdatetime': DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute),
                          'appointisapproved': true,
                        });
                        FirebaseFirestore.instance
                            .collection('facultyUser')
                            .doc((FirebaseAuth.instance.currentUser)!.email)
                            .get()
                            .then((value) {
                          setState(() {
                            officenumber = value.data()!['officeno'].toString();
                            phonenumber = value.data()!['phone'].toString();
                            facultyName = value.data()!['name'].toString();
                            facultyEmail = value.data()!['email'].toString();
                          });
                          reschedulesendMail(
                            email,
                            "${DateFormat('HH:mm').format(
                              DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute),
                            )} | ${DateFormat('dd-MM-yyyy').format(
                              DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute),
                            )}",
                            phonenumber!,
                            officenumber!,
                            facultyName!,
                            facultyEmail!,
                          ).whenComplete(() {
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Guest Notified')));
                          });
                          // flutterToast("Rescheduled Successfully");
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style:
                              TextStyle(fontSize: 14, color: Colors.red[700]))),
                ],
              )
            ],
          );
        });
  }

  //////
  var stream;
  String? getcurrentusername, getcurrentname, getcurrentemail;

  void initState() {
    ////
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [
      hh,
      ':',
      nn,
    ]).toString();

    ///
    super.initState();
    // getfacultyDetails;
    stream = FirebaseFirestore.instance
        .collection("users")
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .collection("appointments")
        .where("isRequestApproved", isEqualTo: false)
        // .orderBy("guestappointdatetime", descending: false)
        // .orderBy("guestappointtime", descending: true)
        .snapshots();
  }

  approvesendMail(
    String date,
    String? getcurrentusername,
    String? getcurrentname,
    String? getcurrentemail,
  ) async {
    final Email email = Email(
      body:
          '<p>Greetings for the day!</p> <p>It is to inform you that your appointment has scheduled on <b>$date</b> you can find me in the chat section of th portal, using username: $getcurrentusername . <br>Thank You.</p><p>Regards,<br>$getcurrentname</p>',
      subject: 'Appointment Booked!',
      recipients: [getcurrentemail!],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  declinesendMail(String guestemail, String? phonenumber, String? facultyName,
      String? facultyEmail) async {
    final Email email = Email(
      body:
          '<p>Greetings for the day!</p> <p>It is to inform you that your appointment cannot be scheduled at the moment due to unavoidable circumstances. Please accept sincere apologies for the inconvenience caused and try again later!. <br>Thank You.</p><p>Regards,<br>$facultyName <br>Phone No.: +91$phonenumber <br>Email: $facultyEmail</p>',
      subject: 'Request Declined!',
      recipients: [guestemail],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
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
                            Text("No Requests",
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
                              // SizedBox(
                              //   height: cardheight * 0.05,
                              // ),
                              //Accept, Decline button
                              Column(
                                children: [
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 38,
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(await (FirebaseAuth
                                                        .instance.currentUser)!
                                                    .uid)
                                                .collection("appointments")
                                                .doc(chatItem[
                                                    "RequestFrom-userUID"])
                                                .set({
                                              "isRequestApproved": true,
                                            });
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc((FirebaseAuth
                                                        .instance.currentUser)!
                                                    .uid)
                                                .get()
                                                .then((value) {
                                              setState(() {
                                                getcurrentname = value
                                                    .data()!['name']
                                                    .toString();
                                                getcurrentusername = value
                                                    .data()!['username']
                                                    .toString();
                                                getcurrentemail = value
                                                    .data()!['email']
                                                    .toString();
                                                approvesendMail(
                                                        getcurrentname!,
                                                        "${DateFormat('HH:mm').format(chatItem["timestamp"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["timestamp"].toDate())}",
                                                        getcurrentusername,
                                                        getcurrentemail)
                                                    .whenComplete(() {
                                                  setState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Email sent!')),
                                                  );
                                                });
                                              });
                                            });

                                            // await FirebaseFirestore.instance
                                            //     .collection("facultyUser")
                                            //     .doc((FirebaseAuth
                                            //             .instance.currentUser!)
                                            //         .email)
                                            //     .collection("guestemail")
                                            //     .doc(chatItem["guestemail"])
                                            //     .update({
                                            //   "appointisapproved": true
                                            // }).then((_) {
                                            //   print("success!");
                                            // });
                                          },
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Color(0Xff19B38D)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 38,
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    elevation: 3,
                                                    title: Column(
                                                      children: [
                                                        Text(
                                                          "Are you sure you want to decline?",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Email",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                      0Xff15609c)),
                                                            ))
                                                      ],
                                                    ),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: Colors.white70,
                                                        border: Border.all(
                                                          width: 0.1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${chatItem["RequestFrom-Email"]}',
                                                        //softWrap: true,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 38,
                                                                width: 120,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _selectDate(
                                                                        context,
                                                                        chatItem["RequestFrom-Name"]
                                                                            .toString(),
                                                                        chatItem[
                                                                            "RequestFrom-Email"]);
                                                                  },
                                                                  child: Text(
                                                                    "Reschedule",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Color(
                                                                            0Xff19B38D)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Container(
                                                                height: 38,
                                                                width: 120,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    // FirebaseFirestore
                                                                    //     .instance
                                                                    //     .collection(
                                                                    //         'facultyUser')
                                                                    //     .doc(await (FirebaseAuth.instance.currentUser)!
                                                                    //         .email)
                                                                    //     .get()
                                                                    //     .then(
                                                                    //         (value) {
                                                                    //   setState(
                                                                    //       () {
                                                                    //     phonenumber = value
                                                                    //         .data()!['phone']
                                                                    //         .toString();
                                                                    //     facultyName = value
                                                                    //         .data()!['name']
                                                                    //         .toString();
                                                                    //     facultyEmail = value
                                                                    //         .data()!['email']
                                                                    //         .toString();

                                                                    //     print(
                                                                    //         "myyyyyyyyyyyyy${name}");
                                                                    //     declinesendMail(
                                                                    //             chatItem["guestemail"],
                                                                    //             phonenumber,
                                                                    //             facultyName,
                                                                    //             facultyEmail)
                                                                    //         .whenComplete(() {
                                                                    //       setState(
                                                                    //           () {});
                                                                    //       ScaffoldMessenger.of(context)
                                                                    //           .showSnackBar(
                                                                    //         const SnackBar(content: Text('Guest Notified')),
                                                                    //       );
                                                                    //     });
                                                                    //   });
                                                                    // });

                                                                    // FirebaseFirestore
                                                                    //     .instance
                                                                    //     .collection(
                                                                    //         "facultyUser")
                                                                    //     .doc((FirebaseAuth.instance.currentUser!)
                                                                    //         .email)
                                                                    //     .collection(
                                                                    //         "guestemail")
                                                                    //     .doc(chatItem[
                                                                    //         "guestemail"])
                                                                    //     .delete()
                                                                    //     .then(
                                                                    //         (_) {
                                                                    //   print(
                                                                    //       "Deleted succesfully!");
                                                                    // });
                                                                  },
                                                                  child: Text(
                                                                    "Decline",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .red[
                                                                          700],
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                          SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            "Decline",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red[700],
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
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

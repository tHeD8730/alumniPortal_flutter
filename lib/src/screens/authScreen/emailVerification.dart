import 'dart:async';
import 'package:alumni_portal/src/screens/homePage.dart';

import 'package:alumni_portal/src/screens/profileScreen/editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmailVerification extends StatefulWidget {
  // const EmailVerification({super.key});
  EmailVerification({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _isVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (_isVerified == false) {
      _sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
    super.initState();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isVerified) {
      timer?.cancel();
      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditProfile()),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _sendVerificationEmail() async {
    try {
      // print("here");
      final User = FirebaseAuth.instance.currentUser!;
      await User.sendEmailVerification()
          .catchError(
              (onError) => print('Error sending email verification $onError'))
          .then((value) => print('Successfully sent email verification'));
      ;
    } catch (e) {
      _showMyDialog(context, e.toString());
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 5.h,
              ),
            ),
            // Text('Back',
            //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _isVerified
      ? Home()
      : Scaffold(
          //  backgroundColor: Colors.transparent,
          body: Column(children: [
            Positioned(
              top: 40,
              left: 0,
              child: _backButton(),
            ),
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              "assets/images/verification.png",
              height: 30.h,
              width: 30.w,
            ),
            // SizedBox(
            //   height: 15.h,
            // ),
            Text(
              'Verification code sent on your device!',
              style: TextStyle(
                fontSize: 4.h,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.h,
            ),
            CircularProgressIndicator(),
          ]),
        );
}

Future<void> _showMyDialog(BuildContext context, String err) async {
  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, //this means the user must tap a button to exit the Alert Dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(err),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

import 'package:alumni_portal/src/helper/sharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  void _sendEmail() async{
    await FirebaseAuth.instance.sendPasswordResetEmail(
        email: SharedPreferenceHelper().getUserEmail().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 98.w,
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
                child: TextFormField(
                  // onSaved: (newValue) {
                  //   _Password = newValue!;
                  // },
                  validator: (value) {
                    if (value!.isEmpty || !value!.contains('@')) {
                      return 'Please Enter valid Email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  // obscureText: true,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              height: 50,
              width: 50.w,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _sendEmail,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

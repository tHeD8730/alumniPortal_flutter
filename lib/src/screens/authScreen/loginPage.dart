import 'package:alumni_portal/src/screens/authScreen/signupPage.dart';
import 'package:alumni_portal/src/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_login_signup/src/signup.dart';
// import '../../Widget/bezierContainer.dart';
import 'package:alumni_portal/src/screens/authScreen/forgetPasswordScreen.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final _auth = FirebaseAuth.instance;
  late UserCredential _credential;
  String _Password = '';
  String _emailAddress = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    try {
      if (isValid) {
        _formKey.currentState!.save();

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailAddress.trim(), password: _Password.trim());
        } catch (e) {
          print(e.toString()); 
        }

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    }
    // } on PlatformException catch (err) {
    //   String msg = "An Error occured!";
    //   if (err.message != null) {
    //     msg = err.message!;
    //   }
    //   print(msg);
    catch (err) {
      print(err);
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

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
        child: Container(
      height: 50,
      width: 50.w,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
          child: Text(
            'Log In',
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              'Register',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 81, 230),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Log In',
      style: TextStyle(
        fontSize: 5.h,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
              child: TextFormField(
                onSaved: (newValue) {
                  _emailAddress = newValue!;
                },
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
              child: TextFormField(
                onSaved: (newValue) {
                  _Password = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'Password must be 7 characters long';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
                obscureText: true,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else if (snapshot.hasError) {
            //   return Center(
            //     child: Text('Something Went wrong!'),
            //   );
            // } else 
            if (snapshot.hasData) {
              return Home();
            } else {
              return Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    // Positioned(
                    //   top: -height * .15,
                    //   right: -MediaQuery.of(context).size.width * .4,
                    //   child: BezierContainer(),
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 20.h,
                            ),
                            _title(),
                            SizedBox(height: 10.h),
                            _emailPasswordWidget(),
                            SizedBox(height: 4.h),
                            _submitButton(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                                },
                                child: TextButton(
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ForgetPassword()),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * .055),
                            _createAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 0,
                      child: _backButton(),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

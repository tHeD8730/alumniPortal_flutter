import 'package:alumni_portal/src/screens/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_login_signup/src/signup.dart';
import '../Widget/bezierContainer.dart';
import 'package:alumni_portal/src/screens/forgetPasswordScreen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late UserCredential _credential;
  String _Password = '' ; 
  String _emailAddress = '' ; 

void _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    try {
      if (isValid) {
        _formKey.currentState!.save();

        _credential = await _auth.signInWithEmailAndPassword(
            email: _emailAddress.trim(), password: _Password.trim());
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
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.symmetric(vertical: 15),
      // alignment: Alignment.center,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(5)),
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.grey.shade200,
      //           offset: Offset(2, 4),
      //           blurRadius: 5,
      //           spreadRadius: 2)
      //     ],
      //     gradient: LinearGradient(
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //         colors: [Color.fromARGB(255, 12, 167, 238), Color.fromARGB(255, 1, 81, 230)])),
      child: ElevatedButton(
      child: Text(
        'Log In',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: _submit,
    )
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 81, 230),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return  RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Alumni',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 1, 81, 230),
          ),
          children: [
            const TextSpan(
              text: 'Portal',
              style: TextStyle(color: Color.fromARGB(255, 1, 81, 230), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
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

          TextFormField(
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                      },
                      child: Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  _divider(),
                  _facebookButton(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}

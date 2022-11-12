import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widget/bezierContainer.dart';
import 'package:alumni_portal/src/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;
  
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late UserCredential _credential;
  String _fullName = '';
  String _Password = '';
  String _emailAddress = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    try {
      if (isValid) {
        _formKey.currentState!.save();

        _credential = await _auth.createUserWithEmailAndPassword(
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
            height: 1.h,
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
        //         colors: [
        //           Color.fromARGB(255, 12, 167, 238),
        //           Color.fromARGB(255, 1, 81, 230)
        //         ])),
        child: ElevatedButton(
      child: Text(
        'Register Now',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: _submit,
    ));

    //Text(
    // 'Register Now',
    // style: TextStyle(fontSize: 20, color: Colors.white),
    // ),
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
    return RichText(
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
              style: TextStyle(
                color: Color.fromARGB(255, 1, 81, 230),
                fontSize: 30,
              ),
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
              _fullName = newValue!;
            },
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Full Name'),
            ),
          ),

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
          // _entryField("Full Name"),
          // _entryField("Email id"),
          // _entryField("Password", isPassword: true),
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
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
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
                    SizedBox(
                      height: 6.h,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 5.h,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 27.h,
                    ),
                    _loginAccountLabel(),
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
      ),
    );
  }
}

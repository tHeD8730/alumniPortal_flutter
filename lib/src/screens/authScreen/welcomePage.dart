// ignore: file_names
import 'package:alumni_portal/src/screens/authScreen/emailVerification.dart';
import 'package:alumni_portal/src/screens/authScreen/loginPage.dart';
import 'package:alumni_portal/src/screens/authScreen/signupPage.dart';
import 'package:alumni_portal/src/screens/homePage.dart';
import 'package:alumni_portal/src/screens/resourceScreen/downloadScreen.dart';
import 'package:alumni_portal/src/screens/resourceScreen/uploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color.fromARGB(255, 38, 4, 191).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 1, 81, 230),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
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
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Quick login with Touch ID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          GestureDetector(
            child: Icon(
              Icons.fingerprint,
              size: 90,
              color: Colors.white,
            ),
            onTap: () async {
              
            },
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Touch ID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
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
          fontSize: 6.h,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        children: [
         TextSpan(
            text: 'Portal',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 81, 230),
              fontSize: 6.h,
               fontWeight: FontWeight.w500, 
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/college_image.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.all(Radius.circular(5)),
            //   boxShadow: <BoxShadow>[
            //     BoxShadow(
            //         color: Colors.grey.shade200,
            //         offset: Offset(2, 4),
            //         blurRadius: 5,
            //         spreadRadius: 2)
            //   ],
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       Color.fromARGB(255, 12, 167, 238),
            //       Color.fromARGB(255, 1, 81, 230),
            //     ],
            //   ),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15.h,
                ),
                Image.asset(
                  "assets/images/logo_iiitl.png",
                  height: 12.h,
                  width: 20.w,
                ),
                _title(),
                SizedBox(
                  height: 40.h,
                ),
                // Text(
                //   'Discover it,',
                //   style: TextStyle(
                //     fontSize:6.h,
                //     fontWeight: FontWeight.w400,
                //     color: Color.fromARGB(233, 242, 233, 233), 
                //   ),
                // ),
                // Text('Share it.'),
                // SizedBox(
                //   height: 20.h,
                // ),
                _submitButton(),
                SizedBox(
                  height: 3.h,
                ),
                _signUpButton(),
                SizedBox(
                  height: 3.h,
                ),
                // _label(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:alumni_portal/src/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:alumni_portal/src/screens/welcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alumni_portal/src/screens/uploadScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AlumniPortal());
}

class AlumniPortal extends StatefulWidget {
  const AlumniPortal({Key? key}) : super(key: key);

  @override
  State<AlumniPortal> createState() => _AlumniPortalState();
}

class _AlumniPortalState extends State<AlumniPortal> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (
        context,
        orientation,
        deviceType,
      ) {
        return GetMaterialApp(
          home: const ImageUploads(),
          routes: {
            'splash': (BuildContext context) => const SplashScreen(),
            'welcome': (BuildContext context) => WelcomePage(),
          },
        );
      },
    );
  }
}

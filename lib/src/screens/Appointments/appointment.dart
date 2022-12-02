import 'package:alumni_portal/src/screens/Appointments/confirmed.dart';
import 'package:alumni_portal/src/screens/Appointments/pending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Appointments"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 15, 33, 231)),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: (() {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppointmentRequest()),
                  );
                }),
                child: Column(
                  children: [
                    Container(
                        height: 30.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 232, 232),
                        ),
                        child: Icon(Icons.pending_actions, size: 20.h)),
                    // Container(
                    //   child: Image.asset("assets/images/college_image.png"),
                    // ),
                    Text(
                      'Pending Appointmets',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: GestureDetector(
                  onTap: (() {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfirmedAppointments()),
                    );
                  }),
                  child: Column(
                    children: [
                      Container(
                          height: 30.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 232, 232),
                          ),
                          child: Icon(Icons.approval, size: 20.h)),
                      // Container(
                      //   child: Image.asset("assets/images/college_image.png"),
                      // ),
                      Text(
                        'Confirmed Appointmets',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

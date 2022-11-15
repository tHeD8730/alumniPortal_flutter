import 'package:alumni_portal/src/helper/sharedPref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  String? name = "Loading", profileURL="";

  Future<void> getdeatils() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!["name"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getdeatils();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 70.w,
        child: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            // ignore: avoid_redundant_argument_values
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 6.h,
              ),
             Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 15, 33, 231),
                        ),
                        child: CachedNetworkImage(
                          height: 12.h,
                          width: 12.h,
                          imageUrl: profileURL!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person),
                          placeholder: (context, url) =>
                              const Center(child: Icon(Icons.person)),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                height: 3.h,
              ),
              Text(name! , 
                  style: TextStyle(
                    fontSize: 12.sp ,
                    fontWeight: FontWeight.w600
                  ),),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 8.w),
                minLeadingWidth: 5.w,
                leading: Container(
                  padding: EdgeInsets.only(top: .5.h),
                  child: Icon(Icons.person),
                  // height: 2.5.h,),
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.black87, fontSize: 12.sp),
                ),
                onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>const ProfileEditScreen()),
                  // );
                },
              ),
              Divider(
                height: 2.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 8.w),
                minLeadingWidth: 5.w,
                leading: Container(
                  padding: EdgeInsets.only(top: .5.h),
                  child: Icon(Icons.book_online),
                  // height: 2.5.h,),
                ),
                title: Text(
                  'Appointments',
                  style: TextStyle(color: Colors.black87, fontSize: 12.sp),
                ),
                onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>const AccountList()),
                  // );
                },
              ),
              Divider(
                height: 2.h,
              ),
              ListTile(
                  contentPadding: EdgeInsets.only(left: 8.w),
                  minLeadingWidth: 5.w,
                  leading: Container(
                    padding: EdgeInsets.only(top: .5.h),
                    child: Icon(Icons.web),
                    // height: 2.5.h,),
                  ),
                  title: Text(
                    'Website',
                    style: TextStyle(color: Colors.black87, fontSize: 12.sp),
                  )
                  // ontap function required here
                  ),
              Divider(
                height: 2.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 8.w),
                minLeadingWidth: 5.w,
                leading: Container(
                  padding: EdgeInsets.only(top: .5.h),
                  child: Icon(Icons.info),
                  // height: 2.5.h,),
                ),
                title: Text(
                  'About Us',
                  style: TextStyle(color: Colors.black87, fontSize: 12.sp),
                ),
                onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>const LegalScreenAccount()),
                  // );
                },
              ),
              Divider(
                height: 1.h,
              ),
              SizedBox(
                height: 15.h,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(30.h, 5.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  // ignore: avoid_redundant_argument_values
                  side: const BorderSide(width: 1, color: Color.fromARGB(255, 15, 33, 231)),
                  backgroundColor: Colors.white,
                ),
                icon: Icon(
                  Icons.logout,
                  color: Colors.grey,
                ),
                // height: 2.h,),
                //   onPressed: () async {
                //   SharedPreferences myPrefs = await SharedPreferences.getInstance();
                //   await myPrefs.setBool('login', false);
                //   debugPrintMethod(myPrefs.getBool('login'));
                //   // ignore: prefer_const_constructors, unawaited_futures
                //   Get.offAll(LoginPage());
                // },
                label: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.black87, fontSize: 10.sp),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
              SizedBox(
                height: 5.h,
              ),
              //  Image.asset(
              //   'assets/launcher_2/Logo_New.png',
              //   height: 30,
              //   fit: BoxFit.contain,
              // ),
            ],
          ),
        ));
  }
}

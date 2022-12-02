import 'package:alumni_portal/src/screens/chatScreen/chatListScreen.dart';
import 'package:alumni_portal/src/screens/feeds/allFeed.dart';
import 'package:alumni_portal/src/screens/profileScreen/Profilepage.dart';
import 'package:alumni_portal/src/screens/resourceScreen/downloadScreen.dart';
import 'package:alumni_portal/src/side_nav/sideNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHome = true;
  int _currentIndex = 0;
  final List<Widget> _pages = <Widget>[
    AllFeed(),
    DownloadFile(),
    Profilepage(
      userUID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex != 0)
        isHome = false;
      else
        isHome = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isHome ? const SideNav() : null,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 4.h,
        selectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 15, 33, 231), size: 40),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // this will be set when a new tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      appBar: isHome
          ? AppBar(
              backgroundColor: Color.fromARGB(255, 15, 33, 231),
              title: Text(
                'AlumniPortal',
                style: TextStyle(color: Colors.deepPurple[50]),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeChat(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.chat,
                      color: Colors.deepPurple[50],
                    )),
              ],
            )
          : null,
      body: _pages.elementAt(_currentIndex),
      // Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/images/pur7.png"), // <-- BACKGROUND IMAGE
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // child: Center(
      // child:
      //  _pages.elementAt(_currentIndex),
      // ),
      // ),
    );
  }
}

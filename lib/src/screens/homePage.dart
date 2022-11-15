import 'package:alumni_portal/src/screens/chatScreen/chatListScreen.dart';
import 'package:alumni_portal/src/screens/feeds/allFeed.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = <Widget>[
    AllFeed(),
    HomeChat(),
    HomeChat(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedIconTheme: IconThemeData(color: Colors.indigo[900], size: 40),
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
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          'WithU',
          style: TextStyle(color: Colors.deepPurple[50]),
        ),
        actions: [
          InkWell(
            onTap: () {
              // AuthServies().logout().then((s) {
              //   Navigator.pushReplacement(
              //       context, MaterialPageRoute(builder: (context) => SignIn()));
              // });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.deepPurple[50],
                )),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pur7.png"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _pages.elementAt(_currentIndex),
        ),
      ),
    );
  }
}

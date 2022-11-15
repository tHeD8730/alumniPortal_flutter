import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String? name, profileUrl, currentcompany, role, linkedIn, github, codeforced, codechef;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
              const Color(0xFF26CBE6),
              const Color(0xFF26CBC0),
            ], begin: Alignment.topCenter, end: Alignment.center)),
          ),
          new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
              child: new Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.center,
                    child: new Padding(
                      padding: new EdgeInsets.only(top: _height / 15),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundImage:
                                new AssetImage('assets/profile_img.jpeg'),
                            radius: _height / 10,
                          ),
                          new SizedBox(
                            height: _height / 30,
                          ),
                          new Text(
                            'Sadiq Mehdi',
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: _height / 2.2),
                    child: new Container(
                      color: Colors.white,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: _height / 2.6,
                        left: _width / 20,
                        right: _width / 20),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.h,
                        ),
                        new Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 2.0))
                              ]),
                          child: new Padding(
                            padding: new EdgeInsets.all(_width / 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                headerChild('Current Company', 'XYZ'),
                                headerChild('Role', 'xyz'),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 10.h,
                                    width: 20.w,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/linkedin.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 10.h,
                                    width: 20.w,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/github.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 10.h,
                                    width: 20.w,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/codeforces.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 10.h,
                                    width: 20.w,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/codechef.webp'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // new Padding(
                            //   padding: new EdgeInsets.only(top: _height / 30),
                            //   child: new Container(
                            //     width: _width / 3,
                            //     height: _height / 20,
                            //     decoration: new BoxDecoration(
                            //         color: const Color(0xFF26CBE6),
                            //         borderRadius: new BorderRadius.all(
                            //             new Radius.circular(_height / 40)),
                            //         boxShadow: [
                            //           new BoxShadow(
                            //               color: Colors.black87,
                            //               blurRadius: 2.0,
                            //               offset: new Offset(0.0, 1.0))
                            //         ]),
                            //     child: new Center(
                            //       child: new Text('Done',
                            //           style: new TextStyle(
                            //               fontSize: 16.0,
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold)),
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerChild(String header, String value) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            '$value',
            style: new TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF26CBE6),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, ImageIcon icon, data) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              icon,
              new SizedBox(
                width: width / 20,
              ),
              new Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );

// yeh post k liye widget h jitna muje smj aata aata tha bna dia,
//parameters change kr dena accordingly....
  Widget postTile(String userName, String post) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                    height: 20,
                    width: 20,
                    child: Image(
                      image: AssetImage('assets/images/linkedln.png'),
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              child: Text(post),
            )
          ],
        ),
      );
}

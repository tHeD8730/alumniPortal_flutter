import 'package:alumni_portal/src/Widget/textWrapper.dart';
import 'package:alumni_portal/src/screens/chatScreen/chatListScreen.dart';
import 'package:alumni_portal/src/screens/feeds/uploadFeed.dart';
import 'package:alumni_portal/src/screens/profileScreen/Profilepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AllFeed extends StatefulWidget {
  @override
  _AllFeedState createState() => _AllFeedState();
}

class _AllFeedState extends State<AllFeed> {
  bool isExpanded = false;
  // Future<void> _getPosts() async {
  //   stream = FirebaseFirestore.instance.collection("feeds").snapshots();
  // }

  // var stream;

  @override
  void initState() {
    super.initState();
    // _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("feeds").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.all(12),
                      itemBuilder: (context, i) {
                        final postItem = snapshot.data!.docs[i];
                        return BlogTile(
                            profilePicUrl: postItem["profilePic"],
                            currentCompanyName: postItem["currentCompany"],
                            author: postItem["author"],
                            exp: postItem["Exp"],
                            year: postItem["Year"],
                            Company: postItem["Company"],
                            userUID: postItem["userUID"]);
                      },
                    )
                  : const CircularProgressIndicator();
            }));
  }
}

class BlogTile extends StatelessWidget {
  final String? year,
      Company,
      exp,
      author,
      currentCompanyName,
      userUID,
      profilePicUrl;

  BlogTile(
      {@required this.userUID,
      @required this.year,
      @required this.Company,
      @required this.exp,
      @required this.author,
      @required this.currentCompanyName,
      required this.profilePicUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profilepage(
                    userUID: userUID,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        //color: Colors.grey[300],
        margin: EdgeInsets.only(bottom: 5, right: 5, left: 5, top: 5),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    child: CachedNetworkImage(
                      height: 5,
                      width: 5,
                      imageUrl: profilePicUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/user_default.jpg'),
                      placeholder: (context, url) => Center(
                          child: Image.asset('assets/images/user_default.jpg')),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author!,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                    Text(currentCompanyName!)
                  ],
                )
              ],
            ),
            Divider(
              height: 2.h,
            ),
            SizedBox(height: 16),
            Text(
              Company!,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 4),
            Text(
              '$year',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            exp!.length > 20
                ? TextWrapper(text: '$exp')
                : Text(
                    '$exp',
                    style: TextStyle(fontSize: 14),
                  ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

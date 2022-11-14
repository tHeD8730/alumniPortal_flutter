import 'package:flutter/material.dart';

class chatList extends StatefulWidget {
  chatList({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _chatListState createState() => _chatListState();
}

class _chatListState extends State<chatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),

      body:  Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: ListView(
                      // key: RIKeys.riKey1,
                      scrollDirection: Axis.vertical,
                      children: [
                        chatItems(
                            "Quiche Hollandaise",
                            "this is some text message which is sent by the user mentioned",
                            1,
                            "15 min",
                            true),
                        // chatItems(
                        //     "Jake Weary",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "32 min",
                        //     false),
                        // chatItems("Ingredia Nutrisha", "this is ", 10, "49 min",
                        //     true),
                        // chatItems(
                        //     "Piff Jenkins",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "5 hour",
                        //     true),
                        // chatItems(
                        //     "Nathaneal Down",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "Mon",
                        //     false),
                        // chatItems(
                        //     "Valentino Morose",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "Tue",
                        //     true),
                        // chatItems(
                        //     "Quiche Hollandaise",
                        //     "this is some text message which is sent by the user mentioned",
                        //     1,
                        //     "15 min",
                        //     true),
                        // chatItems(
                        //     "Jake Weary",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "32 min",
                        //     false),
                        // chatItems(
                        //     "Ingredia Nutrisha",
                        //     "this is some text message which is sent by the user mentioned",
                        //     10,
                        //     "15 min",
                        //     true),
                        // chatItems(
                        //     "Piff Jenkins",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "5 hour",
                        //     true),
                        // chatItems(
                        //     "Nathaneal Down",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "Mon",
                        //     false),
                        // chatItems(
                        //     "Valentino Morose",
                        //     "this is some text message which is sent by the user mentioned",
                        //     0,
                        //     "Tue",
                        //     true),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget chatItems(name, message, unreadMessageCount, unreadMessageTime, online) {
  return Container(
    height: 80,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
            online
                ? Positioned(
                    right: 2,
                    bottom: 4,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              color: Colors.white,
                              spreadRadius: 2)
                        ],
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              message.length > 60 ? SizedBox(height: 4) : SizedBox(height: 10),
              Container(
                width: 200,
                child: Text(
                  message,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 55,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 12),
                child: Text(
                  unreadMessageTime,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              unreadMessageCount > 0
                  ? Container(
                      height: 32,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [
                              // Colors.green[200],
                              // Colors.green[600],
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: Center(
                        child: Text(
                          unreadMessageCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    ),
  );
}

}

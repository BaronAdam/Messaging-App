import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/ChatScreen/detail_screen.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.isPhoto, this.url});

  final String sender;
  final String text;
  final bool isMe;
  final bool isPhoto;
  final String url;

  @override
  Widget build(BuildContext context) {
    String message = text == null ? '' : text;

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe ? 'You' : sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? kAppColor : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: !isPhoto
                  ? Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    )
                  : GestureDetector(
                      child: Image.network(
                        url,
                        width: 250,
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(url);
                        }));
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

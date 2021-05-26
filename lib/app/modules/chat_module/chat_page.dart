import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/widgets/widget_appbar.dart';

class ChatPage extends GetView<ChatController>{
  final String name;
  final String avatar;

  ChatPage({required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 2)
              ),
              child: ClipOval(
                child: Image.network(avatar),
              ),
            ),
            SizedBox(width: 5,),
            Text(
              name,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Today',
                                style:
                                TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Bubble(
                                message: 'Hi How are you ?',
                                isMe: true,
                              ),
                              Bubble(
                                message: 'have you seen the docs yet?',
                                isMe: true,
                              ),
                              Text(
                                'Feb 25, 2018',
                                style:
                                TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Bubble(
                                message: 'i am fine !',
                                isMe: false,
                              ),
                              Bubble(
                                message: 'yes i\'ve seen the docs',
                                isMe: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                offset: Offset(-2, 0),
                blurRadius: 5,
              ),
            ]),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera,
                    color: Color(0xff3E8DF3),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.image,
                    color: Color(0xff3E8DF3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Color(0xff3E8DF3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({required this.message, required this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Colors.grey,
                        Colors.blueGrey,
                      ])
                      : LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Color(0xFFEBF5FC),
                        Color(0xFFEBF5FC),
                      ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                  )
                      : BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}
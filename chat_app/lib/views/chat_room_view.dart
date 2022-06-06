import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              const Expanded(
                child: Center(child: Text('chats come here..')),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                 color: Colors.grey.shade100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // send message function
                      },
                      child: const Icon(
                        Icons.send,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

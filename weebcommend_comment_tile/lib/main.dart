import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:weebcommend_comment_tile/read_more.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: commentPage(),
      theme: ThemeData.dark(),
    );
  }
}

class commentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: commentTile(),
    );
  }
}

class commentTile extends StatelessWidget {
  String text = loremIpsum(words: 60);
  String username = 'Username123';
  String username2 = 'Username456';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            child: Text(username),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ReadMoreText(
                          text,
                          trimLength: 60,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                      tooltip: 'Delete comment',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            child: Text(username2),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ReadMoreText(
                          text,
                          trimLength: 60,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                      tooltip: 'Delete comment',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

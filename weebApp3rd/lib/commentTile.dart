import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'read_more.dart';
import 'user_page.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatefulWidget {
  String userName;
  String comment;
  String userID;
  bool isUser;
  Function deleteComment;
  Function updateComment;
  String userImage;
  TextEditingController textEditingController;

  CommentTile(this.userID, this.userName, this.comment, this.isUser,
      this.deleteComment, this.updateComment, this.userImage){textEditingController = TextEditingController(text: comment);}
  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  String editedComment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.grey.shade800,
        shadowColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 2,
              color: Colors.deepPurpleAccent,
            )),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (UserPage(widget.userID,
                                      Provider.of<User>(context)))));
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(widget.userImage),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.userName,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ReadMoreText(
                            widget.comment,
                            trimLength: 60,
                          ),
                        ),
                      ),
                    ],
                  )),
              if (widget.isUser)
                Container(
                  child: Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return AlertDialog(

                                    title: Text('Editing Comment'),
                                    content: TextField(
                                      minLines: 1,
                                      maxLines: 15,
                                      controller: widget.textEditingController,
                                    ),
                                    actions: [
                                      FlatButton(
                                        textColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            editedComment = widget.textEditingController.text;
                                          });
                                          print(editedComment);
                                          widget.updateComment(widget.comment, widget.userID, widget.userName, widget.userImage, editedComment);
                                          Navigator.of(context,
                                              rootNavigator: true)
                                              .pop(buildContext);
                                        },
                                        child: Text('Comment'),
                                      ),
                                    ],
                                  );
                                });
                          }),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.deleteComment(widget.comment, widget.userID,
                              widget.userName, widget.userImage);
                        },
                        tooltip: 'Delete comment',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

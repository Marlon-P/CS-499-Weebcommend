import 'package:flutter/material.dart';
import 'read_more.dart';

class CommentTile extends StatefulWidget {
  String userName;
  String comment;
  String userID;
  bool isUser;
  Function deleteComment;
  CommentTile(this.userID,this.userName,this.comment,this.isUser,this.deleteComment);
  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            child: Text(widget.userName),
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
                          widget.comment,
                          trimLength: 60,
                        ),
                      ),
                    ),
                  ),
                  if(widget.isUser) Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {widget.deleteComment(widget.comment,widget.userID,widget.userName);},
                      tooltip: 'Delete comment',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}


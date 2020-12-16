import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weeb_app/flushbarfunc.dart';
import 'read_more.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comAndScore.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'commentTile.dart';

class DetailBody extends StatefulWidget {
  int animeID;
  User user;
  DetailBody(this.animeID, this.user);
  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  List<dynamic> returnList = [];
  bool isConnected = true;
  bool noResults = false;
  comAndScore database;
  final myController = TextEditingController();
  CollectionReference userProfile;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> getData() async {
    try {
      if (!isConnected) {
        setState(() {
          isConnected = true;
        });
      }
      Response response = await get(
          "https://api.jikan.moe/v3/anime/" + widget.animeID.toString());
      Map data = jsonDecode(response.body);
      List<dynamic> returnList = [];
      if (data != null) {
        returnList.add(data['image_url']);
        returnList.add(data['title']);
        returnList.add(data['type']);
        returnList.add(data['episodes']);
        returnList.add(data['score']);
        returnList.add(data['rating']);
        returnList.add(data['synopsis']);
        returnList.add(data['trailer_url']);
        if (noResults) {
          setState(() {
            noResults = false;
          });
        }
        return returnList;
      } else {
        if (!noResults) {
          setState(() {
            noResults = true;
          });
        }
        return returnList;
      }
    } catch (e) {
      print(e);
      if (isConnected) {
        setState(() {
          isConnected = false;
        });
      }
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    List<dynamic> tempList = returnList;
    Future returnData = getData();
    returnData.then((value) => tempList = value);
    returnData.then((value) => setState(() {
          returnList = tempList;
        }));
    Firebase.initializeApp()
        .then((value) => database = comAndScore(widget.animeID))
        .then((value) => database.getDoc())
        .then((value) =>
            userProfile = FirebaseFirestore.instance.collection('users'));
  }

  Widget renderYoutube(String url) {
    if (url != null) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url),
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      return YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      );
    } else {
      return Text('');
    }
  }

  Widget renderComments(var snapshot) {
    if (snapshot.hasData && snapshot.data.data() != null) {
      Map data = snapshot.data.data();
      return Container(
        child: Text(data['comments'].toString() ?? 'default'),
      );
    } else {
      return Text("Loading");
    }
  }

  Widget renderUserComment(var snapshot) {
    if (snapshot.hasData &&
        snapshot.data.data() != null &&
        widget.user != null) {
      Map sata = snapshot.data.data();
      if (sata['comments'].length > 0) {
        for (int i = 0; i < sata['comments'].length; i++) {
          if (sata['comments'][i]
              .containsValue(FirebaseAuth.instance.currentUser.uid)) {
            return CommentTile(
                FirebaseAuth.instance.currentUser.uid,
                FirebaseAuth.instance.currentUser.displayName,
                sata['comments'][i]['comment'],
                true,
                deleteUserComment,
                sata['comments'][i]['image']);
          }
        }
        return Text('');
      } else {
        return Text('');
      }
    } else {
      return Text('');
    }
  }

  void deleteUserComment(
      String comment, String userID, String userName, String userImage) {
    database.deleteComment(comment, userID, userName, userImage);
  }
  
  void updateUserComment(String oldComment, String userID, String userName, String userImage, String editedComment ){
    database.updateComment(oldComment, userID, userName, userImage, editedComment);
  }

  bool commentExists(var snapshot) {
    if (snapshot.hasData &&
        snapshot.data.data() != null &&
        widget.user != null) {
      Map sata = snapshot.data.data();
      if (sata['comments'].length > 0) {
        for (int i = 0; i < sata['comments'].length; i++) {
          if (sata['comments'][i]
              .containsValue(FirebaseAuth.instance.currentUser.uid)) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<Widget> renderCommentList(var snapshot) {
    List<Widget> tempList = [];
    if (snapshot.hasData && snapshot.data.data() != null) {
      Map sata = snapshot.data.data();
      if (sata['comments'].length > 0) {
        for (int i = 0; i < sata['comments'].length; i++) {
          if (widget.user != null &&
              sata['comments'][i]
                  .containsValue(FirebaseAuth.instance.currentUser.uid)) {
            sata['comments'].removeAt(i);
          }
        }
        if (sata['comments'].length > 0) {
          sata['comments'].forEach((e) {
            tempList.add(CommentTile(e['userID'], e['userName'], e['comment'],
                false, deleteUserComment, updateUserComment,e['image']));
          });
          return tempList.reversed.toList();
        } else {
          return tempList;
        }
      } else {
        return tempList;
      }
    } else {
      return tempList;
    }
  }

  int displayScores(var snapshot) {
    if (snapshot.hasData && snapshot.data.data() != null) {
      int average = 0;
      Map sata = snapshot.data.data();
      if (sata['scores'].length > 0) {
        for (int i = 0; i < sata['scores'].length; i++) {
          average += sata['scores'][i]['score'];
        }
        return (average / sata['scores'].length).floor();
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  int displayYourScore(var snapshot) {
    if (snapshot.hasData &&
        snapshot.data.data() != null &&
        widget.user != null) {
      Map sata = snapshot.data.data();
      if (sata['scores'].length > 0) {
        for (int i = 0; i < sata['scores'].length; i++) {
          if (sata['scores'][i]
              .containsValue(FirebaseAuth.instance.currentUser.uid)) {
            return sata['scores'][i]['score'];
          }
        }
        return 0;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  void newComment(String val) async {
    var personRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);
    DocumentSnapshot profile = await personRef.get();
    database.comment(val, FirebaseAuth.instance.currentUser.uid,
        profile['username'], profile['image']);
  }

  void addToWatchList(context) {
    Map tempMap = {
      'imgUrl': returnList[0],
      'animeTitle': returnList[1],
      'animeID': widget.animeID
    };
    userProfile.doc(FirebaseAuth.instance.currentUser.uid).update({
      'watchlist': FieldValue.arrayUnion([tempMap])
    });
    showFlushBar(context: context, text: 'Added to watch list');
  }

  void removeFromWatchList(context) {
    Map tempMap = {
      'imgUrl': returnList[0],
      'animeTitle': returnList[1],
      'animeID': widget.animeID
    };
    userProfile.doc(FirebaseAuth.instance.currentUser.uid).update({
      'watchlist': FieldValue.arrayRemove([tempMap])
    });
    showFlushBar(
        context: context, text: 'Removed from watch list', color: Colors.red);
  }

  bool containsShow(var snapshot) {
    if (snapshot.hasData && snapshot.data.data() != null) {
      Map sata = snapshot.data.data();
      if (sata['watchlist'].length > 0) {
        for (int i = 0; i < sata['watchlist'].length; i++) {
          if (sata['watchlist'][i].containsValue(widget.animeID)) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget renderPage() {
    if (!isConnected) {
      return Center(
          child: Column(children: <Widget>[
        Icon(
          Icons.signal_wifi_off,
          size: 100,
        ),
        Text(
          "NO WIFI",
          style: TextStyle(fontSize: 100),
        )
      ]));
    } else if (noResults) {
      return Center(
          child: Column(children: <Widget>[
        Icon(
          Icons.block,
          size: 100,
        ),
        Text(
          "NO RESULTS",
          style: TextStyle(fontSize: 100),
        )
      ]));
    } else if (returnList.isNotEmpty) {
      return ListView(
        //mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream:
                  database.theDoc.doc(widget.animeID.toString()).snapshots(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        (returnList[1] != null) ? returnList[1] : "----",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: (returnList[0] != null)
                                ? Image.network(
                                    returnList[0],
                                    height: 250,
                                    width: (250 * 0.64),
                                    fit: BoxFit.fitHeight,
                                  )
                                : Icon(Icons.broken_image),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //Title
                              //Divider
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade800,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    (returnList[2] != null)
                                        ? returnList[2]
                                        : "----",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ), //Type e.g TV
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade800,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    (returnList[3] != null)
                                        ? 'Episodes: ' +
                                            returnList[3].toString()
                                        : "----",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ), //episodes
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade800,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          'MAL',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Text((returnList[4] != null)
                                            ? returnList[4].toString()
                                            : "----"),
                                      ),
                                    ],
                                  ),
                                ),
                              ), //rating score
                              SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade800,
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Weeb',
                                            style: TextStyle(
                                                color: Colors.purpleAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                              (displayScores(snapshot) != 0)
                                                  ? displayScores(snapshot)
                                                      .toString()
                                                  : "----"),
                                        ),
                                      ]),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: DropdownButton<int>(
                                          value:
                                              (displayYourScore(snapshot) != 0)
                                                  ? displayYourScore(snapshot)
                                                  : 1,
                                          icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (int newValue) {
                                            (displayYourScore(snapshot) == 0)
                                                ? database.Updatescore(
                                                    FirebaseAuth.instance
                                                        .currentUser.uid,
                                                    newValue,
                                                    0,
                                                    true)
                                                : database.Updatescore(
                                                    FirebaseAuth.instance
                                                        .currentUser.uid,
                                                    newValue,
                                                    displayYourScore(snapshot),
                                                    false);
                                          },
                                          items: (widget.user == null)
                                              ? []
                                              : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                                  .map<DropdownMenuItem<int>>(
                                                      (int value) {
                                                  return DropdownMenuItem<int>(
                                                      value: value,
                                                      child: Text(
                                                          value.toString()));
                                                }).toList(),
                                        ),
                                      ),
                                    ]),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade800,
                                ),
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    (returnList[5] != null)
                                        ? returnList[5]
                                        : "----",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),

                              (widget.user != null && userProfile != null)
                                  ? StreamBuilder<DocumentSnapshot>(
                                      stream: userProfile
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid
                                              .toString())
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null)
                                          return FlatButton(
                                              onPressed: () {},
                                              child: Text('Add to watchList'),
                                              color: Colors.grey);
                                        return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey.shade800,
                                            ),
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: (containsShow(snapshot) ==
                                                    false)
                                                ? FlatButton(
                                                    onPressed: () {
                                                      (widget.user != null)
                                                          ? addToWatchList(
                                                              context)
                                                          : {};
                                                    },
                                                    child: Text(
                                                        'Add to watchlist'),
                                                    color: Colors.blue)
                                                : FlatButton(
                                                    onPressed: () {
                                                      (widget.user != null)
                                                          ? removeFromWatchList(
                                                              context)
                                                          : {};
                                                    },
                                                    child: Text(
                                                        'Remove from watchlist'),
                                                    color: Colors.red));
                                      })
                                  : FlatButton(
                                      onPressed: () {},
                                      child: Text('Add to watchList'),
                                      color: Colors.grey), //Rating e.g R
                              // RaisedButton(
                              //   onPressed: null,
                              //   child: Text('Recommendations'),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: (returnList[6] != null)
                            ? ReadMoreText(
                                returnList[6],
                                style: TextStyle(fontSize: 18),
                                trimLines: 4,
                                trimMode: TrimMode.Line,
                                colorClickableText: Colors.blue,
                              )
                            : Text("No Info"),
                      ),
                    ),
                    SizedBox(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
          renderYoutube(returnList[7]),
          SizedBox(
            child: Divider(
              color: Colors.white,
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream:
                  database.theDoc.doc(widget.animeID.toString()).snapshots(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      (widget.user == null)
                          ? FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext buildContext) {
                                      return AlertDialog(
                                        title: Text('Sign in to comment'),
                                        actions: [
                                          FlatButton(
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(buildContext);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()));
                                            },
                                            child: Text('Login'),
                                          ),
                                          FlatButton(
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(buildContext);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignupPage()));
                                            },
                                            child: Text('Sign up'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text("Log in or Sign up to comment"))
                          : Container(
                              child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: TextField(
                                controller: myController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                minLines: 1,
                                maxLines: 5,
                                onSubmitted: (value) {
                                  (commentExists(snapshot))
                                      ? showFlushBar(
                                          context: context,
                                          text:
                                              'You have already commented! Please remove yours first!',
                                          color: Colors.red)
                                      : newComment(
                                          value) /*database.comment(value, FirebaseAuth.instance.currentUser.uid, FirebaseAuth.instance.currentUser.displayName, FirebaseAuth.instance.currentUser.photoURL)*/;
                                  myController.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Enter a comment",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                              ),
                            )),
                      if (widget.user != null) renderUserComment(snapshot),
                      Column(
                          children: renderCommentList(snapshot),
                          crossAxisAlignment: CrossAxisAlignment.start),
                    ],
                  ),
                );
              })
        ],
      );
    } else {
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('loading'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: renderPage());
  }
}

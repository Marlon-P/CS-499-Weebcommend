import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/authorizedHome.dart';
import 'package:weeb_app/gridview.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}


class _UserPageState extends State<UserPage> {


  String username = FirebaseAuth.instance.currentUser.displayName;
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = FirebaseAuth.instance.currentUser.displayName;
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: FirebaseAuth.instance.currentUser.displayName);
  }

  buildWatchList(AsyncSnapshot snapshot){

    List<Widget> userWatchlist = [];
    if(snapshot.hasData) {
      List watchlistData = snapshot.data.data()['watchlist'];
      for (Map<String, dynamic>anime in watchlistData) {
        print(anime['imgUrl']);
        userWatchlist.add(AnimeThumbNails(
          anime['imgUrl'], anime['animeTitle'], anime['animeID'], cache: false,
          height: 300,));
      }
    }
    return userWatchlist;
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _editUsernameField() {
      if (_isEditingText)

        return Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            alignment: Alignment.topRight,
            child: TextField(
              onSubmitted: (newValue){
                setState(() {
                  initialText = newValue;
                  _isEditingText =false;
                  FirebaseAuth.instance.currentUser.updateProfile(displayName: newValue);
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({'username' : newValue});
                });
              },
              autofocus: true,
              controller: _editingController,
            ),
          ),
        );
      return Expanded(
        child: Row(
          children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                alignment: Alignment.center,
                child: Text(
                initialText,
                softWrap: false,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),

            ),
              ),
          ],
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot){
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(

                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage('https://robohash.org/${username}'),
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(

                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/4),
                      ),
                      Container(
                        alignment: Alignment.center,

                        child: _editUsernameField()
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          endIndent: 5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Text('WATCHLIST'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          indent: 5,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Expanded(child:DisplayResultGrid(buildWatchList(snapshot))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

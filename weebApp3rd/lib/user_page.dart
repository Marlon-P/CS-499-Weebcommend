import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}


class _UserPageState extends State<UserPage> {


  String username = FirebaseAuth.instance.currentUser.displayName;
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = FirebaseAuth.instance.currentUser.displayName;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: FirebaseAuth.instance.currentUser.displayName);
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
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).set({'username' : newValue});
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
            IconButton(icon: Icon(Icons.mode_edit), onPressed: () {
             setState(() {
                _isEditingText = true;
                });}),
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
                          backgroundImage: AssetImage('images/kazuma.png'),
                          backgroundColor: Colors.black,
                        ),
                      ),
                      new Positioned(
                        right: 20.0,
                        bottom: 1,
                        child: IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/authorizedHome.dart';
import 'package:weeb_app/gridview.dart';
import 'package:image_picker/image_picker.dart';


class UserPage extends StatefulWidget {
  String pid;
  User user;
  UserPage(this.pid,this.user);
  @override
  _UserPageState createState() => _UserPageState();
}


class _UserPageState extends State<UserPage> {


  //String username = FirebaseAuth.instance.currentUser.displayName;
  bool _isEditingText = false;
  TextEditingController _editingController;
  //String initialText = FirebaseAuth.instance.currentUser.displayName;
  //String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    print(widget.pid);
  }

  List<Widget> buildWatchList(AsyncSnapshot snapshot){

    List<Widget> userWatchlist = [];
    if(snapshot.hasData && snapshot.data.data() != null) {
      List watchlistData = snapshot.data.data()['watchlist'];
      for (Map<String, dynamic>anime in watchlistData) {

        userWatchlist.add(AnimeThumbNails(
          anime['imgUrl'], anime['animeTitle'], anime['animeID'], cache: false,
          height: 250,));

      }
      return userWatchlist;
    }
    else{return userWatchlist;}}

    String getName(snapshot){
    if(snapshot.hasData && snapshot.data.data() != null){
      return snapshot.data.data()['username'];
    }
    else{return 'Loading';}
  }


  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  newProfilePic() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value)
    {
      uploadPic(value);
    }
    );
  }

  uploadPic(var file) async{
    List<String> Lring = await file.toString().split('image_picker');
    Future<String> refString;
    String refString2;
    var storageRef = FirebaseStorage.instance.ref().child(Lring[1]);
    var task = storageRef.putFile(file);
    await task.whenComplete(() => {
      refString = storageRef.getDownloadURL()
    });
    await refString.then((value) => refString2 = value);
    FirebaseFirestore.instance.collection('users').doc(widget.pid).update({'image': refString2});
    FirebaseAuth.instance.currentUser.updateProfile(photoURL: refString2);

  }

  String getImage(snapshot){
    if(snapshot.hasData && snapshot.data.data() != null){
      return snapshot.data.data()['image'];
    }
    else{return 'Loading';}
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
                  //initialText = newValue;
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
                'initialText',
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
      stream: FirebaseFirestore.instance.collection('users').doc(widget.pid).snapshots(),
      builder: (context, snapshot){
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){(widget.user != null && widget.pid == FirebaseAuth.instance.currentUser.uid) ? newProfilePic() : {};},
                      child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage((getImage(snapshot) == 'Loading') ? 'https://www.jqueryscript.net/images/loading-indicator-view.jpg' : getImage(snapshot)),
                      backgroundColor: Colors.black,
                    ),
                  )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: (widget.user == null || widget.pid != FirebaseAuth.instance.currentUser.uid) ? Text(getName(snapshot)) : Column(children: <Widget>[ Text(getName(snapshot)),
                        TextField(
                        onSubmitted: (newValue){
                          FirebaseAuth.instance.currentUser.updateProfile(displayName: newValue);
                          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({'username' : newValue});
                          },
                        autofocus: false,
                        controller: _editingController,
                        textAlign: TextAlign.center, decoration: InputDecoration(hintText: 'Change Username'),
                      )
                  ])),

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

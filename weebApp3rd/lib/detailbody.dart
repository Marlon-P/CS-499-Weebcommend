import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'read_more.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comAndScore.dart';
import 'login_page.dart';
import 'signup_page.dart';

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
  FirebaseAuth _auth;
  comAndScore database;
  final myController = TextEditingController();

  @override
  void dispose(){
    myController.dispose();
    super.dispose();
  }


  /*
  void getAuth() async {
    //FirebaseAuth auth = FirebaseAuth.instance;
    database = comAndScore(widget.animeID);
    database.getDoc();


    await FirebaseFirestore.instance.collection('comments').doc(widget.animeID.toString()).get().then((value) => {if(value.exists){print(value.data())}else{FirebaseFirestore.instance.collection('comments').doc(widget.animeID.toString()).set({'comments': [], 'scores': []})}});

    //var buture = document.get();
    //buture.then((value) => print(value.data()));
    //return auth;
  }*/

  void facebookSignIn() async {
    FacebookLogin loggedIn = FacebookLogin();
    final result = await loggedIn.logIn(['email']);
    final token = result.accessToken.token;
    final response = await get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(response.body);
    if(result.status == FacebookLoginStatus.loggedIn)
      {
        final credential = FacebookAuthProvider.credential(token);
        _auth.signInWithCredential(credential);
      }
  }

  bool isLogged(){
    FirebaseAuth.instance.authStateChanges().listen((User user) {if(user == null){print("no user"); return false;}else{print("logged in"); return true;}});
  }

  void signout(){
    FirebaseAuth.instance.signOut();
  }

  Future<List<dynamic>> getData() async {
    try {
      if(!isConnected)
      {
        setState(() {isConnected = true;});
      }
      Response response = await get(
          "https://api.jikan.moe/v3/anime/" + widget.animeID.toString());
      Map data = jsonDecode(response.body);
      List<dynamic> returnList = [];
      if(data != null) {
        returnList.add(data['image_url']);
        returnList.add(data['title']);
        returnList.add(data['type']);
        returnList.add(data['episodes']);
        returnList.add(data['score']);
        returnList.add(data['rating']);
        returnList.add(data['synopsis']);
        returnList.add(data['trailer_url']);
        if(noResults) {setState(() {noResults = false;});}
        return returnList;
      }
      else{
        if(!noResults){setState(() {noResults = true;});}
        return returnList;
      }
    }
    catch(e){
      print(e);
      if(isConnected)
      {setState(() {isConnected = false;});}
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    List<dynamic> tempList = returnList;
    Future returnData = getData();
    returnData.then((value) => tempList = value);
    returnData.then((value) =>
        setState(() {
          returnList = tempList;
        }));
    Firebase.initializeApp().then((value) => _auth = FirebaseAuth.instance).then((value) => database = comAndScore(widget.animeID)).then((value) => database.getDoc());
  }

  Widget renderYoutube(String url)
  {
    if(url != null)
      {
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
      }
    else {
      return Text('');
    }
  }

  Widget renderComments(var snapshot){
    if (snapshot.hasData && snapshot.data.data() != null)
    {
      Map data = snapshot.data.data();
      return Container(
        child: Text(data['comments'].toString() ?? 'default'),
      );
    }
    else {return Text("Loading");}
  }

  Widget renderUserComment(var snapshot){
    if(snapshot.hasData && snapshot.data.data() != null && widget.user != null){
    Map sata = snapshot.data.data();
    if(sata['comments'].length > 0){
    for (int i = 0; i < sata['comments'].length; i++) {
        if (sata['comments'][i].containsValue(
            FirebaseAuth.instance.currentUser.uid)) {
          return Column(children: [
            Row(children: [Text(sata['comments'][i]['userName'], textAlign: TextAlign.left,),FlatButton(onPressed: () {
              database.deleteComment(
                  sata['comments'][i]['comment'], sata['comments'][i]['userID'],
                  sata['comments'][i]['userName']);
            }, child: Icon(Icons.restore_from_trash),)]),
            Text(sata['comments'][i]['comment'], textAlign: TextAlign.left),
          ], crossAxisAlignment: CrossAxisAlignment.start);
        }
      }
    return Text('');
    }
    else{return Text('');}
    }
    else {return Text('');}
  }

  bool commentExists(var snapshot){
    if(snapshot.hasData && snapshot.data.data() != null && widget.user != null){
      Map sata = snapshot.data.data();
      if(sata['comments'].length > 0){
        for (int i = 0; i < sata['comments'].length; i++) {
          if (sata['comments'][i].containsValue(
              FirebaseAuth.instance.currentUser.uid)) {
            return true;
          }
        }
        return false;
      }
      else{return false;}
    }
    else {return false;}
  }

  List<Widget> renderCommentList(var snapshot){
    List<Widget> tempList = [];
    if (snapshot.hasData && snapshot.data.data() != null)
    {
      Map sata = snapshot.data.data();
      if(sata['comments'].length > 0){
        for(int i = 0; i < sata['comments'].length; i++){
          if(widget.user != null && sata['comments'][i].containsValue(FirebaseAuth.instance.currentUser.uid))
            {sata['comments'].removeAt(i);}
        }
        if(sata['comments'].length > 0){
        sata['comments'].forEach((e){tempList.add(Column(children: [
            Text(e['userName'], textAlign: TextAlign.left),
            Text(e['comment'], textAlign: TextAlign.left)
          ], crossAxisAlignment: CrossAxisAlignment.start,));});
          return tempList;
        }
        else {return tempList;}
    }
      else{return tempList;}
    }
      else{return tempList;}
  }

  int displayScores(var snapshot){
    if(snapshot.hasData && snapshot.data.data() != null)
      {
        int average = 0;
        Map sata = snapshot.data.data();
        if(sata['scores'].length > 0){
          for(int i = 0; i < sata['scores'].length; i++){
            average += sata['scores'][i]['score'];
          }
          return (average/sata['scores'].length).floor();
        }
        else{return 0;}
      }
    else
      {return 0;}
  }

  int displayYourScore(var snapshot){
    if(snapshot.hasData && snapshot.data.data() != null && widget.user != null)
    {
      Map sata = snapshot.data.data();
      if(sata['scores'].length > 0){
        for(int i = 0; i < sata['scores'].length; i++){
          if(sata['scores'][i].containsValue(FirebaseAuth.instance.currentUser.uid))
            {return sata['scores'][i]['score'];}
        }
        return 0;
      }
      else{return 0;}
    }
    else
    {return 0;}
  }


  Widget renderPage()  {

    if(!isConnected)
    {
    return Center(child: Column(children: <Widget>[Icon(Icons.signal_wifi_off, size: 100,), Text("NO WIFI",style: TextStyle(fontSize: 100),)]));
    }
    else if(noResults)
    {
    return Center(child: Column(children: <Widget>[Icon(Icons.block, size: 100,), Text("NO RESULTS",style: TextStyle(fontSize: 100),)]));
    }
    else if (returnList.isNotEmpty) {
      return StreamBuilder<DocumentSnapshot>(
        stream: database.theDoc.doc(widget.animeID.toString()).snapshots(),
        builder: (context, snapshot) {
          return Scrollbar(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: (returnList[0] != null) ? Image.network(
                          returnList[0],
                          height: 250,
                          width: (250 * 0.64),
                          fit: BoxFit.fitHeight,
                        ) : Icon(Icons.broken_image),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text((returnList[1] != null) ? returnList[1] : "------",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), //Title
                          Container(
                            child: Divider(
                              color: Colors.white,
                            ),
                          ), //Divider
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade800,
                            ),
                            margin: EdgeInsets.only(top: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                (returnList[2] != null) ? returnList[2] : "------",
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
                                (returnList[3] != null) ? returnList[3].toString() : "------",
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
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 3.0),
                                    child: Text((returnList[4] != null) ? returnList[4].toString() : "------"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 3.0),
                                    child: Text((displayScores(snapshot) != 0) ? displayScores(snapshot).toString() : "------"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: DropdownButton<int>(value: (displayYourScore(snapshot) != 0) ? displayYourScore(snapshot) : 1, icon: Icon(Icons.arrow_downward), onChanged: (int newValue){(displayYourScore(snapshot) == 0) ? database.Updatescore(FirebaseAuth.instance.currentUser.uid, newValue, 0, true) : database.Updatescore(FirebaseAuth.instance.currentUser.uid, newValue, displayYourScore(snapshot), false);}, items: (widget.user == null) ? [] : [1,2,3,4,5,6,7,8,9,10].map<DropdownMenuItem<int>>((int value){return DropdownMenuItem<int>(value: value, child: Text(value.toString()));}).toList(),)
                                  ),
                                ],
                              ),
                            ),
                          ), //rating score
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade800,
                            ),
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                (returnList[5] != null) ? returnList[5] : "------",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ), //Rating e.g R
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
                    child: (returnList[6] != null) ? ReadMoreText(
                      returnList[6],
                      style: TextStyle(fontSize: 18),
                      trimLines: 4,
                      trimMode: TrimMode.Line,
                      colorClickableText: Colors.blue,
                    ) : Text("No Info"),
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
             renderYoutube(returnList[7]),
                //FlatButton(onPressed: (){facebookSignIn();}, child: Text("FACEBOOK")),
                //FlatButton(onPressed: (){isLogged();}, child: Text("Signed In?"),),
                //FlatButton(onPressed: (){signout();},child: Text("sign Out")),
                SizedBox(height: 5,),
              (widget.user == null) ?
            FlatButton(
                shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)
                ),
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
                                Navigator.of(context, rootNavigator: true).pop(buildContext);

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              child: Text('Login'),
                            ),
                            FlatButton(
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop(buildContext);

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SignupPage()));
                              },
                              child: Text('Sign up'),
                            ),
                          ],
                        );
                      }
                  );
                },
                child: Text("Log in or Sign up to comment"))

              :

          TextField(
          controller: myController,
          onSubmitted: (value) {(commentExists(snapshot)) ? print("already there") : database.comment(value, FirebaseAuth.instance.currentUser.uid, 'test') ;},
          decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter a comment",
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          ),
          ),
          ),

                //FlatButton(onPressed: (){(commentExists(snapshot)) ? print("already there") : database.comment('bigchumgus22', FirebaseAuth.instance.currentUser.uid, 'test') ;},child: Text('submit'),),
                if(widget.user != null) renderUserComment(snapshot),
                Column(children: renderCommentList(snapshot), crossAxisAlignment: CrossAxisAlignment.start),
                //Text((snapshot.hasData && snapshot.data.data() != null) ? commentExists(snapshot) : "loading"),
                //ListView(children: renderCommentList(snapshot), scrollDirection: Axis.vertical,),
                /*
                FutureBuilder(
                  future: database.getStream(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
                    if(snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.data == null){return Text("loading");}
                      else{
                        print(snapshot.data);
                        return snapshot.data;}
                    }
                    else{return Text("connecting");}
                    },
                ),*/
              ],
            ),
          );
        }
      );
    }

    else {
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
    return Scaffold(
        body: renderPage()
    );
  }
}

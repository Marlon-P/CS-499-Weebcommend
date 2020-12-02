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

class DetailBody extends StatefulWidget {
  int animeID;
  DetailBody(this.animeID);
  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {

  List<dynamic> returnList = [];
  bool isConnected = true;
  bool noResults = false;
  FirebaseAuth _auth;

  Future<FirebaseAuth> getAuth() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth;
  }


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

  void isLogged(){
    FirebaseAuth.instance.authStateChanges().listen((User user) {if(user == null){print("no user");}else{print("signed in");}});
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
    Future returnAuth = getAuth();
    returnAuth.then((value) => _auth = value);
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


  Widget renderPage() {

    if(!isConnected)
    {
    return Center(child: Column(children: <Widget>[Icon(Icons.signal_wifi_off, size: 100,), Text("NO WIFI",style: TextStyle(fontSize: 100),)]));
    }
    else if(noResults)
    {
    return Center(child: Column(children: <Widget>[Icon(Icons.block, size: 100,), Text("NO RESULTS",style: TextStyle(fontSize: 100),)]));
    }
    else if (returnList.isNotEmpty) {
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
           // FlatButton(onPressed: (){isLogged();}, child: Text("Signed In?"),),
            //FlatButton(onPressed: (){signout();},child: Text("sign Out"))
          ],
        ),
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

import 'package:flutter/material.dart';
import 'read_more.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';

class DetailBody extends StatefulWidget {
  int animeID;
  DetailBody(this.animeID);

  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  List<dynamic> returnList = [];

  Future<List<dynamic>> getData() async {
    Response response = await get(
        "https://api.jikan.moe/v3/anime/" + widget.animeID.toString());
    Map data = jsonDecode(response.body);
    List<dynamic> returnList = [];
    returnList.add(data['image_url']);
    returnList.add(data['title']);
    returnList.add(data['type']);
    returnList.add(data['episodes']);
    returnList.add(data['score']);
    returnList.add(data['rating']);
    returnList.add(data['synopsis']);
    return returnList;
  }

  @override
  void initState() {
    super.initState();
    List<dynamic> tempList = returnList;
    Future returnData = getData();
    returnData.then((value) => tempList = value);
    returnData.then((value) => setState((){
      returnList = tempList;
    }));

  }

  Widget renderPage() {
    if (returnList.isNotEmpty) {
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
                    child: Image.network(
                      returnList[0],
                      height: 250,
                      width: (250 * 0.64),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          returnList[1],
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
                            returnList[2],
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
                            returnList[3].toString(),
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
                                child: Text(returnList[4].toString()),
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
                            returnList[5],
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
                child: ReadMoreText(
                  returnList[6],
                  style: TextStyle(fontSize: 18),
                  trimLines: 4,
                  trimMode: TrimMode.Line,
                  colorClickableText: Colors.blue,
                ),
              ),
            ),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Future no;
List<String> why;

  @override
  void initState(){
    no = getData();
    no.then((value) => why = value);
    super.initState();


  }

  Future<List<String>> getData() async {
    Response response = await get(
        'https://api.jikan.moe/v3/search/anime?status=airing&order_by=members');
    Map data = jsonDecode(response.body);
    List<dynamic> yes = data['results'];
    List<String> temp = [];
    yes.forEach((element) => temp.add(element['image_url']));
    return temp;
  }

    @override
    Widget build(BuildContext context) {
      return
        Scaffold(body: Container(
          child: FutureBuilder(
            future: no,
            builder: (context,snapshot){
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none: return Text('none');
                  case ConnectionState.done: return Scaffold(
                    body: Container(
                        child: ListView(children: why.map((e) => Image.network(e)).toList())
                  ));
                  default: return Text('loading');
                }
            }
          )
        ));
    }



}







import 'package:flutter/material.dart';
import 'package:weeb_app/animes.dart';
import 'package:weeb_app/homescreen.dart';
import 'advanceSearch.dart';

void main() {
  runApp(MyApp());
 // List<Anime> myanimes = [];
 // Future<List<dynamic>> animes =  advanceSearch(myanimes, query: 'fullmetal');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weebcommend',
      theme: ThemeData.dark(),
      home:home(),
    );
  }
}


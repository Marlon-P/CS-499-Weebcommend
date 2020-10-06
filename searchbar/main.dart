import 'package:flutter/material.dart';
import 'searchbar.dart';



void main() {
  runApp(MaterialApp(
    title: 'Weebcommend',
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      AnimeResults.routeName: (context) => AnimeResults(),
    }
  ));
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        color: Colors.grey[600],
        child: SearchBar(context, AnimeResults.routeName),
      )
    );
  }
}


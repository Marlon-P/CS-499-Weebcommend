import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:weeb_app/bodyforhomescreen.dart';
import 'gridview.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    homeweeb(),
    DisplayResultGrid(buildList()),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_currentIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> _screens[1])),
          icon: Icon(Icons.search),
          label: Text('Recommendations'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

// Row TopGenres(String genre, Jikan)

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:weeb_app/bodyforhomescreen.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    homeweeb(),
    homeweeb(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Recommendations'),
            ),
          ],
          onTap:(index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}



// Row TopGenres(String genre, Jikan)

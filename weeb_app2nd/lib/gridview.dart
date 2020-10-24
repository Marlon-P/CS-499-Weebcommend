import 'package:flutter/material.dart';
import 'bodyforhomescreen.dart';
import 'bodyforhomescreen.dart';

//Takes in list of animethumbnails(height:290) and displays it in 2 col view. 
class DisplayResultGrid extends StatefulWidget {
  @override
  List<AnimeThumbNails> animeList = [];
  DisplayResultGrid(this.animeList);
  _DisplayResultGridState createState() => _DisplayResultGridState();
}

class _DisplayResultGridState extends State<DisplayResultGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          padding: EdgeInsets.only(left: 11),
          childAspectRatio: .64,
          crossAxisCount: 2,
          children: widget.animeList,
        ),
      ),
    );
  }
}

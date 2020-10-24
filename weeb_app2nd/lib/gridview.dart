import 'package:flutter/material.dart';
import 'bodyforhomescreen.dart';
import 'bodyforhomescreen.dart';



List<AnimeThumbNails> buildList() {
  List<AnimeThumbNails> temp = [];
  for (int i = 0; i < 110; i++) {
    temp.add(AnimeThumbNails(
        'https://cdn.myanimelist.net/images/anime/1557/95194.jpg?s=b221303074075efb951d22307beaf6c0',
        'testtitle',cache: false,height: 290,));
  }
  return temp;
}

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

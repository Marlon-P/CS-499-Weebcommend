import 'package:flutter/material.dart';
import 'home.dart';




List<AnimeThumbNails> buildList() {
  List<AnimeThumbNails> temp = [];
  for (int i = 0; i < 110; i++) {
    temp.add(AnimeThumbNails(
        'https://cdn.myanimelist.net/images/anime/1557/95194.jpg?s=b221303074075efb951d22307beaf6c0',
        'testtitle', 111,height: 290, cache: true));
    //,cache: false,height: 255,));
  }
  return temp;
}

class DisplayResultGrid extends StatefulWidget {
  @override
  List animeList = [];
  DisplayResultGrid(this.animeList);
  _DisplayResultGridState createState() => _DisplayResultGridState();
}

class _DisplayResultGridState extends State<DisplayResultGrid> {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GridView.count(
            padding: EdgeInsets.only(left: 11),
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height/1.35),
            crossAxisCount: 2,
            children: widget.animeList,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        body: AnimeDetail(),
      ),
    ),
  );
  Anime_Search();
}

Future Anime_Search() async {
  var anime = await Jikan().search('Overlord', SearchType.anime);
  var thumbnail = anime[0].imageUrl;
}

class AnimeDetail extends StatefulWidget {
  @override
  _AnimeDetailState createState() => _AnimeDetailState();
}

class _AnimeDetailState extends State<AnimeDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [],
        ),
      ],
    );
  }
}

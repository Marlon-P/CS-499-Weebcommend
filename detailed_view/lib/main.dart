import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

void main() {
  runApp(
    MaterialApp(home: AnimeDetail()),
  );
  AnimeSearch();
}

Future AnimeSearch() async {
  var anime = await Jikan().search('Overlord', SearchType.anime);
  print(anime);
}

class AnimeDetail extends StatefulWidget {
  @override
  _AnimeDetailState createState() => _AnimeDetailState();
}

class _AnimeDetailState extends State<AnimeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {}, // code for back button
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              children: [
                Image.network(
                  'https://cdn.myanimelist.net/images/anime/7/88019.jpg?s=79b1142c4818577b9925017b0240131a',
                  height: 200,
                  width: (200 * 0.64),
                  fit: BoxFit.fitHeight,
                ),
                // SizedBox(
                //   width: 20,
                // ),
                Container(
                  color: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        color: Colors.grey.shade900,
                        child: Text(
                          'Title: Overlord',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        color: Colors.grey.shade900,
                        child: Text(
                          'Type: TV',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        color: Colors.grey.shade900,
                        child: Text(
                          'Episodes: 13',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        color: Colors.grey.shade900,
                        child: Text(
                          'Rating Score: 7.98',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        color: Colors.grey.shade900,
                        child: Text(
                          'Rated: R',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 1.5),
              color: Colors.grey.shade900,
              child: Text(
                'Synopsis:',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 10,
              child: Divider(
                color: Colors.orange,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
              color: Colors.grey.shade900,
              child: Text(
                'The final hour of the popular virtual reality game Yggdrasil has come. However, Momonga, a powerful wizard and master of the dark guild Ainz Ooal Gown, decides to spend his last few moments in the game as the servers begin to shut down. To his surprise, despite the clock having struck midnight, Momonga is still fully conscious as his character and, moreover, the non-player characters appear to have developed personalities of their own!',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

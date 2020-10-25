import 'package:flutter/material.dart';
import 'read_more.dart';

class DetailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://cdn.myanimelist.net/images/anime/7/88019.jpg?s=79b1142c4818577b9925017b0240131a',
                    height: 250,
                    width: (250 * 0.64),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Longer Title for Demo',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), //Title
                    Container(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ), //Divider
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      margin: EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          'TV',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ), //Type e.g TV
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      margin: EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          '13 Episodes',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ), //episodes
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      margin: EdgeInsets.only(top: 5),
                      child: Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text('7.98'),
                            ),
                          ],
                        ),
                      ),
                    ), //rating score
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          'Rated: R',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ), //Rating e.g R
                    // RaisedButton(
                    //   onPressed: null,
                    //   child: Text('Recommendations'),
                    // ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            child: Divider(
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade800,
            ),
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ReadMoreText(
                'The final hour of the popular virtual reality game Yggdrasil has come. However, Momonga, a powerful wizard and master of the dark guild Ainz Ooal Gown, decides to spend his last few moments in the game as the servers begin to shut down. To his surprise, despite the clock having struck midnight, Momonga is still fully conscious as his character and, moreover, the non-player characters appear to have developed personalities of their own! Confronted with this abnormal situation, Momonga commands his loyal servants to help him investigate and take control of this new world, with the hopes of figuring out what has caused this development and if there may be others in the same predicament.',
                style: TextStyle(fontSize: 18),
                trimLines: 4,
                trimMode: TrimMode.Line,
                colorClickableText: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

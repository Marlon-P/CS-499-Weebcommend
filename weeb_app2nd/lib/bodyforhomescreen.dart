import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'filters.dart';
import 'package:jikan_api/jikan_api.dart';
import 'regularSearchBarScreen.dart';


class homeweeb extends StatefulWidget {
  @override
  _homeweebState createState() => _homeweebState();
}

class _homeweebState extends State<homeweeb> {

  Future<List<Anime>> _getAnime(String text) async {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {

        return new RegSearchBarScreen(text);
      })
    );

    List anime = [];

    return anime;
  }

  @override
  Widget build(BuildContext context) {
       return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              child: SearchBar(
                onSearch: null,
                onItemFound: null,
                textStyle: TextStyle(color: Colors.white),
                hintText: 'Search for an Anime...',
              ),
            ),//SearchBar
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Animes',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //Top Animes
            RowsContainingAnimeThumbNails(TopSubtype.bypopularity),
            Container(
              height: 75,
              color: Colors.black54,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GenreCapsules('Action', Colors.red),
                  GenreCapsules('Adventure', Colors.blue),
                  GenreCapsules('Comedy', Colors.green),
                  GenreCapsules('Romance', Colors.pink),
                  GenreCapsules('Slice of Life', Colors.deepOrange),
                  GenreCapsules('Sports', Colors.deepPurple),
                  GenreCapsules('', Colors.white, icon: Icons.add)
                ],
              ),
            ), //genres
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Airing',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //topairing
            RowsContainingAnimeThumbNails(TopSubtype.airing),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top TV',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //Top Tv
            RowsContainingAnimeThumbNails(TopSubtype.tv),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 7),
                child: Text(
                  'Top Movies',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ]), //Top Movies
            RowsContainingAnimeThumbNails(TopSubtype.movie),
          ],
        ), //Top Overall
      ],
    );
  }
  Container GenreCapsules(String genre, var color, {var icon}) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        color: color,
        shadowColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => (filters(genre.toLowerCase()))),);
          },
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null
                    ? Text(
                  genre,
                  style: TextStyle(fontSize: 25),
                )
                    : Icon(
                  icon,
                  size: 50,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
Container AnimeThumbNails(String imgUrl, String animeTitle) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Wrap(
        children: [
          Column(children: [
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () {
                print('tapped');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  imgUrl,
                  height: 180,
                  width: (180 * 0.64),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: (180 * 0.64),
              child: Text(
                animeTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ],
      ),
    );
  }
class RowsContainingAnimeThumbNails extends StatelessWidget {
  @override
  final TopSubtype  topSubtype;
  Future <List<AnimeThumbNails>>atn;
  RowsContainingAnimeThumbNails(TopSubtype this.topSubtype){
    atn = fetchAnimeThumbNails();
  }
  Future<List<AnimeThumbNails>> fetchAnimeThumbNails() async {
    var jikan = Jikan();
    List<AnimeThumbNails> temp = [];
    var top = await jikan.getTop(TopType.anime, subtype: topSubtype);
    for (int i = 0; i <= 9; i++) {
      print(top[i].imageUrl);
      temp.add(AnimeThumbNails(top[i].imageUrl, top[i].title));
    }
    return temp;
  }
  Widget build(BuildContext context) {
    return FutureBuilder(future: fetchAnimeThumbNails(),
        builder: (context,snapshot){
      return Container(
        height: 210,
        margin: EdgeInsets.only(top: 5),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data,
        ),
      );
        }
    );
  }
}



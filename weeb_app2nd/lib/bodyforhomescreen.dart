import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'filters.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:extended_image/extended_image.dart';
import 'package:async/async.dart';
// import 'regularSearchBarScreen.dart';

fetchDataforHomescreen()async{

  var jikan = Jikan();
  Map<String,List<Widget>> topCategories = {'airing':[],'movies':[],'popularity':[],'tv':[]};
  var toppop = await jikan.getTop(TopType.anime, subtype: TopSubtype.bypopularity);
  print(toppop);
  var topair = await jikan.getTop(TopType.anime, subtype: TopSubtype.airing);
  var topmovies = await jikan.getTop(TopType.anime,subtype: TopSubtype.movie);
  var toptv = await jikan.getTop(TopType.anime,subtype: TopSubtype.tv);

  for (int i = 0; i <= 9; i++) {
    topCategories['popularity'].add(AnimeThumbNails(toppop[i].imageUrl, toppop[i].title,cache: true,));
    topCategories['airing'].add(AnimeThumbNails(topair[i].imageUrl, topair[i].title,cache: true,));
    topCategories['movies'].add(AnimeThumbNails(topmovies[i].imageUrl, topmovies[i].title,cache: true,));
    topCategories['tv'].add(AnimeThumbNails(toptv[i].imageUrl, toptv[i].title,cache: true,));
  }
  return topCategories;
}

class homeweeb extends StatefulWidget {
  @override
  _homeweebState createState() => _homeweebState();
}

class _homeweebState extends State<homeweeb> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataforHomescreen(),
      // ignore: missing_return
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.done:
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
                    ), //SearchBar
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
                    RowsContainingAnimeThumbNails(snapshot.data['popularity']),
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
                    RowsContainingAnimeThumbNails(snapshot.data['airing']),
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
                    RowsContainingAnimeThumbNails(snapshot.data['tv']),
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
                    RowsContainingAnimeThumbNails(snapshot.data['movies']),
                  ],
                ), //Top Overall
              ],
            );
        }
      },
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (filters(genre.toLowerCase()))),
            );
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

class AnimeThumbNails extends StatelessWidget {
  final String imgUrl;
  final String animeTitle;
  final double height;
  final bool cache;
  @override
  AnimeThumbNails(String this.imgUrl, String this.animeTitle,
      {@required bool this.cache, double this.height = 180});
  Widget build(BuildContext context) {
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
                child: ExtendedImage.network(
                  imgUrl,
                  cache: cache,
                  height: height,
                  width: (height * 0.64),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: (height * 0.64),
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
}

class RowsContainingAnimeThumbNails extends StatelessWidget {
  List animes = [];

  RowsContainingAnimeThumbNails(this.animes);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: EdgeInsets.only(top: 5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: animes,
      ),
    );
  }
}

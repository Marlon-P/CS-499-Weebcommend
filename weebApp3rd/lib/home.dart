import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:weeb_app/splashscreen.dart';
import 'filters.dart';
import 'package:jikan_api/jikan_api.dart';
import 'regularSearchBarScreen.dart';
import 'detailpage.dart';
import 'package:extended_image/extended_image.dart';
import 'viewmoretop.dart';

fetchDataforHomescreen() async {
  var jikan = Jikan();
  Map<String, List<Widget>> topCategories = {
    'Airing': [],
    'Movies': [],
    'Animes': [],
    'TV': []
  };
  var toppop = await jikan.getTop(TopType.anime, subtype: TopSubtype.bypopularity);
  var topair = await jikan.getTop(TopType.anime, subtype: TopSubtype.airing);
  var topmovies = await jikan.getTop(TopType.anime, subtype: TopSubtype.movie);
  var toptv = await jikan.getTop(TopType.anime, subtype: TopSubtype.tv);


  for (int i = 0; i <= 49; i++) {
    topCategories['Animes'].add(AnimeThumbNails(
      toppop[i].imageUrl,
      toppop[i].title,
      toppop[i].malId,
      cache: true,
    ));
    topCategories['Airing'].add(AnimeThumbNails(
      topair[i].imageUrl,
      topair[i].title,
      topair[i].malId,
      cache: true,
    ));
    topCategories['Movies'].add(AnimeThumbNails(
      topmovies[i].imageUrl,
      topmovies[i].title,
      topmovies[i].malId,
      cache: true,
    ));
    topCategories['TV'].add(AnimeThumbNails(
      toptv[i].imageUrl,
      toptv[i].title,
      toptv[i].malId,
      cache: true,
    ));
  }
  return topCategories;
}

class homeweeb extends StatefulWidget {
  @override
  _homeweebState createState() => _homeweebState();
}

class _homeweebState extends State<homeweeb> {
  Future<List<Anime>> _getAnime(String text) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new RegSearchBarScreen(text, 'default');
    }));

    List anime = [];

    return anime;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataforHomescreen(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
            return splashScreen();
          case ConnectionState.waiting:
            return splashScreen();
          case ConnectionState.done:
            return Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed:() {
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[800],
                                      ),
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                                              width: double.infinity,
                                              height: 50.0,
                                              color: Colors.grey,
                                              child: TextField(
                                                controller: new TextEditingController(),
                                                decoration:
                                                InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    isDense: true,

                                                    hintText: 'Get a Recommendation',
                                                    hintStyle: TextStyle(color: Colors.white)
                                                ),
                                                onSubmitted: (Text) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) {

                                                        return new RegSearchBarScreen(Text, 'recommend');
                                                      })
                                                  );
                                                },
                                              )
                                          )
                                      )
                                  )
                                ]
                            )
                        );
                      }
                  );
                },
                icon: Icon(Icons.search),
                label: Text('Recommendations'),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              body: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        child: SearchBar(
                          onSearch: _getAnime,
                          onItemFound: null,
                          textStyle: TextStyle(color: Colors.white),
                          hintText: 'Search for an Anime...',
                        ),
                      ), //SearchBar
                      TopViewMore(
                          toptype: 'Animes',
                          context: context,
                          snapshot: snapshot), //Top Animes
                      RowsContainingAnimeThumbNails(
                          snapshot.data['Animes'].sublist(0, 10)),
                      Container(//Genres
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
                            GenreCapsules('Genre', Colors.white, icon: Icons.add)
                          ],
                        ),
                      ), //genres
                      TopViewMore(
                          toptype: 'Airing',
                          context: context,
                          snapshot: snapshot),
                      RowsContainingAnimeThumbNails(
                          snapshot.data['Airing'].sublist(0, 10)),
                      TopViewMore(
                          toptype: 'TV',
                          context: context,
                          snapshot: snapshot),
                      RowsContainingAnimeThumbNails(
                          snapshot.data['TV'].sublist(0, 10)),
                      TopViewMore(
                          toptype: 'Movies',
                          context: context,
                          snapshot:
                              snapshot),
                      RowsContainingAnimeThumbNails(
                          snapshot.data['Movies'].sublist(0, 10)),
                    ],
                  ), //Top Overall
                ],
              ),
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
  String imgUrl;
  String animeTitle;
  int animeID;
  double height;
  bool cache;
  var additionalAnimeInfo;
  fetchMore()async{
    var jikan = Jikan();
    var moreinfo = jikan.getAnimeInfo(animeID);
    return moreinfo;
  }

  @override
  AnimeThumbNails(String this.imgUrl, String this.animeTitle, int this.animeID,
      {@required bool this.cache, double this.height = 180});

  AnimeThumbNails.search_rec([Search schAnime, Recommendation recAnime]) {
    if (schAnime != null) {
      this.imgUrl = schAnime.imageUrl;
      this.animeTitle = schAnime.title;
      this.animeID = schAnime.malId;
      this.height = 250.0;
      this.cache = false;
    } else if (recAnime != null) {
      this.imgUrl = recAnime.imageUrl;
      this.animeTitle = recAnime.title;
      this.animeID = recAnime.malId;
      this.height = 250.0;
      this.cache = false;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Wrap(
        children: [
          Column(children: [
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () {
                //print('tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => (DetailPage(animeID))),
                );
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

Row TopViewMore(
    {@required String toptype, AsyncSnapshot snapshot, BuildContext context}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Container(
      margin: EdgeInsets.only(left: 5, top: 7),
      child: Text(
        'Top $toptype',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(top: 7),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      (ViewMore(toptype,snapshot.data[toptype]))));
        },
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
  ]);
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weeb_app/splashscreen.dart';
import 'filters.dart';
import 'package:jikan_api/jikan_api.dart';
import 'login_page.dart';
import 'regularSearchBarScreen.dart';
import 'detailpage.dart';
import 'package:extended_image/extended_image.dart';
import 'signup_page.dart';
import 'viewmoretop.dart';



class homeweeb extends StatefulWidget {




  @override
  _homeweebState createState() => _homeweebState();
}

class _homeweebState extends State<homeweeb> {
  bool isConnected = true;
  List<String> animeTitles = [];




  fetchDataforHomescreen() async {
    var jikan = Jikan();
    Map<String, List<Widget>> topCategories = {
      'Airing': [],
      'Movies': [],
      'Animes': [],
      'TV': []
    };

    try {
      var toppop = await jikan.getTop(
          TopType.anime, subtype: TopSubtype.bypopularity);
      var topair = await jikan.getTop(TopType.anime, subtype: TopSubtype.airing);
      var topmovies = await jikan.getTop(
          TopType.anime, subtype: TopSubtype.movie);
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
      if(!isConnected)
      {
        setState(() {isConnected = true;});
      }
      return topCategories;
    }
    catch(e){
      print(e);
      if(isConnected)
      {setState(() {isConnected = false;});}
      return topCategories;
    }
  }

  Future<List<String>> loadData() async {

    List<String> data = [];
    await rootBundle.loadString('assets/title_of_animes.txt').then((q) {
      for (String i in LineSplitter().convert(q)) {

        data.add(i);
      }
    });

    return data;
  }

  _loadTitles() async {
    List<String> data = await loadData();

    setState(() {
      animeTitles = data;
    });;

  }



  @override
  initState() {
    _loadTitles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget signInTile = Container();

    Widget signUpTile = Container();




    signInTile = ListTile(
        title: Text('Login'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage()));

        }
    );
    signUpTile = ListTile(
        title: Text('Sign-up'),
        onTap: () {
          // Code that leads to sign-up page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignupPage()));

        }
    );




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
          case ConnectionState.done: return (isConnected) ?
          Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: ()  {
                      showSearch(
                          context: context,
                          delegate: AutoSearchBar(animeTitles, false, 'default'),
                          query: ''
                      );


                    }
                )
              ],
            ),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Weebcommend'),
                    decoration: BoxDecoration(
                      color: Colors.blue,

                    ),
                  ),
                  signInTile,
                  signUpTile,

                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed:() {
                showSearch(
                    context: context,
                    delegate: AutoSearchBar(animeTitles, false, 'recommend'),
                    query: ''
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
          )
              : Center(child: Column(children: <Widget>[Icon(Icons.signal_wifi_off, size: 100,), Text("NO WIFI OR API ERROR",style: TextStyle(fontSize: 50),), FlatButton(onPressed: (){fetchDataforHomescreen();},child: Text("Restart",style: TextStyle(fontSize: 30, color: Colors.green)))]));
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

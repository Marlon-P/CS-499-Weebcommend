import 'dart:ui';
import 'package:built_collection/built_collection.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/home.dart';
import 'package:weeb_app/gridview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



//this is actually the screen for both search bars (recommendation and regular)
class RegSearchBarScreen extends StatefulWidget {
  String text;
  String searchMode;
  List<String> animeTitles;


  RegSearchBarScreen(String text, String searchMode, List<String> animeTitles) {
    this.text = text;
    this.searchMode = searchMode; //searchMode toggles from default to recommendation
    this.animeTitles = animeTitles;
  }

  @override
  _RegSearchBarScreenState createState() =>
      _RegSearchBarScreenState(text, searchMode, animeTitles);
}

class _RegSearchBarScreenState extends State<RegSearchBarScreen> {
  String title;
  Jikan jikan;
  List animes;
  String searchMode;
  String hintText;
  List<String> animeTitles;
  List<AnimeThumbNails> apics;


  _RegSearchBarScreenState(String title, String searchMode, List<String> animeTitles) {
    this.title = title;
    this.jikan = new Jikan();
    this.animes = new List();
    this.animeTitles = animeTitles;
    this.searchMode = searchMode; //default search mode, searches for the anime title inputted and gives the anime info related to the title, no recommendations given
    if (this.searchMode == 'default') {
      this.hintText = 'Lookup an Anime';
    } else {
      this.hintText = 'Search for a Recommendation';
    }
  }




  @override
  void initState() {

    super.initState();
  }

  Future<List<dynamic>> setTitle(String text) async {
    //allows user to search for another title, based on searchMode it will be a recommendation or a regular search
    setState(() {
      if (this.searchMode == 'default') {
        this.hintText = 'Search for an Anime';
      } else {
        this.hintText = 'Search for a Recommendation';
      }
      this.title = text;
    });
    return new List<dynamic>();
  }

  Future<BuiltList<dynamic>> createAnimeList() async {
    //returns the list of anime objects that the user wants (search results or recommendations)

    var search = await jikan.search(title, SearchType.anime);

    if (this.searchMode == 'recommend') {
      //if the search mode is recommend, then this function will return a BuiltList of Recommendation objects, otherwise return list of search objects
      return await jikan.getAnimeRecommendations(search[0].malId);
    }

    return search;
  }

  List<AnimeThumbNails> createAnimeThumbNails(BuiltList<dynamic> results) {
    List<AnimeThumbNails> atns = new List<AnimeThumbNails>();
    if(results.isNotEmpty) {
      var temp = results[0];
      if (temp is Search) {
        results.forEach((element) {
          atns.add(new AnimeThumbNails.search_rec(element, null));
        });
      } else if (temp is Recommendation) {
        results.forEach((element) {
          atns.add(new AnimeThumbNails.search_rec(null, element));
        });
      } else {}
    }
    return atns;
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(

        appBar: AppBar(
          title: Text(this.title),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: ()   {
                  showSearch(
                      context: context,
                      delegate: AutoSearchBar(animeTitles, false, searchMode),
                      query: ''

                  );

                }
            )
          ],
        ),
        body: SafeArea(
          child: Wrap(
            children: [

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,

                child: FutureBuilder<BuiltList<dynamic>>(
                    future: createAnimeList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<BuiltList<dynamic>> results) {

                      if (results.hasData) {
                        List<AnimeThumbNails> atn =
                        createAnimeThumbNails(results.data);
                        apics = atn;
                        if (atn != null && atn.isNotEmpty) {
                          return DisplayResultGrid(atn);
                        } else {
                          return Center(child: Column(children: <Widget>[Icon(Icons.block, size: 100,), Text("NO RESULTS",style: TextStyle(fontSize: 100),)]));
                        }
                      } else if (results.hasError) {
                        return Center(child: Column(children: <Widget>[Icon(Icons.signal_wifi_off, size: 100,), Text("NO WIFI OR API ERROR",style: TextStyle(fontSize: 100),)]));
                      } else {
                        return Center(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitFadingCube(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('loading'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }


                    }),
              )
            ],
          ),
        ));
  }
}

class AutoSearchBar extends SearchDelegate {

  List<String> titles;
  bool isHomeScreen = false;
  String searchMode;

  AutoSearchBar(this.titles, this.isHomeScreen, this.searchMode);

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (query != null) {
            close(context, null);
          }
        }
    );

  }


  @override
  void showResults(BuildContext context) {

    close(context, query);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            RegSearchBarScreen(query, searchMode, titles)));
  }
  @override
  Widget buildResults(BuildContext context) {

    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    var suggestions;
    if (query.isNotEmpty) {


      suggestions = titles.where((e) => e.toLowerCase().contains(query.toLowerCase()) && e.toLowerCase().startsWith(query.toLowerCase())).toList();

    } else {
      suggestions = [];
    }

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (_, i) {

          var noun = suggestions[i];
          return ListTile(
              title: Text(noun),
              onTap: () {
                query = noun;
                showResults(context);



              }
          );
        }
    );
  }

}
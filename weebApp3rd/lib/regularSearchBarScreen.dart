import 'dart:ui';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:built_collection/built_collection.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/bodyforhomescreen.dart';
import 'package:weeb_app/gridview.dart';




//this is actually the screen for both search bars (recommendation and regular)
class RegSearchBarScreen extends StatefulWidget {


  String text;
  String searchMode;


  RegSearchBarScreen(String text, String searchMode) {
    this.text = text;
    this.searchMode = searchMode;//searchMode toggles from default to recommendation
  }

  @override
  _RegSearchBarScreenState createState() => _RegSearchBarScreenState(text, searchMode);


}


class _RegSearchBarScreenState extends State<RegSearchBarScreen> {

  String title;
  Jikan jikan;
  List animes;
  String searchMode;
  String hintText;

  _RegSearchBarScreenState(String title, String searchMode) {
    this.title = title;
    this.jikan = new Jikan();
    this.animes = new List();
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

  Future<List<dynamic>> setTitle(String text) async{//allows user to search for another title, based on searchMode it will be a recommendation or a regular search
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

  Future<BuiltList<dynamic>> createAnimeList() async {//returns the list of anime objects that the user wants (search results or recommendations)

    var search = await jikan.search(title, SearchType.anime);


    if (this.searchMode == 'recommend') {//if the search mode is recommend, then this function will return a BuiltList of Recommendatio objects, otherwise return list of search objects
      return await jikan.getAnimeRecommendations(search[0].malId);
    }


    return search;
  }

  List<AnimeThumbNails> createAnimeThumbNails(BuiltList<dynamic> results) {
    List<AnimeThumbNails> atns = new List<AnimeThumbNails>();
    var temp = results[0];
    if (temp is Search) {

      results.forEach((element) {atns.add(new AnimeThumbNails.search_rec(element, null));});


    } else if (temp is Recommendation) {

      results.forEach((element) {atns.add(new AnimeThumbNails.search_rec(null, element));});

    } else {

    }

    return atns;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Wrap (

          children: [
            Container (
                height: 80.0,
                child: SearchBar(
                  onSearch: setTitle,
                  onItemFound: null,
                  textStyle: TextStyle(color: Colors.white),
                  hintText: this.hintText,
                 )
            ),
            Container(

              height: MediaQuery.of(context).size.height - 80,
              width:  MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
              child: FutureBuilder<BuiltList<dynamic>>(

                  future: createAnimeList(),
                  builder: (BuildContext context, AsyncSnapshot<BuiltList<dynamic>> results) {
                    List<Widget> children;
                    if (results.hasData) {

                      List<AnimeThumbNails> atn = createAnimeThumbNails(results.data);
                      if (atn != null) {
                        return DisplayResultGrid(atn);
                      } else {
                        return DisplayResultGrid(buildList());
                      }

                    } else if (results.hasError) {

                      children = <Widget> [

                        Expanded(
                          child: Text('Result: not found', style: TextStyle(color: Colors.white),),
                        )

                      ];
                    } else  {
                      return Center(
                          child: Text(
                            'Searching database',
                            style: TextStyle(color: Colors.white),
                          )
                      );

                    };
                    return Center(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),

                    );
                  }
              ),

            )
          ],
        )

    );
  }
}


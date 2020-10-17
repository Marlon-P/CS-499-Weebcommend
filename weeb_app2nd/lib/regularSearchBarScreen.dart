import 'dart:ui';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:built_collection/built_collection.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class RegSearchBarScreen extends StatefulWidget {


  String text;

  RegSearchBarScreen(String text) {
    this.text = text;
  }

  @override
  _RegSearchBarScreenState createState() => _RegSearchBarScreenState(text);


}


class _RegSearchBarScreenState extends State<RegSearchBarScreen> {

  String title;
  Jikan jikan;
  List animes;

  _RegSearchBarScreenState(String title) {
    this.title = title;
    this.jikan = new Jikan();
    this.animes = new List();

  }

  @override
  void initState() {
    super.initState();

  }

  Future<BuiltList<Search>> createAnimeList() async {

    var search = await jikan.search(title, SearchType.anime);

    return search;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container (
            height: 80.0,
            child: SearchBar(
              onSearch: null,
              onItemFound: null,
              textStyle: TextStyle(color: Colors.white),
              hintText: this.title,
            )
          ),
          Container(


            child: FutureBuilder<BuiltList<Search>>(

                future: createAnimeList(),
                builder: (BuildContext context, AsyncSnapshot<BuiltList<Search>> results) {
                  List<Widget> children;
                  if (results.hasData) {

                    return Center(
                        child: Text(
                          'data found',
                          style: TextStyle(color: Colors.white),
                        )
                    );

                  } else if (results.hasError) {

                    children = <Widget> [

                      Expanded(
                        child: Text('Result: not found', style: TextStyle(color: Colors.white),),
                      )

                    ];
                  } else  {

                    children = <Widget> [
                      Expanded (
                        child: Text(
                          'Result: searching...',
                          style: TextStyle(color: Colors.white),
                        ),
                      )];
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


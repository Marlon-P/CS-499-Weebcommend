import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchBar extends StatefulWidget {

  var context;
  String route;

  SearchBar(var context, String route) {
    this.context = context;
    this.route = route;
  }

  @override
  _SearchBarState createState() => _SearchBarState(this.context, this.route);
}

class _SearchBarState extends State<SearchBar> {

  var context;
  String route;
  String desc;

  _SearchBarState(var context, String route) {
    this.context = context;
    this.route = route;
    this.desc = 'Not found';

  }

  //changes input from let's say 'attack on titan' to 'attack/on/titan' for proper query
  String input(String text) {

    return text.replaceAll(' ', '/');
  }


  void getAnimeInfo(String title) async {

    title = input(title);

    //query jikan for the inputted title
    Response response = await get(
        'https://api.jikan.moe/v3/search/anime?q=' + title + '&page=1'
    );
    Map data = jsonDecode(response.body);
    List<dynamic> results = data['results'];

    await setState(() {

      this.desc = results[1]['synopsis'];

    });



  }

  @override
  void initState() {
    super.initState();

  }

  //this takes in the inputted text
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 5.0),
                  ),
                  fillColor: Colors.black45,
                  hintText: 'Search for an anime',
                  hintStyle: TextStyle(color: Colors.grey[600])
              ),
              onSubmitted: (Text) {
                getAnimeInfo(Text);



                Navigator.pushNamed(
                    this.context,
                    AnimeResults.routeName,
                    arguments: Arguments(Text, this.desc)
                );

              },
              textInputAction: TextInputAction.search,
            )
        )
    );

  }


}



//arguments to be passed to Navigator.pushNamed function, the argument would be the text inputted by the user in the search box
class Arguments {

  final String input;
  final String description;

  Arguments(this.input, this.description);
}

//this widget takes in the input from the text and opens a new screen that will display the data from the api
class AnimeResults extends StatelessWidget {

  static const routeName = '/AnimeResults';

  @override
  Widget build(BuildContext context) {

    final Arguments args = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text(args.input),

      ),
      body: Text(args.description),

    );

  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Future no;
List<String> why;

  @override
  void initState(){
    no = getData();
    no.then((value) => why = value);
    super.initState();


  }

  Future<List<String>> getData() async {
    Response response = await get(
        'https://api.jikan.moe/v3/search/anime?status=airing&order_by=members');
    Map data = jsonDecode(response.body);
    List<dynamic> yes = data['results'];
    List<String> temp = [];
    yes.forEach((element) => temp.add(element['image_url']));
    return temp;
  }


  void makeGenreQuery(String value) async {
    String svalue;
    switch(value){
      case 'action' : svalue = '1'; break;
      case 'adventure' : svalue = '2'; break;
      case 'cars' : svalue = '3'; break;
      case 'comedy' : svalue = '4'; break;
      case 'dementia' : svalue = '5'; break;
      case 'demons' : svalue = '6'; break;
      case 'mystery' : svalue = '7'; break;
      case 'drama' : svalue = '8'; break;
      case 'ecchi' : svalue = '9'; break;
      case 'fantasy' : svalue = '10'; break;
      case 'game' : svalue = '11'; break;
      case 'hentai' : svalue = '12'; break;
      case 'historical' : svalue = '13'; break;
      case 'horror' : svalue = '14'; break;
      case 'kids' : svalue = '15'; break;
      case 'magic' : svalue = '16'; break;
      case 'martial arts' : svalue = '17'; break;
      case 'mecha' : svalue = '18'; break;
      case 'music' : svalue = '19'; break;
      case 'parody' : svalue = '20'; break;
      case 'samurai' : svalue = '21'; break;
      case 'romance' : svalue = '22'; break;
      case 'school' : svalue = '23'; break;
      case 'sci fi' : svalue = '24'; break;
      case 'shoujo' : svalue = '25'; break;
      case 'shoujo ai' : svalue = '26'; break;
      case 'shounen' : svalue = '27'; break;
      case 'shounen ai' : svalue = '28'; break;
      case 'space' : svalue = '29'; break;
      case 'sports' : svalue = '30'; break;
      case 'super power' : svalue = '31'; break;
      case 'vampire' : svalue = '32'; break;
      case 'yaoi' : svalue = '33'; break;
      case 'yuri' : svalue = '34'; break;
      case 'harem' : svalue = '35'; break;
      case 'slice of life' : svalue = '36'; break;
      case 'supernatural' : svalue = '37'; break;
      case 'military' : svalue = '38'; break;
      case 'police' : svalue = '39'; break;
      case 'psychological' : svalue = '40'; break;
      case 'thriller' : svalue = '41'; break;
      case 'seinen' : svalue = '42'; break;
      case 'josei' : svalue = '43'; break;
    }
    Response response = await get(
        'https://api.jikan.moe/v3/search/anime?genre=' + svalue);
    Map data = jsonDecode(response.body);
    List<dynamic> yes = data['results'];
    List<String> temp = [];
    yes.forEach((element) => temp.add(element['image_url']));
    setState(() {
      why = temp;
    });
  }

    @override
    Widget build(BuildContext context) {
      return
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[233],
            title: Dropdown(makeGenreQuery),
          ),
            body: Container(
          child: FutureBuilder(
            future: no,
            builder: (context,snapshot){
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none: return Text('none');
                  case ConnectionState.done: return Scaffold(
                    body: Container(
                        child: ListView(children: why.map((e) => Image.network(e)).toList())
                  ));
                  default: return Text('loading');
                }
            }
          )
        ));
    }



}



class Dropdown extends StatefulWidget {

  final Function selectGenre;
  const Dropdown(this.selectGenre);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {

  String x = 'genre';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: x,
      onChanged: (String newValue){setState(() {
        x = newValue;
      });
      widget.selectGenre(x);
      },
      items: <String>['genre','action','adventure','cars','comedy','dementia','demons','mystery','drama','ecchi','fantasy','game','hentai','historical','horror','kids','magic','martial arts','mecha','music','parody','samurai','romance','school','sci fi','shoujo','shoujo ai','shounen','shounen ai','space','sports','super power','vampire','yaoi','yuri','harem','slice of life','supernatural','military','police','psychological','thriller','seinen','josei'].map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(value: value, child: Text(value));}).toList()
    );
  }
}







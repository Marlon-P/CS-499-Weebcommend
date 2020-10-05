import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'Dropdown.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Future initialAnimeList;
List<String> animeList;
Map<String,String> genreFilterList = Map<String,String>();
Map<String,String> seasonFilterList = Map<String,String>();
Map<String,String> yearFilterList = Map<String,String>();
Map<String,String> typeFilterList = Map<String,String>();


  @override
  void initState(){
    initialAnimeList = getData();
    initialAnimeList.then((value) => animeList = value);
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



  String createQueryString(String genreValue, bool filteringGenre){
    String queryString = 'https://api.jikan.moe/v3/search/anime?';
    if(genreFilterList.isNotEmpty && filteringGenre)
    {
      queryString = queryString + 'genre=' + genreFilterList[genreValue] + '&';
      //genreFilterList.forEach((key, value) {queryString = queryString + value + '&';});
    }
    if(typeFilterList.isNotEmpty)
    {
      queryString = queryString + 'type=';
      typeFilterList.forEach((key, value) {queryString = queryString + value + '&';});
    }
    if(seasonFilterList.isNotEmpty && yearFilterList.isEmpty)
    {
      final now = new DateTime.now();
      String current = now.year.toString();
      List<String> splitter = seasonFilterList['season'].split('|');
      queryString = queryString + 'start_date=' + current + '-' + splitter[0] + '&end_date=' + current + '-' + splitter[1] + '&';
    }
    if(seasonFilterList.isEmpty && yearFilterList.isNotEmpty)
    {
      queryString = queryString + 'start_date=' + yearFilterList['year'] + '-01-01&end_date=' + yearFilterList['year'] + '-12-31&';
    }
    if(seasonFilterList.isNotEmpty && yearFilterList.isNotEmpty)
    {
      List<String> splitter = seasonFilterList['season'].split('|');
      queryString = queryString + 'start_date=' + yearFilterList['year'] + '-' + splitter[0] + '&end_date=' + yearFilterList['year'] + splitter[1] + '&';
    }
    if(genreFilterList.isEmpty && seasonFilterList.isEmpty && yearFilterList.isEmpty && typeFilterList.isEmpty){
      queryString = 'https://api.jikan.moe/v3/search/anime?status=airing&order_by=members';
    }
    print(queryString);
    return queryString;
  }

  Future<List<String>> executeFiltering(bool filterGenre) async{

    List<String> tempAnimeList = [];
    if(genreFilterList.isEmpty || !filterGenre)
      {
        Response response = await get(createQueryString('whatever',false));
        Map data = jsonDecode(response.body);
        List<dynamic> yes = data['results'];
        yes.forEach((element) => tempAnimeList.add(element['image_url']));
      }
    else{
    List<List<String>> list = genreFilterList.entries.map((e) => <String>[e.key,e.value]).toList();
    Response response = await get(createQueryString(list[0][0],true));
    Map data = jsonDecode(response.body);
    List<dynamic> yes = data['results'];
    yes.forEach((element) => tempAnimeList.add(element['image_url']));

    if(genreFilterList.length > 1){
    await Future.forEach(genreFilterList.entries, (element) async {
      List<String> tempAnimeList2 = [];
    Response response = await get(createQueryString(element.key,true));
    Map data = jsonDecode(response.body);
    List<dynamic> yes = data['results'];
    yes.forEach((element) => tempAnimeList2.add(element['image_url']));
    tempAnimeList.removeWhere((element) => !tempAnimeList2.contains(element));
    });}
    }
    return tempAnimeList;
  }


  void makeGenreQuery(String value, String dropDownType, bool addOrRemove) async {
    String svalue;
    switch(dropDownType){
      case 'genre' : {
        switch(value){
          case 'genre' : svalue = 'genre'; break;
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
      }} break;
      case 'season' : { switch(value)
        {
          case 'season' : svalue = 'season'; break;
          case 'winter' : svalue = '01-01|03-31'; break;
          case 'spring' : svalue = '04-01|06-30'; break;
          case 'fall' : svalue = '10-01|12-31'; break;
          case 'summer' : svalue = '07-01|09-30'; break;}}
          break;

      case 'year' : {svalue = value;} break;
      case 'type' : {svalue = value;} break;
     }

     switch(dropDownType){
      case 'genre' : {
        if(svalue == 'genre')
          {
            Map<String,String> resetList = Map<String,String>();
            Future tempAnimeList;
            tempAnimeList = executeFiltering(false);
            tempAnimeList.then((value) => {  setState(() {
              genreFilterList = resetList;
              animeList = value;
            })});
          }


        else{
        Map<String,String> temp = genreFilterList;
        (addOrRemove) ? temp.putIfAbsent(value, () => svalue) : temp.remove(value);
        Future tempAnimeList;
        tempAnimeList = executeFiltering(true);
        tempAnimeList.then((value) => {  setState(() {
        genreFilterList = temp;
        animeList = value;
        })});
      }
      }
      break;

      case 'season' : {

        if(svalue == 'season')
        {
          Map<String,String> resetList = Map<String,String>();
          Future tempAnimeList;
          tempAnimeList = executeFiltering(true);
          tempAnimeList.then((value) => {  setState(() {
            seasonFilterList = resetList;
            animeList = value;
          })});
        }


        else{
        Map<String,String> temp = seasonFilterList;
        if(seasonFilterList.isNotEmpty){(addOrRemove) ? temp[dropDownType] = value : temp.remove(dropDownType);}
        else {temp.putIfAbsent(dropDownType, () => value);}
        Future tempAnimeList;
        tempAnimeList = executeFiltering(true);
        tempAnimeList.then((value) => {  setState(() {
          seasonFilterList = temp;
          animeList = value;
        })});}
      }
      break;

      case 'year' : {

        if(svalue == 'year')
        {
          Map<String,String> resetList = Map<String,String>();
          Future tempAnimeList;
          tempAnimeList = executeFiltering(true);
          tempAnimeList.then((value) => {  setState(() {
            yearFilterList = resetList;
            animeList = value;
          })});
        }

        else{
        Map<String,String> temp = yearFilterList;
        if(yearFilterList.isNotEmpty) {(addOrRemove) ? temp[dropDownType] = value : temp.remove(dropDownType);}
        else {temp.putIfAbsent(dropDownType, () => value);}
        Future tempAnimeList;
        tempAnimeList = executeFiltering(true);
        tempAnimeList.then((value) => {  setState(() {
          yearFilterList = temp;
          animeList = value;
        })});}
      }
      break;

      case 'type' : {

        if(svalue == 'type')
        {
          Map<String,String> resetList = Map<String,String>();
          Future tempAnimeList;
          tempAnimeList = executeFiltering(true);
          tempAnimeList.then((value) => {  setState(() {
            typeFilterList = resetList;
            animeList = value;
          })});
        }

        else{
        Map<String,String> temp = typeFilterList;
        if(typeFilterList.isNotEmpty) {(addOrRemove) ? temp[dropDownType] = value : temp.remove(dropDownType);}
        else {temp.putIfAbsent(dropDownType, () => value);}
        Future tempAnimeList;
        tempAnimeList = executeFiltering(true);
        tempAnimeList.then((value) => { setState(() {
          typeFilterList = temp;
          animeList = value;
        })});}
      }
      break;
    }
  }

  List<Widget> renderFilters(){
    List<Widget> tempList = [];
    if(genreFilterList.isNotEmpty){tempList = genreFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'genre', false);}, child: Text(e.key))).toList();}
    if(typeFilterList.isNotEmpty){tempList = tempList + typeFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'type', false);}, child: Text(e.key))).toList();}
    if(seasonFilterList.isNotEmpty){tempList = tempList + seasonFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'season', false);}, child: Text(e.key),)).toList();}
    if(yearFilterList.isNotEmpty) {tempList = tempList + yearFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'year', false);}, child: Text(e.key))).toList();}
    return tempList;
  }


    @override
    Widget build(BuildContext context) {
      return
        Scaffold(
          appBar: PreferredSize( preferredSize: Size.fromHeight(100.0),child: AppBar(
            backgroundColor: Colors.blue[233],
            title: ListView(shrinkWrap: true, children: <Widget>[

                    Row(
                        children: <Widget>[
                          Dropdown(makeGenreQuery,<String>['genre','action','adventure','cars','comedy','dementia','demons','mystery','drama','ecchi','fantasy','game','hentai','historical','horror','kids','magic','martial arts','mecha','music','parody','samurai','romance','school','sci fi','shoujo','shoujo ai','shounen','shounen ai','space','sports','super power','vampire','yaoi','yuri','harem','slice of life','supernatural','military','police','psychological','thriller','seinen','josei'],'genre','genre'),
                          Dropdown(makeGenreQuery,<String>['season','winter','spring','fall','summer'],'season','season'),
                          Dropdown(makeGenreQuery,<String>['type','tv','ova','movie','special','ona','music'],'type','type'),
                          Dropdown(makeGenreQuery,<String>['year','2022','2021','2020','2019','2018','2017','2016','2015','2014','2013','2012','2011','2010','2009','2008','2007','2006','2005','2004','2003','2002','2001','2000'],'year','year')
                                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                      ),
            //

               ]),
              bottom: PreferredSize(child: Expanded(child: ListView(scrollDirection: Axis.horizontal, children: renderFilters()))),
            )),
            //Row(
                 // children: filterList.map((e) => FlatButton(onPressed: (){},  child: Text(e, overflow: TextOverflow.fade, style: TextStyle(fontSize: 12)))).toList(),
                 // mainAxisAlignment: MainAxisAlignment.start,
                 //   ),
            body: Container(
          child: FutureBuilder(
            future: initialAnimeList,
            builder: (context,snapshot){
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none: return Text('none');
                  case ConnectionState.done: return Scaffold(
                    body: Container(
                        child: ListView(children: animeList.map((e) => Image.network(e)).toList())
                  ));
                  default: return Text('loading');
                }
            }
          )
        ));
    }
}

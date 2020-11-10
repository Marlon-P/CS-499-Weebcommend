import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'Dropdown.dart';
import 'home.dart';
import 'gridview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class filters extends StatefulWidget {

  String initSearch;
  filters(this.initSearch);
  @override
  _filtersState createState() => _filtersState();
}

class _filtersState extends State<filters> {
  @override
  void setState(fn)
  {
    if(mounted)
    {
      super.setState(fn);
    }
  }


  Map<String,String> genreFilterList = Map<String,String>();
  Map<String,String> seasonFilterList = Map<String,String>();
  Map<String,String> yearFilterList = Map<String,String>();
  Map<String,String> typeFilterList = Map<String,String>();
  List<List<String>> dropDownList = [['genre','action','adventure','cars','comedy','dementia','demons','drama','ecchi','fantasy','game','harem','hentai','historical','horror','josei','kids','magic','martial arts','mecha','military','music','mystery','parody','police','psychological','romance','samurai','school','sci fi','seinen','shoujo ai','shoujo','shounen ai','shounen','slice of life','space','sports','super power','supernatural','thriller','vampire','yaoi','yuri'],['season','winter','spring','fall','summer'],['type','tv','ova','movie','special','ona','music'],['year','2022','2021','2020','2019','2018','2017','2016','2015','2014','2013','2012','2011','2010','2009','2008','2007','2006','2005','2004','2003','2002','2001','2000']];


  List<List<AnimeThumbNails>> pageList = [];
  bool isConnected = true;
  bool noResults = false;
  bool stopPageFetch = false;
  PageController _controller = PageController(initialPage: 0);


  final textController = TextEditingController();
  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }


  @override
  void initState(){
    super.initState();
    makeGenreQuery(widget.initSearch, 'genre', true);
    go();
  }


////////////////////////////////////////////////////FOR PAGES///////////////////////////////////////////////////////////
  Future<List<AnimeThumbNails>> getNextPage(String isSearching, int pageNum) async{
    print (pageList.length);
    Map data;
    try {Response response = await get(
        isSearching + "page=" + (pageList.length + 1).toString());
    data = jsonDecode(response.body);
    if(!isConnected)
      {
        setState(() {isConnected = true;});
      }
    }
    catch(e){
      print(e);
      if(isConnected)
      {setState(() {isConnected = false;});}
      return null;
    }
    List<AnimeThumbNails> temp = [];
    List<dynamic> yes = data['results'];
    if(yes.isNotEmpty)
    {yes.forEach((element) => temp.add(AnimeThumbNails(element['image_url'], element['title'],element['mal_id'], cache: true, height: 250)));
    if(noResults) {setState(() {noResults = false;});}
    }
    else {if(!noResults){setState(() {noResults = true;});}}
    return temp;
  }

  void renderPagesStart(String isSearching, int pageNum) async {
    if(!stopPageFetch)
    {Future totalPages;
    Future.delayed(const Duration(seconds: 1),(){
      totalPages = getNextPage(isSearching, pageNum);
      if (!stopPageFetch)
      {totalPages.then((value) => (value != null) ? renderPagesEnd(value, isSearching, pageNum) : print("No internet or No results"));}

    });}}

  void renderPagesEnd(List<AnimeThumbNails> isNotFinalPage, String isSearching, int pageNum)
  {
    if(isNotFinalPage.isNotEmpty && !stopPageFetch)
    {
      //List<AnimeThumbNails> tempList = pageList;
      List<List<AnimeThumbNails>> tempList = pageList;
      //tempList = tempList + isNotFinalPage;
      tempList.add(isNotFinalPage);
      setState(() {
        pageList = tempList;
        renderPagesStart(isSearching, pageNum + 1);
      });
    }
  }

  List<Widget> renderPageList()
  {
    List<Widget> tempList = [];
    if(pageList.isNotEmpty){
      for(int i = 1; i <= pageList.length; i++)
      {
        tempList.add(FlatButton(onPressed: (){_controller.jumpToPage(i-1);
        }, child: Text(i.toString())));
      }
    }
    return tempList;
  }

  void stopPageFetching()
  {
    setState(() {
      stopPageFetch = !stopPageFetch;
    });
    //List<AnimeThumbNails> tempPageList = pageList;
    List<List<AnimeThumbNails>> tempPageList = pageList;
    tempPageList.clear();
  }

  List<Widget> renderPageView(){
    List<Widget> tempList = [];
    for(int i = 0; i < pageList.length; i++)
    {
      tempList.add(DisplayResultGrid(pageList[i]));
    }
    return tempList;
  }
////////////////////////////////////////////FOR PAGES///////////////////////////////////////////////////////////////////
  String createQueryString(){
    String queryString = 'https://api.jikan.moe/v3/search/anime?';
    if (genreFilterList.isNotEmpty) {
      queryString = queryString + 'genre=';
      genreFilterList.forEach((key, value) {
        queryString = queryString + value + ',';
      });
      queryString = queryString + '&';
    }
    if (typeFilterList.isNotEmpty) {
      queryString = queryString + 'type=';
      typeFilterList.forEach((key, value) {
        queryString = queryString + value + '&';
      });
    }
    if (seasonFilterList.isNotEmpty && yearFilterList.isEmpty) {
      final now = new DateTime.now();
      String current = now.year.toString();
      List<String> splitter;
      seasonFilterList.forEach((key, value) {
        splitter = value.split('|');
      });
      queryString =
          queryString + 'start_date=' + current + '-' + splitter[0] +
              '&end_date=' + current + '-' + splitter[1] + '&';
    }
    if (seasonFilterList.isEmpty && yearFilterList.isNotEmpty) {
      queryString = queryString + 'start_date=' + yearFilterList['year'] +
          '-01-01&end_date=' + yearFilterList['year'] + '-12-31&';
    }
    if (seasonFilterList.isNotEmpty && yearFilterList.isNotEmpty) {
      List<String> splitter;
      seasonFilterList.forEach((key, value) {
        splitter = value.split('|');
      });
      queryString =
          queryString + 'start_date=' + yearFilterList['year'] + '-' +
              splitter[0] + '&end_date=' + yearFilterList['year'] + '-' +
              splitter[1] + '&';
    }
    if (genreFilterList.isEmpty && seasonFilterList.isEmpty &&
        yearFilterList.isEmpty && typeFilterList.isEmpty) {
      queryString =
      'https://api.jikan.moe/v3/search/anime?status=airing&order_by=members&';
    }

    print(queryString);
    return queryString;
  }


  void makeGenreQuery(String value, String dropDownType, bool addOrRemove) async {
    String svalue;
    //stopPageFetching();
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

    //Based on whichever dropdown was used to apply the filter, their respective filter list is changed accordingly
    switch(dropDownType){
      case 'genre' : {

        Map<String,String> tempFilterList = genreFilterList;
        //If the default value of genre was called, all genre filters are removed
        if(svalue == 'genre')
        {
          setState(() {tempFilterList.clear(); });
          //  Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});
        }
        else{
          (addOrRemove) ? setState(() {tempFilterList.putIfAbsent(value, () => svalue);}) : setState(() {tempFilterList.remove(value); });
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});
        }
      }
      break;

      case 'season' : {
        Map<String,String> tempFilterList = seasonFilterList;
        if(svalue == 'season')
        {
          setState(() {tempFilterList.clear(); });
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }
        else{
          Map<String,String> tempFilterList = seasonFilterList;
          if(seasonFilterList.isNotEmpty){
            if(addOrRemove) {setState(() {tempFilterList.clear(); tempFilterList[value] = svalue;});} else {setState(() {tempFilterList.remove(value); });}
          }
          else {setState(() {tempFilterList.putIfAbsent(value, () => svalue); });}
          // Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }}
      break;

      case 'year' : {
        Map<String,String> tempFilterList = yearFilterList;
        if(svalue == 'year')
        {
          setState(() {tempFilterList.clear(); });
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }

        else{
          Map<String,String> tempFilterList = yearFilterList;
          if(yearFilterList.isNotEmpty) {(addOrRemove) ? setState(() {tempFilterList[dropDownType] = value;}) : setState(() {tempFilterList.remove(dropDownType);});}
          else {setState(() {tempFilterList.putIfAbsent(dropDownType, () => value); });}
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }}
      break;

      case 'type' : {
        Map<String,String> tempFilterList = typeFilterList;
        if(svalue == 'type')
        {
          setState(() {tempFilterList.clear(); });
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }
        else{
          Map<String,String> tempFilterList = typeFilterList;
          if(typeFilterList.isNotEmpty) {(addOrRemove) ? setState(() {tempFilterList[dropDownType] = value; }) : setState(() {tempFilterList.remove(dropDownType); });}
          else {setState(() {tempFilterList.putIfAbsent(dropDownType, () => value); });}
          //Future.delayed(const Duration(milliseconds: 1000),(){stopPageFetching(); renderPagesStart("");});

        }}
      break;
    }
  }

  void go () {
    stopPageFetching();
    String search = createQueryString();
    Future.delayed(const Duration(milliseconds: 2000),(){stopPageFetching(); renderPagesStart(search,1);});

  }

  Widget renderBox(){
    if(pageList.isNotEmpty)
    {
      return Container(
        //child: DisplayResultGrid(pageList),

          child: Column(children:<Widget>[
            //SizedBox( height: 534, child: PageView(controller: _controller, scrollDirection: Axis.horizontal, pageSnapping: true, children:
            //renderPageView())   ),

            Expanded(child: PageView(controller: _controller, scrollDirection: Axis.horizontal, pageSnapping: true, children:
            renderPageView())),

            SizedBox(height: 25, width: 500, child: ListView(scrollDirection: Axis.horizontal, children: renderPageList())),

          ],
          )
      );
    }
    else if(!isConnected && pageList.isEmpty)
      {
        return Center(child: Column(children: <Widget>[Icon(Icons.signal_wifi_off, size: 100,), Text("NO WIFI",style: TextStyle(fontSize: 100),)]));
      }
    else if(noResults)
      {
        return Center(child: Column(children: <Widget>[Icon(Icons.block, size: 100,), Text("NO RESULTS",style: TextStyle(fontSize: 100),)]));
      }
    else{
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
  }

  List<Widget> renderFilters(){
    List<Widget> tempList = [];
    if(genreFilterList.isNotEmpty){tempList = genreFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'genre', false);}, child: Row(children: <Widget>[Text(e.key), Icon(Icons.clear, color: Colors.white, size: 20)],), shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(20)))).toList();}
    if(typeFilterList.isNotEmpty){tempList = tempList + typeFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'type', false);}, child: Row(children: <Widget> [Text(e.value), Icon(Icons.clear, color: Colors.white, size: 20)],), shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(20)))).toList();}
    if(seasonFilterList.isNotEmpty){tempList = tempList + seasonFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'season', false);}, child: Row(children: <Widget>[Text(e.key), Icon(Icons.clear, color: Colors.white, size: 20)],),shape: RoundedRectangleBorder(side: BorderSide(color: Colors.orange, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(20)))).toList();}
    if(yearFilterList.isNotEmpty) {tempList = tempList + yearFilterList.entries.map((e) => FlatButton(onPressed: (){makeGenreQuery(e.key, 'year', false);}, child: Row(children: <Widget>[Text(e.value), Icon(Icons.clear, color: Colors.white, size: 20)]),shape: RoundedRectangleBorder(side: BorderSide(color: Colors.green, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(20)))).toList();}
    return tempList;
  }

  List<Widget> renderDropDowns() {
    List<Widget> tempList = [];
    for (int i = 0; i < dropDownList.length; i++)
    {
      if(!stopPageFetch)
      {tempList.add(Dropdown(makeGenreQuery,dropDownList[i],dropDownList[i][0],dropDownList[i][0]));}
      else
      {tempList.add(Dropdown(makeGenreQuery,dropDownList[i],dropDownList[i][0],dropDownList[i][0]));}
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(appBar:PreferredSize( preferredSize: Size.fromHeight(100.0), child:
      AppBar( automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[233],
        title: Row(children: <Widget>[Expanded(child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),)), Row(children: renderDropDowns(),)])
        ,

        bottom:
        PreferredSize(child: Expanded(child: Row(children:<Widget> [Flexible (child: ListView(scrollDirection: Axis.horizontal, children: renderFilters())), FlatButton(onPressed: (stopPageFetch) ? null : (){go();}, child: Text('GO'), color: Colors.green,)]))),
      )
      )
          ,
          body: renderBox()
        /*
        Container(
          //child: DisplayResultGrid(pageList),

            child: Column(children:<Widget>[
             //SizedBox( height: 534, child: PageView(controller: _controller, scrollDirection: Axis.horizontal, pageSnapping: true, children:
              //renderPageView())   ),

              Expanded(child: PageView(controller: _controller, scrollDirection: Axis.horizontal, pageSnapping: true, children:
              renderPageView())),

              SizedBox(height: 25, width: 500, child: ListView(scrollDirection: Axis.horizontal, children: renderPageList())),

            ],
            )
        ),

        */
      );
  }
}


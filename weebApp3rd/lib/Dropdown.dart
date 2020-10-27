import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {

  Function selectGenre; //this calls the makeGenreQuery function. Aka the function that applies or removes a filter and begins the process. Should probably be renamed to makeQuery instead
  List<String> theList; //the list of values this dropdown has
  String def; //the default value of this dropdown (genre,season,year,type). When it is changed, it is used as the parameter value for makeGenreQuery function.
  String dropDownType; //What type of dropdown this is (genre,season,year,type). Can't use def because that'll be changed.
  Dropdown(this.selectGenre,this.theList,this.def,this.dropDownType);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: widget.def,
        onChanged: (String newValue){setState(() {
          widget.def = newValue;
        });
        widget.selectGenre(widget.def,widget.dropDownType,true);
        },
        items: widget.theList.map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontSize: 13) ),);}).toList());
  }
}

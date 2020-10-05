import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {

    Function selectGenre;
    List<String> theList;
    String def;
    String dropDownType;
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
        //widget.addFilter(widget.def);
        },
        items: widget.theList.map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(value: value, child: Text(value),);}).toList());
  }
}

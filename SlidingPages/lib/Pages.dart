import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Pages extends StatefulWidget {



  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
    );
  }
}

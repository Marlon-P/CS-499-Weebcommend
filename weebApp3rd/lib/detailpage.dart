import 'package:flutter/material.dart';
import 'detailbody.dart';

class DetailPage extends StatelessWidget {
  int malID;
  DetailPage(this.malID);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: DetailBody(malID),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'detailbody.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
        ),
        body: DetailBody(),
      ),
    );
  }
}

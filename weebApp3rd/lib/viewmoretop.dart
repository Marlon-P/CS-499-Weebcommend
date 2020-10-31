import 'package:flutter/material.dart';
import 'gridview.dart';

class ViewMore extends StatelessWidget {
  ViewMore(this.toptype, this.gridviewContent);
  String toptype;
  List gridviewContent = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top $toptype'),
      ),
      body: DisplayResultGrid(gridviewContent),
    );
  }
}

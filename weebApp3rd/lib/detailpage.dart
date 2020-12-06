import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detailbody.dart';
import 'services/auth.dart';

class DetailPage extends StatefulWidget {

  int malID;
  DetailPage(this.malID);
  @override
  _DetailPageState createState() => _DetailPageState(this.malID);
}

class _DetailPageState extends State<DetailPage> {
  int malID;



  _DetailPageState(this.malID);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().getUser(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
            ),
            body: DetailBody(malID, Provider.of<User>(context)),
          ),
        )
    );
  }




}

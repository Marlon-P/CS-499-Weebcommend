import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:weeb_app/authorizedHome.dart';
import 'package:weeb_app/home.dart';

class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if (user == null) {
      print('user = null');
      return homeweeb();
    } else {
      print('user = true');
     return AuthHome();
    }
  }

}
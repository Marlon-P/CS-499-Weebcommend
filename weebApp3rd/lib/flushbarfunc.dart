import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';


void showFlushBar({@required BuildContext context,@required String text, Color color = Colors.lightBlueAccent}){
  Flushbar(
    icon: Icon(Icons.info_outline,
    color: color,),
    margin: EdgeInsets.only(left: 3,right: 3),
    message: text,
    borderColor: color,
    leftBarIndicatorColor: color,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    duration: Duration(seconds: 3),
  )..show(context);
}
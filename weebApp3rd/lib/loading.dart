import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  String mode;

  Loading(this.mode);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        decoration: BoxDecoration(

            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.indigo[800],
                Colors.indigo[600],
                Colors.indigo[400],
                Colors.deepPurple[400],
              ],
            )
        ),
        child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/2 - 50,
                ),
                SpinKitFadingCircle(
                    color: Colors.cyan,
                    size: 50.0
                ),
                Material(
                  type: MaterialType.transparency,
                  child: Text(this.mode,
                      style: TextStyle(

                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = Colors.white,
                      )),
                ),
              ],
            )
        )



    );
  }

}
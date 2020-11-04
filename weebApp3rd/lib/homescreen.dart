import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:weeb_app/bodyforhomescreen.dart';
import 'package:weeb_app/gridview.dart';
import 'regularSearchBarScreen.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    homeweeb(),

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_currentIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed:() {
            showDialog(
                context: context,
                builder: (BuildContext buildContext) {
                  return Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[800],
                                ),
                                child: Center(
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                                        width: double.infinity,
                                        height: 50.0,
                                        color: Colors.grey,
                                        child: TextField(
                                          controller: new TextEditingController(),
                                          decoration:
                                          InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,

                                              hintText: 'Get a Recommendation',
                                              hintStyle: TextStyle(color: Colors.white)
                                          ),
                                          onSubmitted: (Text) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) {

                                                  return new RegSearchBarScreen(Text, 'recommend');
                                                })
                                            );
                                          },
                                        )
                                    )
                                )
                            )
                          ]
                      )
                  );
                }
            );
          },
          icon: Icon(Icons.search),
          label: Text('Recommendations'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}



// Row TopGenres(String genre, Jikan)

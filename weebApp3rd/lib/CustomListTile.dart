import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/services/auth.dart';
import 'package:weeb_app/signup_page.dart';

import 'login_page.dart';



class CustomListTile extends StatelessWidget {

  IconData icon;
  String text;


  CustomListTile(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.indigoAccent,
        onTap: () async {
          if (text == 'Login') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          } else if (text == 'Sign Up') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignupPage()));
          } else if (text == 'Sign Out'){
            AuthService _auth = AuthService();
            await _auth.signOut();
          } else {

          }
        },
        child: IgnorePointer(
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey
                      )
                  )
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(this.icon),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(this.text, style: TextStyle(fontSize: 14.0),),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              )
          ),
        ),

      ),

    );

  }

}
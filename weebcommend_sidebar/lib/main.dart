import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Container()),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Weebcommend'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                // Code that leads to login page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => (LoginPage())),
                // );
                // Then close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: Text('Sign-up'),
              onTap: () {
                // Code that leads to sign-up page
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

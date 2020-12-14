import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeb_app/services/auth.dart';
import 'package:weeb_app/wrapper.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().getUser(),
      child: MaterialApp(
        title: 'Weebcommend',
        theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.deepPurpleAccent,
            hintColor: Colors.deepPurpleAccent,
            appBarTheme: AppBarTheme(
              color: Colors.deepPurpleAccent,
            )
        ),
        home: Wrapper(),
      ),
    );
  }
}


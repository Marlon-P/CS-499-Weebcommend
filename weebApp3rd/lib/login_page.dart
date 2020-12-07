import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weeb_app/loading.dart';
import 'package:weeb_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  bool obscureText = true;
  String email = '';
  String pass = '';
  String error = '';

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Variable created for email input
    final emailField = TextFormField(
      validator: (val) => val.isEmpty ? 'Enter an email' : null,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onChanged: (val) {
        setState(() => email = val);
      },

    );

    //Variable created for password input
    final passwordField = TextFormField(
      validator: (val) => val.length < 6 ? 'Enter a password greater than 6 characters' : null,
      obscureText: obscureText,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.security),
            onPressed: toggle,
          )
      ),
      onChanged: (val) {
        setState(() => pass = val);
      },
    );

    //Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal.shade600,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () async {

          if (_formKey.currentState.validate()) {

            dynamic result = await _auth.signInWithEmailAndPass(email, pass);
            if (result == null) {
              setState(() {
                error = 'unable to sign in';
                loading = false;
              });
            } else {
              setState(() {
                error = '';
                loading = true;
              });
              Navigator.pop(context);
              print('successfully signed in');
            }
          }
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final errorMessage = Text(
      error,
      style: TextStyle(color: Colors. red, fontSize: 14.0),
    );

    return loading ? Loading('Signing In') : Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Center(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          emailField,
                          SizedBox(
                            height: 25,
                          ),
                          passwordField,
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                    ))
                              ],
                            ),
                          ),
                          errorMessage,
                          loginButton,
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    endIndent: 5,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  child: Text('OR CONNECT WITH:'),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    indent: 5,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xff3b5998),
                                        child: MaterialButton(
                                          minWidth:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          onPressed: () async {
                                            dynamic result = await _auth.signInWithFacebook();
                                            if (result == null) {
                                              setState(() {
                                                error = 'unable to sign in';
                                              });
                                            } else {
                                              setState(() {
                                                error = '';
                                              });
                                              Navigator.pop(context);

                                            }
                                          },
                                          child: Text(
                                            'FACEBOOK',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xffde5246),
                                        child: MaterialButton(
                                          minWidth:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          onPressed: () async{
                                            UserCredential result = await _auth.signInWithGoogle(context);
                                            if (result == null) {
                                              setState(() {
                                                error = 'unable to sign in';
                                              });
                                            } else {


                                              setState(() async {
                                                error = '';


                                              });
                                              Navigator.pop(context);

                                            }
                                          },
                                          child: Text(
                                            'GOOGLE',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


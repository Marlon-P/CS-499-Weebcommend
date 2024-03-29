
import 'package:flutter/material.dart';
import 'package:weeb_app/services/auth.dart';

import 'loading.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();//used for validation

  bool loading = false;
  bool obscureText = true;

  void toggle(){
    setState(() {
      obscureText = !obscureText;
    });
  }

  String email = '';
  String pass = '';
  String error = '';

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
            icon: Icon(Icons.remove_red_eye),
            onPressed: toggle,
          )
      ),
      onChanged: (val) {
        setState(() => pass = val);
      },


    );

    //Login Button
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal.shade600,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () async {
          //if there is an email entered and a pass of 6+ characters long register with
          //those credentials
          if (_formKey.currentState.validate()) {
            dynamic result = await _auth.registerWithEmailAndPass(email, pass);
            if (result == null) {
              setState(() {
                error = 'unable to register using those credentials';
                loading = false;
              });
            } else {
              Navigator.pop(context);

              setState(() async {

                error = '';
                loading = true;



              });


            }
          } else {
            setState(() {
              error = '';
            });
          }

        },
        child: Text(
          'Register',
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

    return loading ? Loading('Registering') : Scaffold(
      appBar: AppBar(
        title: Text('Sign-up Page'),
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
                          SizedBox(
                            height: 25,
                          ),
                          errorMessage,
                          registerButton,
                        ],
                      ),
                    )
                ),
              ),
            ),
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
                    child: Text('OR SIGN UP WITH:'),
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
                                            dynamic result = await _auth.signInWithGoogle(context);
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
      ),
    );
  }
}


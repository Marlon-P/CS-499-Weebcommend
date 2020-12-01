import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Variable created for email input
    final emailField = TextField(
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      controller: emailController,
    );

    //Variable created for password input
    final passwordField = TextField(
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      controller: passController,
    );

    //Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal.shade600,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          //********These 2 are only for testing the textfield string extractor. Delete the 2 print functs before implementing login button!!!******
          // print(emailController.text);
          // print(passController.text);
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

    return Scaffold(
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
                                          MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      onPressed: () {},
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
                                          MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      onPressed: () {},
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

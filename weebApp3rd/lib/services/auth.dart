

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in with email and password
  Future signInWithEmailAndPass(String email, String pass) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //listens to changes in authentication (whether a user is signed in or not)
  Stream<User> getUser() {
    return _auth.authStateChanges();
  }

  //register with email and password

  Future registerWithEmailAndPass(String email, String pass) async{
    try {
       UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
       User user = result.user;
       return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      }catch (e) {
        print(e.toString());
        return null;
      }
  }

  //sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //sign in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  //sign out
  Future signOut() async {
      try {
        return await _auth.signOut();
      }catch (e) {
        print(e.toString());
        return null;
      }
  }
}
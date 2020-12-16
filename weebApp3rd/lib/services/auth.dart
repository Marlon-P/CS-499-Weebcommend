import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],);
  String signInMethod = 'emailPass'; //there are 3 different sign ins (Google sign in, facebook sign in and sign in with email) as well as 3 corresponding signouts

  //sign in with email and password
  Future signInWithEmailAndPass(String email, String pass) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User user = result.user;
      signInMethod = 'emailPass';
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
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'image' : 'https://robohash.org/${email}','username' : email, 'watchlist' : [], 'commentList' : [], 'scoreList': []});
        user.updateProfile(displayName: email, photoURL: 'https://robohash.org/${email}');
      }
      signInMethod = 'email';
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
  Future signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;



      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );



      UserCredential result =  await _auth.signInWithCredential(credential);
      User user = result.user;

      signInMethod = 'google';
      if (user != null) {



        DocumentReference cRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        cRef.get().then((data) async {

        if (!data.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'image': 'https://robohash.org/${user.email}', 'username' : user.email, 'watchlist' : [], 'commentList' : [], 'scoreList': []});  user.updateProfile(displayName: user.email, photoURL: 'https://robohash.org/${user.email}'); print('new user');
        } else {
          print('returning user');
        }

        }) ;
      }


      Navigator.pop(context);
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  //sign in with Facebook
  Future signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final AccessToken faceBookUser = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(faceBookUser.token);

      UserCredential cred =  await _auth.signInWithCredential(facebookAuthCredential);
      User user = cred.user;

      signInMethod = 'facebook';
      if (user != null) {



        DocumentReference dRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        dRef.get().then((data) async {
          if (!data.exists) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'image': 'https://robohash.org/${user.email}', 'username' : user.email, 'watchlist' : [], 'commentList' : [], 'scoreList': []});  user.updateProfile(displayName: user.email, photoURL: 'https://robohash.org/${user.email}'); print('new user');
          } else {
            print('returning user');
            print(user.displayName);
          }
      });}


      return user;
    } catch(e) {
      print(e.toString());
    }
  }

  //sign out
  Future signOut() async {
    try {
      switch (signInMethod) {
        case 'emailPass': _auth.signOut(); break;
        case 'google': googleSignIn.signOut(); break;
      }

    }catch (e) {
      print(e.toString());
      return null;
    }
  }
}



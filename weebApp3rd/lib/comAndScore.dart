import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class comAndScore{
  final int mal_ID;
  comAndScore(this.mal_ID);
  final CollectionReference theDoc = FirebaseFirestore.instance.collection('comments');

  void getDoc() async {
    await theDoc.doc(mal_ID.toString()).get().then((value) => {if(value.exists){print(value.data())}else{theDoc.doc(mal_ID.toString()).set({'comments': [], 'scores': []})}});
  }


  void comment(String userComment, String userID, String userName, String userImage){
    Map tempMap = {'comment': userComment, 'userID': userID, 'userName': userName, 'image': userImage};
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayUnion([tempMap])});
    FirebaseFirestore.instance.collection('users').doc(userID).update({'commentList': FieldValue.arrayUnion([mal_ID.toString()])});
  }

  void deleteComment(String userComment, String userID, String userName, String userImage){
    Map tempMap = {'comment': userComment, 'userID': userID, 'userName': userName, 'image': userImage};
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayRemove([tempMap])});
    FirebaseFirestore.instance.collection('users').doc(userID).update({'commentList': FieldValue.arrayRemove([mal_ID.toString()])});
  }

  void updateComment(String oldComment, String userID, String userName, String userImage, String editedComment){
    Map tempMap = {'comment': oldComment, 'userID': userID, 'userName': userName, 'image': userImage};
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayRemove([tempMap])});
    tempMap['comment'] = editedComment;
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayUnion([tempMap])});
  }

  void Updatescore(String userID, int score, int oldValue, bool newOrUpdate)
  {
    Map tempMap = {'score': score, 'userID': userID};
    Map tempMap2 = {mal_ID.toString() : score};
    Map tempMapOld = {mal_ID.toString() : oldValue};
    if(newOrUpdate)
    {theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayUnion([tempMap])});
    FirebaseFirestore.instance.collection('users').doc(userID).update({'scoreList': FieldValue.arrayUnion([tempMap2])});}
    else
      {
      theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayRemove([{'userID': userID, 'score': oldValue}])});
      theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayUnion([tempMap])});
      FirebaseFirestore.instance.collection('users').doc(userID).update({'scoreList': FieldValue.arrayRemove([tempMapOld])});
      FirebaseFirestore.instance.collection('users').doc(userID).update({'scoreList': FieldValue.arrayUnion([tempMap2])});
    }
  }
}


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


  void comment(String userComment, String userID, String userName){
    Map tempMap = {'comment': userComment, 'userID': userID, 'userName': userName};
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayUnion([tempMap])});
  }

  void deleteComment(String userComment, String userID, String userName){
    Map tempMap = {'comment': userComment, 'userID': userID, 'userName': userName};
    theDoc.doc(mal_ID.toString()).update({'comments': FieldValue.arrayRemove([tempMap])});
  }

  void Updatescore(String userID, int score, int oldValue, bool newOrUpdate)
  {
    Map tempMap = {'score': score, 'userID': userID};
    if(newOrUpdate)
    {theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayUnion([tempMap])});}
    else
      {
      theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayRemove([{'userID': userID, 'score': oldValue}])});
      theDoc.doc(mal_ID.toString()).update({'scores': FieldValue.arrayUnion([tempMap])});
    }
  }
}


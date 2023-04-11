import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Import the firebase_core plugin

final _db = FirebaseFirestore.instance;
List Task = [];

Future getDetailsList() async {
  try {
    await _db.collection('tasks').get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (element.data() != null) {
          Task.add(element.data());
          print(Task);
        }
      });
    });
    return Task;
  } catch (e) {
    print(e.toString());
    return null;
  }
}







/*
task = db.collection("task");
final data1 = <String, dynamic>{
  "tasks": "do hw",
  };

await task.doc("SF").set(data1);
/////////get//////
final docRef = db.collection("task").doc("SF");
docRef.get().then(
  (DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // ...
  },
  onError: (e) => print("Error getting document: $e"),
);
*/
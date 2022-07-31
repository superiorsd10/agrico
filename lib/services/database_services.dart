import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_google/model/todo.dart';

class DatabaseService {
  CollectionReference todosCollection =
  FirebaseFirestore.instance.collection("Todos");

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      "title": title,
      "isComplet": false,
    });
  }

  Future completTask(uid) async {
    await todosCollection.doc(uid).update({"isComplet": true});
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Todo(
        isComplet: e["isComplet"],
        title: e["title"],
        uid: e.id,
      );
    }).toList();
  }

  Stream<List<Todo>> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore as List<Todo> Function(QuerySnapshot<Object?>));
  }
}
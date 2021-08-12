import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final TextStyle topStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class CategoryModel extends StatelessWidget {
  String id;
  String name;

  CategoryModel({
    this.id,
    this.name,
  });

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()["id"];
    name = snapshot.data()["name"];
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<String>> getCategories() async =>
      _firestore.collection("category").get().then((result) {
        List<String> categories = [];
        for (DocumentSnapshot category in result.docs) {
          categories.add(CategoryModel.fromSnapshot(category).name);
        }
        return categories;
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Text(
        name,
        style: topStyle,
      ),
    );
  }
}

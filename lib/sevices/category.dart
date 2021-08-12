import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category.dart';

class CategoryServices {
  String collection = "category";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getCategories() async =>
      _firestore.collection("category").get().then((result) {
        List<String> categories = [];
        for (DocumentSnapshot category in result.docs) {
          categories.add(CategoryModel.fromSnapshot(category).name);
        }
        return categories;
      });
}

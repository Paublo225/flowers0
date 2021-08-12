import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "imageUrl";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const QUANTITY = "quantity";
  static const OPT = "оптовые_цены";

  String _id;
  String _name;
  String _imageUrl;
  String _description;
  String _category;
  //String _brand;
  int _quantity;
  int _price;
  // bool _sale;
  //bool _featured;
  //List _colors;
  // List _sizes;
  List _opt;

  String get id => _id;

  String get name => _name;

  String get imageUrl => _imageUrl;

  //String get brand => _brand;

  String get category => _category;

  String get description => _description;

  int get quantity => _quantity;

  int get price => _price;

  //bool get featured => _featured;

  //bool get sale => _sale;

  //List get colors => _colors;

  //List get sizes => _sizes;
  List get opt => _opt;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION] ?? " ";
    _price = snapshot.data()[PRICE].floor();
    _category = snapshot.data()[CATEGORY];
    _name = snapshot.data()[NAME];
    _imageUrl = snapshot.data()[PICTURE];
    _opt = snapshot.data()[OPT];
  }
}

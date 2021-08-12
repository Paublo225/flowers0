class CartItemModel {
  static const ID = "cartid";
  static const NAME = "name";

  static const PRICE = "summa";
  static const QUANTITY = "kolvo";

  String _id;
  String _name;
  String _image;
  String _productId;
  int _price;
  int _quantity;

  String get id => _id;

  String get name => _name;

  String get image => _image;

  String get productId => _productId;

  int get price => _price;

  int get quantity => _quantity;

  CartItemModel.fromMap(Map data) {
    _id = data[ID];
    _name = data[NAME];
    _quantity = data[QUANTITY];
    _price = data[PRICE];
  }

  Map toMap() => {
        ID: _id,
        NAME: _name,
        PRICE: _price,
        QUANTITY: _quantity,
      };
}

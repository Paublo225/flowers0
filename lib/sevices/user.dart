import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/model/cart.dart';
import 'package:flowers0/model/user.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserInfo inf;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  void addToCart({String userId, CartItemModel cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}  ${inf.displayName}");
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void removeFromCart({String userId, String cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore
        .collection(collection)
        .doc(userId)
        .collection("cart")
        .doc(cartItem);
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}

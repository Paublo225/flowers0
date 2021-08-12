import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/cart/cart.dart';
import 'package:flowers0/provider/user_pr.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'item_screen.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final TextStyle topMenuStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class FlowerItemZ extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String categories;
  String price;
  String description;
  String quantity;

  Map<dynamic, dynamic> opt;
  int qpak;
  int minKolvo;
  PageController page;
  FlowerItemZ({
    this.id,
    this.imageUrl,
    this.title,
    this.categories,
    this.price,
    this.opt,
    this.description,
    this.quantity,
    this.minKolvo,
    this.qpak,
    this.page,
  });

  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": title,
        "price": price,
        "опт": opt,
        "qpak": qpak,
        "мин_кол-во": minKolvo,
        "quantity": quantity,
      };
  _FlowerItemState createState() => new _FlowerItemState();
}

class _FlowerItemState extends State<FlowerItemZ> {
  inistate() {
    super.initState();
    setState(() {});
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _tapped = false;
  Future getDocs() async {
    Future<DocumentSnapshot> querySnapshot =
        _firestore.collection("products").doc("title").get();
    print(querySnapshot);
  }

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  CupertinoTabController _tabController =
      new CupertinoTabController(initialIndex: 1);
  void _doSomething() async {
    await _addToCart(widget.title, widget.id, widget.price, widget.qpak);
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message: "+${widget.qpak} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 1500),
    );
    _btnController.success();

    print("clickedz");
  }

  Future _addToCart(String title, String id, String price, int qpak) {
    int summa = int.parse(price) * qpak;
    print("$title, $id, $price, $qpak, $summa");
    return _usersRef.doc(_user.uid).collection("cart").doc(widget.id).set({
      "name": title,
      "cartid": id,
      "kolvo": qpak,
      "summa": summa,
    });
  }

  getProductsOfCategory(String category) async => _firestore
          .collection("products")
          .where("category", isEqualTo: category)
          .snapshots()
          .listen((data) {
        print(data.docs[0]["name"].toString());
      });
  FlowerItemZ flowerItem;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.page,
      builder: (BuildContext context, Widget widget) {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 150,
              width: Curves.easeInOut.transform(1) *
                  MediaQuery.of(context).size.width,
              child: widget,
            ),
          )
        ]);
      },
      child: GestureDetector(
        onTap: () => showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => FlowerScreen(
              flowersID: widget.id,
              title: widget.title,
              qpak: widget.qpak,
              price: widget.price),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1.0, 3.0),
                      blurRadius: 3.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Hero(
                    tag: "${widget.imageUrl}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: FirebaseImage(
                          widget.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              end: 165.0,
              top: 20.0,
              textDirection: TextDirection.rtl,
              child: Container(
                alignment: Alignment.topLeft,
                //width: 250.0,
                child: Text(
                  widget.title.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    //   color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    /* shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]*/
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.rtl,
              end: 165.0,
              top: 45.0,
              child: Container(
                width: 250.0,
                child: Text(
                  "Доступно: ${widget.quantity} штук",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,

                    /* shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]*/
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.rtl,
              end: 165.0,
              bottom: 25.0,
              child: Container(
                width: 250.0,
                child: Text(
                  "${widget.price} ₽/шт",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    /* shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]*/
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.rtl,
              end: MediaQuery.of(context).size.width - 170,
              bottom: 45.0,
              child: Container(
                  width: 250.0,
                  child: IconButton(
                      onPressed: () async {
                        print("clicked");
                        _btnController.stop();
                      },
                      icon: RoundedLoadingButton(
                        height: 30,
                        width: 30,
                        color: mainColor,
                        successColor: Color(4278249078),
                        child: Icon(Icons.add_outlined),
                        controller: _btnController,
                        onPressed: _doSomething,
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

/*
final List<FlowerItem> flowers = [
  FlowerItem(
    id: "1",
    imageUrl: 'lib/assets/bouquet_PNG8.png',
    title: 'Букет Солнечный',
    categories: 'К празднику',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза 7 дней.',
    count: 2409,
  ),
  FlowerItem(
    id: "2",
    imageUrl: 'lib/assets/букеты_DoV.png',
    title: 'Букет Прелесть',
    categories: 'На свидание',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза 7 дней.',
    count: 3609,
  ),
  FlowerItem(
    id: "3",
    imageUrl: 'lib/assets/bouq_nezh.png',
    title: 'Букет Нежность',
    categories: 'На свидание',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза7 дней.',
    count: 1401,
  ),
];
*/

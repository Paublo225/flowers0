import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helpers/count_widget.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';

// ignore: must_be_immutable
class FlowerScreen extends StatefulWidget {
  String flowersID;
  int indexs;
  String title;
  int qpak;
  String price;
  FlowerScreen(
      {this.flowersID, this.title, this.indexs, this.qpak, this.price});

  @override
  _FlowerScreenState createState() => _FlowerScreenState();
}

class _FlowerScreenState extends State<FlowerScreen>
    with AutomaticKeepAliveClientMixin<FlowerScreen> {
  int count = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;

  int kolvo = 0;
  int summa = 1;

  Future _addToCart() {
    return _usersRef
        .doc(_user.uid)
        .collection("cart")
        .doc(widget.flowersID)
        .set({
      "name": widget.title,
      "cartid": widget.flowersID,
      "kolvo": kolvo == 0 ? widget.qpak : kolvo,
      "summa": summa == 1 ? int.parse(widget.price) * widget.qpak : summa,
    });
  }

  void _successTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message:
            "+${kolvo == 0 ? widget.qpak : kolvo} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 1500),
      onTap: () {
        /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
      },
    );
    //_btnController.success();
    //  print("clicked");
  }

  void _warningTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: null,
        message: "Выберите количество",
      ),
      displayDuration: Duration(milliseconds: 1500),
      onTap: () {
        /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
      },
    );
    //_btnController.error();
    //  print("clicked");
  }

  _bottombtn(int size) {
    return Container(
      height: 100,
      child: Center(
        child: new Container(
            width: MediaQuery.of(context).size.height * 0.4,
            height: 40,
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    //side: BorderSide(color: Colors.black38),
                    // borderRadius: new BorderRadius.circular(30.0)
                    ),
                disabledColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.white,
                onPressed: () async {
                  // print(count);
                  // print(kolvo);
                  /// print(summa);
                  /*  if (size > count) {
                    await _addToCart();

                    _successTop();
                  }*/
                  if (count != 0) {
                    await _addToCart();

                    _successTop();
                  } else {
                    print(count);
                    _warningTop();
                  }
                },
                child: Text("ДОБАВИТЬ В КОРЗИНУ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Avenir next')))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    count = widget.qpak;
    kolvo = widget.qpak;
    summa = int.parse(widget.price) * kolvo;
    super.build(context);
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: mainColor,
          leading: Align(
            alignment: Alignment.bottomCenter,
            child: RawMaterialButton(
              padding: EdgeInsets.all(10.0),
              elevation: 0.0,
              onPressed: () => Navigator.pop(context),
              shape: CircleBorder(),
              fillColor: Colors.white,
              child: Icon(
                CupertinoIcons.back,
                size: 25.0,
                color: Colors.pink[200],
              ),
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26.0),
          ),
        ),
        body: Stack(children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.flowersID).get(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                // Firebase Document Data Map
                Map<String, dynamic> documentData = snapshot.data.data();

                List imageList = documentData['images'];
                List productSizes = documentData['sizes'];
                var _price = int.parse(documentData["price"]);
                var _quantity = int.parse(documentData["quantity"]);
                Map<dynamic, dynamic> _opt = documentData['опт'];
                var _minKolvo = documentData['мин_кол-во'];
                int qpak = documentData['qpak'];

                return Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Center(
                            child: Hero(
                                tag: "assetPath",
                                child: Image(
                                    image:
                                        FirebaseImage(documentData["imageUrl"]),
                                    height: 260.0,
                                    fit: BoxFit.fitHeight))),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 210),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[_priceText(_price)]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, top: 250),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              'В наличии: $_quantity штук',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black38,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),

                    /////Нижняя часть//////////////////////////////////

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              "Описание",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                              height: 60,
                              child: Stack(children: [
                                SingleChildScrollView(
                                    padding: EdgeInsets.only(top: 10, left: 28),
                                    child: _description(
                                        _opt,
                                        _opt.values.toList(),
                                        _opt.keys.toList(),
                                        documentData["description"]))
                              ])),
                          Divider(
                            height: 20,
                            color: Colors.grey,
                            indent: 20,
                            endIndent: 20,
                          ),

                          /////COUNT WIDGET////////
                          Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: CountWidget(
                                quantity: _quantity,
                                count: qpak,
                                optKolvo: _opt.values.toList(),
                                optPrices: _opt.keys.toList(),
                                price: _price,
                                opt: _opt,
                                kolvo: kolvo,
                                onSelected: (size) {
                                  count = size;
                                  kolvo = count;
                                  summa = (_price * kolvo);
                                  print(" MAIN $_price");
                                },
                                onSelected1: (size) {
                                  count = size;
                                  kolvo = count;
                                  summa = _price * kolvo;

                                  print(" MAIN $_price");
                                },
                                onSelected2: (pr) {
                                  _price = pr;
                                  summa = _price * kolvo;
                                },
                              )),
                          _bottombtn(qpak),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
          ),
        ]));
  }

  Widget _priceText(int _price) {
    return Text(
      '$_price₽  ',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height / 12.0,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black38,
              offset: Offset(3.0, 3.0),
            ),
          ]),
    );
  }

  Widget _description(Map<dynamic, dynamic> opt, List<dynamic> optPrices,
      List<dynamic> optKolvo, String description) {
    List k = [];
    opt.keys.forEach((element) {
      k.add(int.parse(element));
    });
    List v = opt.values.toList();
    k.sort();
    v.sort((b, a) => a.compareTo(b));
    print(k);
    print(v);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // for (int i = 0; i < optKolvo.length; i++)

      // if (optKolvo[i + 1] != null || optPrices[i + 1] != null)

      for (int i = 0; i < opt.length; i++)
        Text(
          "от ${k[i]} штук - ${v[i]}₽",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      Text(
        description,
        style: TextStyle(fontSize: 14, color: Colors.white),
      )
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

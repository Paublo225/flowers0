import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/model_screen/item_screen.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/order.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../model_screen/item_info.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget with ChangeNotifier {
  static const ID = "cartid";
  static const NAME = "name";

  static const PRICE = "summa";
  static const QUANTITY = "kolvo";
  static const SUMMARY = "summary";
  List<FlowerItemZ> flowerItem = [];
  List summ = [];
  double get total {
    return flowerItem.fold(0.0, (double currentTotal, FlowerItemZ nextFlower) {
      return currentTotal + double.parse(nextFlower.price);
    });
  }

  void totalSum() async {
    var qqq = FirebaseFirestore.instance.collection("cart").snapshots();
    qqq.forEach((element) {
      summ.add(element.docs[0]);
    });
    print(summ);
  }

  void addToCart(FlowerItemZ flowerItemZ) => flowerItem.add(flowerItemZ);
  void removeFromCart(FlowerItemZ flowerItemZ) {
    flowerItem.remove(flowerItemZ);
    notifyListeners();
  }

  String id;
  String name;
  String image;
  String productId;
  int price;
  int quantity;
  int summary;

  Cart(
      {Key key,
      this.id,
      this.name,
      this.image,
      this.price,
      this.productId,
      this.quantity,
      this.summary});

  Map toMap() => {
        ID: id,
        NAME: name,
        PRICE: price,
        QUANTITY: quantity,
      };

  CartPageState createState() => new CartPageState();
}

class CartPageState extends State<Cart>
    with AutomaticKeepAliveClientMixin<Cart> {
  FirebaseServices _firebaseServices = FirebaseServices();
  CategoryServices categoryServices;
  ProductServices productServices;
  final TextStyle topMenuStyle = new TextStyle(
      fontFamily: 'Avenir next',
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next',
      fontSize: 10,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  FlowerItem flowerItem;
  PageController _pageController;
  int _listCheck;
  List<int> _summavsego = [];
  int _summary = 0;
  Future doc(int list) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("cart").get();
    list = querySnapshot.docs.length;

    return list;
  }

  String uid;
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    // doc(_listCheck);
    //_sums();
  }

  final _key = GlobalKey<ScaffoldState>();
  final CollectionReference _ordersRef =
      FirebaseFirestore.instance.collection("users");
  OrderServices _orderServices = OrderServices();

  Future _addToCart() {
    return _ordersRef.doc(_firebaseServices.getUserId()).set({});
  }

  List<FlowerItem> convertedCart = [];

  /////////////////////////////////////////////////////////
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
///////////////////////////////////////////////////////////

  List<FlowerItem> _convertCartItems(List cart) {
    List<FlowerItem> convertedCart = [];
    for (DocumentSnapshot cartItem in cart) {
      // convertedCart.add(FlowerItem.fromSnapshot(cartItem));
    }
    return convertedCart;
  }

  bool _cartState = false;

  _onSubmit(
    String id,
    int total,
    String userId,
    List<FlowerItem> cartList,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('Подтвердите заказ')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Вы уверены?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // margin: EdgeInsets.only(right: 10),
                          //alignment: Alignment.topLeft,
                          //padding: EdgeInsets.only(right: 50),
                          //height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                'Да',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DefaultTabBar()));
                                //window OK
                                showCupertinoModalPopup(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return _popUp();
                                    });
                                //CREATING ORDER
                                _orderServices.createOrder(
                                    userId: userId,
                                    id: id,
                                    totalPrice: total,
                                    status: "В процессе",
                                    cart: convertedCart);

                                //CLEARING CART

                                convertedCart.clear();
                                _firebaseServices.usersRef
                                    .doc(_firebaseServices.getUserId())
                                    .collection("cart")
                                    .get()
                                    .then((value) {
                                  for (DocumentSnapshot sn in value.docs) {
                                    sn.reference.delete();
                                  }
                                });
                              }),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            // alignment: Alignment.centerRight,
                            //  margin: EdgeInsets.only(right: 10),
                            //height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: RaisedButton(
                                child: Text('Отмена'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                        SizedBox(
                          width: 15,
                        ),
                      ])
                ],
              )
            ]);
      },
    );
  }

  _popUp() {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: Future.delayed(
              Duration(milliseconds: 700),
              () => FirebaseFirestore.instance
                  .collection('orders')
                  .where("userId", isEqualTo: _firebaseServices.getUserId())
                  .orderBy("createdAt")
                  .get(),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: Stack(
                        children: snapshot.data.docs.map((document) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 35,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                              "Заказ №${snapshot.data.docs[snapshot.data.size - 1]["id"]} оформлен!",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    'ОК',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return DefaultTabBar();
                                        });
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                  color: Colors.white,
                                  child: Text(
                                    'Оплатить',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                DefaultTabBar(),
                                            fullscreenDialog: true));
                                  }),
                            ])
                      ]);
                }).toList()));
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                  ),
                ),
              );
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userpr = Provider.of<UserProvider>(context);
    convertedCart = [];
    return new Scaffold(
        bottomNavigationBar: _bottomInfo(),
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(children: [
              Text(
                "Корзина",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )
            ])),
        body: Stack(children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("cart")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                print("Cart downloaded");

                if (snapshot.data.docs.isEmpty) {
                  // _cartState = false;
                  return _emptycart();
                }
                if (snapshot.hasData) {
                  // _cartState = true;
                  return ListView(children: <Widget>[
                    // _topInfo(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data.docs.map((document) {
                        return GestureDetector(
                            onTap: () {
                              showBarModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  builder: (context) => FlowerScreen(
                                        flowersID: document.id,
                                        title: document["name"],
                                        qpak: 10,
                                        price: "50",
                                      ));
                            },
                            child: FutureBuilder(
                                future: _firebaseServices.productsRef
                                    .doc(document.id)
                                    .get(),
                                builder: (context, productSnap) {
                                  // convertedCart = [];
                                  if (productSnap.connectionState ==
                                      ConnectionState.done) {
                                    Map _productMap = productSnap.data.data();

                                    convertedCart.add(FlowerItem(
                                      id: document.id,
                                      imageUrl: _productMap["imageUrl"],
                                      title: _productMap["name"],
                                      price: document["summa"].toString(),
                                      quantity: document["kolvo"].toString(),
                                    ));

                                    return new Dismissible(
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        userpr.changeLoading();
                                        print(document.id);
                                        convertedCart.clear();
                                        _summavsego.remove(document["summa"]);
                                        _summavsego = [];
                                        _summary -= document["summa"];
                                        _firebaseServices.usersRef
                                            .doc(_firebaseServices.getUserId())
                                            .collection("cart")
                                            .doc(document.id)
                                            .delete();
                                        userpr.changeLoading();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1.0, 3.0),
                                                blurRadius: 3.0,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image(
                                                  image: FirebaseImage(
                                                      _productMap["imageUrl"]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text: _productMap[
                                                                    "name"] +
                                                                "\n",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                "${document["summa"]} руб \n\n",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                        TextSpan(
                                                            text: "Кол-во: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        TextSpan(
                                                            text: document[
                                                                    "kolvo"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ]),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .delete_forever_outlined,
                                                          color:
                                                              Colors.pink[100],
                                                        ),
                                                        onPressed: () async {
                                                          userpr
                                                              .changeLoading();
                                                          print(document.id);
                                                          convertedCart.clear();
                                                          _summavsego.remove(
                                                              document[
                                                                  "summa"]);
                                                          _summavsego = [];
                                                          _summary -=
                                                              document["summa"];
                                                          await _firebaseServices
                                                              .usersRef
                                                              .doc(_firebaseServices
                                                                  .getUserId())
                                                              .collection(
                                                                  "cart")
                                                              .doc(document.id)
                                                              .delete();
                                                          userpr
                                                              .changeLoading();
                                                        })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      /* background: Container(
                                          color: Colors.red,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 15),
                                            child: IconButton(
                                              icon: Icon(
                                                  CupertinoIcons.delete_solid),
                                              onPressed: () {},
                                              color: Colors.white,
                                              alignment: Alignment.centerRight,
                                              iconSize: 32,
                                            ),
                                          ))*/
                                    );
                                  }
                                  return Container(
                                    child: Center(child: Text("")),
                                  );
                                }));
                      }).toList(),
                    ),
                  ]);
                }
              }
              return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                )),
              );
            },
          ),
        ]));
  }

  /*_topInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 22, top: 10),
              alignment: Alignment.topLeft,
              child: Text(
                "Информация",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.end,
              )),
          Container(
              margin: EdgeInsets.only(left: 22, top: 5),
              alignment: Alignment.topLeft,
              child: Text(
                "Способ оплаты: Наличными",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.end,
              )),
          Container(
              margin: EdgeInsets.only(left: 22, top: 5, bottom: 11),
              alignment: Alignment.topLeft,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('data_postavki')
                      .doc("B3Hw1gcY0S3Jux77hLyj") //ID OF DOCUMENT
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("");
                    }
                    var document = snapshot.data;
                    return Text(
                      "Дата выдачи заказов: ${document["date"]}/${document["month"]}/2021",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.left,
                    );
                  })),
          Divider(
            color: Colors.black,
            thickness: 0.4,
          ),
        ]);
  }*/

  Widget _bottomInfo() {
    // print(_cartState);
    return FutureBuilder<QuerySnapshot>(
        future: _firebaseServices.usersRef
            .doc(_firebaseServices.getUserId())
            .collection("cart")
            .get(),
        builder: (context, snapshot) {
          String id = Uuid().v1().toString();
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Загрузка...");
          }
          if (snapshot.data.docs.isEmpty) return _emptycart();
          //if (_summary > 0)
          if (snapshot.hasData)
            return BottomAppBar(
                child: Container(
                    height: MediaQuery.of(context).size.height / 5.5,
                    child: new Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 15, right: 15),
                                    alignment: Alignment.topLeft,
                                    child: StreamBuilder(
                                        stream: _firebaseServices.usersRef
                                            .doc(_firebaseServices.getUserId())
                                            .collection('cart')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          print(
                                              "ETO ${snapshot.connectionState}");
                                          print(convertedCart);
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text("data");
                                          }
                                          if (snapshot.hasError) {
                                            return Text("data");
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.none) {
                                            return Text("data");
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            _summary = 0;
                                            QuerySnapshot qqq = snapshot.data;

                                            qqq.docs.forEach((doc) => {
                                                  _summary +=
                                                      doc.data()['summa']
                                                });
                                            print(_summary);

                                            return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "ИТОГ:",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                  Text(
                                                    "$_summary руб",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                ]);
                                          }
                                        })),
                                new Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    height: 50,
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black),
                                        ),
                                        disabledColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        color: Colors.black,
                                        onPressed: () async {
                                          print("ASYNC");
                                          _onSubmit(
                                            id,
                                            _summary,
                                            _firebaseServices.getUserId(),
                                            convertedCart,
                                          );
                                        },
                                        child: Text("Оформить заказ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white)))),
                              ],
                            ),
                          )
                        ])));
        });
  }

  _emptycart() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 1),
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          /*decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey[600]),
                  top: BorderSide(width: 2.0, color: Colors.grey[600]),
                  left: BorderSide(width: 2.0, color: Colors.grey[600]),
                  right: BorderSide(width: 2.0, color: Colors.grey[600]),
                ),
              ),*/
          //  child: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Container(
              child: Image(
                image: AssetImage("lib/assets/boxx.png"),
                height: MediaQuery.of(context).size.height / 7,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Здесь пустовато...",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey[600],
                  ),
                )),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "Корзина пуста. Перейдите в меню и выберете понравившийся товар",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ))
          ])),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

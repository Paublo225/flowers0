import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/cart/cart.dart';
import 'package:flowers0/model_screen/item_screen.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../helpers/count_widget.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  String orderID;
  int indexs;
  String title;
  OrderScreen({this.orderID, this.title, this.indexs});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int count = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            title: Text(
              "Заказ",
              style: TextStyle(color: Colors.black),
            ),
            leading: Container(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.back,
                    size: 28.0,
                    color: Colors.pink[200],
                  )),
            )),
        body: Stack(children: [
          FutureBuilder(
            future: _firebaseServices.orderRef.doc(widget.orderID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map _productMap = snapshot.data.data();
                var mapl = _productMap["заказ"];

                return Column(children: [
                  Container(
                    height: 50,
                    child: ListTile(
                      title: Text("Номер заказа"),
                      subtitle: Text(widget.orderID),
                    ),
                  ),
                  Container(
                    height: 50,
                    // padding: EdgeInsets.only(bottom: 30),
                    child: ListTile(
                      title: Text("Время"),
                      subtitle:
                          Text("${_productMap["time"]} ${_productMap["date"]}"),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 30),
                    child: ListTile(
                      title: Text("Итог"),
                      subtitle: Text(_productMap["total"].toString()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: mapl.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              GestureDetector(
                                  onTap: () {
                                    showBarModalBottomSheet(
                                        expand: true,
                                        context: context,
                                        builder: (context) => FlowerScreen(
                                              flowersID: mapl[index]["id"],
                                              title: mapl[index]["name"],
                                              qpak: 1,
                                              price: "1",
                                            ));
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
                                                    mapl[index]["imageUrl"]),
                                                fit: BoxFit.fill,
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
                                                          text: mapl[index]
                                                                  ["name"] +
                                                              "\n",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text:
                                                              "${mapl[index]["price"]} руб \n\n",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                      TextSpan(
                                                          text: "Кол-во: ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      TextSpan(
                                                          text: mapl[index]
                                                                  ["quantity"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )))
                            ]);
                          })),
                ]);
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
}

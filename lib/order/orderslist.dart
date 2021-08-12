import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/order/orderscreen.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum StatusSate { INPROCCES, DECLINED, SUCCSESSFULL }

class OrderHistory extends StatefulWidget {
  OrderHistory({Key key}) : super(key: key);
  @override
  _OrderHistoryState createState() => new _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  FirebaseServices _firebaseServices = FirebaseServices();

  List g1 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            leading: Container(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.back,
                    size: 28.0,
                    color: Colors.pink[200],
                  )),
            )),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                "Мои заказы",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          FutureBuilder<QuerySnapshot>(
              future: Future.delayed(
                  Duration(milliseconds: 150),
                  () => FirebaseFirestore.instance
                      .collection('orders')
                      .where("userId", isEqualTo: _firebaseServices.getUserId())
                      .orderBy("createdAt", descending: true)
                      .get()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print(snapshot.error);
                  return new Text("");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: snapshot.data.docs.map((document) {
                      var mapl =
                          document["заказ"].map((e) => '${e['name']}').toList();
                      print(mapl);

                      // mapl.forEach((k, v) => print("Key : $k, Value : $v"));
                      var ui = document["заказ"];

                      // for (int i = 0; i < document["заказ"].length; i++)
                      //  print(ui);
                      //print(mapl);
                      g1.add(mapl.toString());
                      print(g1);
                      print(g1.length);

                      return Container(
                          color: Colors.white,
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 2),
                          child: GestureDetector(
                              onTap: () => showCupertinoModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        OrderScreen(orderID: document.id),
                                  ),
                              child: ListTile(
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${document["time"]} ${document["date"]}"),
                                        Text(
                                          "Заказ №${document["id"]}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 1),
                                          child: Text(
                                            "ИТОГ: ${document["total"]}",
                                          ),
                                        ),
                                        Text("Статус: ${document["status"]}")
                                        /*Text(
                                    mapl.toString().substring(
                                        1, mapl.toString().lastIndexOf(']')),
                                    style: TextStyle(fontSize: 14),
                                  ),*/
                                      ]),
                                  trailing: Container(
                                      margin: EdgeInsets.only(
                                        right: 10,
                                      ),
                                      child: RaisedButton(
                                        onPressed: () {},
                                        child: Text("Оплатить"),
                                      )))));
                    }).toList(),
                  );
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              })
        ]));
  }
}

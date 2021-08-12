import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/auth/auth.dart';

import 'package:flowers0/order/orderslist.dart';
import 'package:flowers0/userpage/paymethod.dart';

import 'package:flowers0/userpage/settings.dart';
import 'package:flowers0/userpage/support.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserPage extends StatefulWidget {
  int indexs;
  UserPage({Key key, this.indexs}) : super(key: key);
  @override
  UserPageState createState() => new UserPageState();
}

class UserPageState extends State<UserPage> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;
    double fontSize = MediaQuery.of(context).size.width / 26;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${user.email}",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SupportPage())),
                  child: Column(children: [
                    Icon(
                      Icons.support_agent_sharp,
                      size: 25,
                      color: Colors.black,
                    ),
                    Text(
                      "Поддержка",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    )
                  ]))
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 20),
                            child: RaisedButton(
                                /*shape: new RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black),
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),*/
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              OrderHistory()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    CupertinoIcons.cart,
                                    size: 36,
                                    color: Colors.black54,
                                  ),
                                  Text(" История заказов",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) => PayMethod());
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.payment_outlined,
                                    size: 36,
                                    color: Colors.black54,
                                  ),
                                  Text(" Способ оплаты",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              SettingsPage()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    CupertinoIcons.settings,
                                    size: 32,
                                    color: Colors.black54,
                                  ),
                                  Text(" Настройки",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () async => {
                                      await FirebaseAuth.instance.signOut(),
                                      showCupertinoModalPopup(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AuthPage();
                                          })
                                    },
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.exit_to_app_outlined,
                                    size: 36,
                                    color: Colors.black54,
                                  ),
                                  Text(" Выход",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black))
                                ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // _footer(),
        ]));
  }

  _footer() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 300),
        height: 100,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Divider(
                color: Colors.black26,
              ),
              Text(
                "Контакты",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Email: flowers@mail.ru",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Телефон: +7 (999)-99-987-99",
                style: TextStyle(fontSize: 12),
              )
            ])));
  }
}

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    print(_blockSizeHorizontal);
    print(_blockSizeVertical);
  }
}

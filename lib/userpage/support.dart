import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  SupportPage({Key key}) : super(key: key);
  @override
  _SupportPageState createState() => new _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;
    double fontSize = MediaQuery.of(context).size.width / 26;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                "Поддержка",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          Container(
              //color: Colors.grey,
              margin: EdgeInsets.only(top: 15),
              height: MediaQuery.of(context).size.height / 0.2,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    width: widthB,
                    height: heightB,
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          print("object");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            CupertinoIcons.cube_box,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Доставка",
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
                    margin: EdgeInsets.only(top: 35, bottom: 10),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          print("object");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            CupertinoIcons.creditcard,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Возврат/Оплата",
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
                    margin: EdgeInsets.only(top: 35, bottom: 30),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          print("object");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.support,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Написать в поддержку",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black,
                              ))
                        ])),
                  ),
                  Text(
                    "Контакты",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "Email: flowers@mail.ru",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Телефон: +7 (999)-99-987-99",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Адрес: улица 40-лет Победы,111",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Режим работы: ПН - СБ, с 9:00 - 20:00",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

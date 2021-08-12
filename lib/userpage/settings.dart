import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user = FirebaseAuth.instance.currentUser;
  TextEditingController _mailContr = TextEditingController();
  TextEditingController _passContr = TextEditingController();
  String _pass1;
  String _pass2;
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              "Настройки",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )),
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 10, bottom: 15),
          child: Text(
            "Сменить пароль",
            style: TextStyle(fontSize: 16),
          ),
        ),
        new Container(
            width: widthB,
            height: heightB,
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: TextField(
              obscureText: true,
              controller: _mailContr,
              decoration: InputDecoration(
                labelText: "Новый пароль",
              ),
            )),
        new Container(
            width: widthB,
            height: heightB,
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            margin: EdgeInsets.only(top: 10, bottom: 15),
            child: TextField(
              controller: _passContr,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Повторите пароль",
              ),
            )),
        Center(
          child: RaisedButton(
            onPressed: () {
              _passChange();
            },
            child: Text("OK"),
          ),
        )
      ]),
    );
  }

  _passChange() async {
    _pass1 = _mailContr.text;
    _pass2 = _passContr.text;

    if (_pass1.isEmpty || _pass1.isEmpty) return;
    if (_pass1 != _pass2) {
      Fluttertoast.showToast(
          msg: "Пароль не совпадает",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (_pass1 == _pass2) {
      if (_pass2.length >= 6) {
        user.updatePassword(_pass2).then((_) {
          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });

        Fluttertoast.showToast(
            msg: "Пароль успешно изменен",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else
        Fluttertoast.showToast(
            msg: "Пароль должен содержать не менее 6 символов",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }
}

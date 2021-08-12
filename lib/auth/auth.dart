import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/authentification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);
  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _fSAuth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  Future<User> createUser() async {
    UserCredential uz;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
      uz = userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  _signInButtonAction() async {
    _email = _emailController.text;
    _password = _passwordController.text;

    if (_email.isEmpty || _password.isEmpty) return;
    dynamic user = await _authService.signInWithEmailAndPassword(
        _email.trim(), _password.trim());
    if (user == null)
      Fluttertoast.showToast(
          msg: "Проверьте вашу почту или пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    else {
      Fluttertoast.showToast(
          msg: "Вход выполнен",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      //   _emailController.clear();
      //   _passwordController.clear();
      showCupertinoModalPopup(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return DefaultTabBar();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('lib/assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      autocorrect: false,
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Почта',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      autocorrect: false,
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Пароль',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _signInButtonAction();
        },
        padding: EdgeInsets.all(12),
        color: Colors.pink[100],
        child: Text('Войти', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Theme(
        data: ThemeData(
          bottomAppBarColor: Colors.lightBlue,
          backgroundColor: Colors.lightBlue,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                forgotLabel
              ],
            ),
          ),
        ));
  }
}

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Container(
              child: Align(
                  child: Text('MAXFIT',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )))));
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white30),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54, width: 1)),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: IconTheme(
                      data: IconThemeData(color: Colors.white), child: icon))),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 20)),
        onPressed: () {
          func();
        },
      );
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: _input(
                    Icon(Icons.email), "ПОЧТА", _emailController, false)),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _input(
                    Icon(Icons.lock), "ПАРОЛЬ", _passwordController, true)),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: _button(label, func)))
          ],
        ),
      );
    }

    void _signInButtonAction() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;
      dynamic user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());
      if (user == null)
        Fluttertoast.showToast(
            msg: "Проверьте вашу почту или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      else {
        Fluttertoast.showToast(
            msg: "Вход выполнен",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // _emailController.clear();
        // _passwordController.clear();
      }
    }

    void _registerButtonAction() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      dynamic user = await _authService.registerWithEmailAndPassword(
          _email.trim(), _password.trim());
      if (user == null)
        Fluttertoast.showToast(
            msg: "Проверьте вашу почту или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    Widget _bottomWave() {
      return Expanded(
        child: Align(
          child: ClipPath(
            child: Container(
              color: Colors.white,
              height: 300,
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    }

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            _logo(),
            SizedBox(
              height: 100,
            ),
            (showLogin
                ? Column(
                    children: <Widget>[
                      _form('LOGIN', _signInButtonAction),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                            child: Text('Not registered yet? Register!',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onTap: () {
                              setState(() {
                                showLogin = false;
                              });
                            }),
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _form('REGISTER', _registerButtonAction),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                            child: Text('Already registered? Login!',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onTap: () {
                              setState(() {
                                showLogin = true;
                              });
                            }),
                      )
                    ],
                  )),
            _bottomWave()
          ],
        ));
  }
}

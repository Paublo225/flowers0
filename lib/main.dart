import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowers0/auth/initilization.dart';
import 'package:flowers0/homepageview/homie.dart';

import 'package:flowers0/provider/category.dart';

import 'package:flowers0/provider/product_pr.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'homepageview/homepage.dart';
import 'userpage/user.dart';
import 'cart/cart.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
Color mainColor = Colors.pink[100];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductProvider.initialize()),
    ChangeNotifierProvider<Cart>(create: (_) => Cart()),
  ], child: MainApp()));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context)
            .appBarTheme
            .copyWith(brightness: Brightness.light),
      ),

      locale: Locale("ru", "RU"),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      ////  localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      // onGenerateRoute: (settings) {},
      home: LandingPage(),
    );
  }
}

class DefaultTabBar extends StatefulWidget {
  int indexTab;
  int mainIndex;
  bool cartFlag;
  DefaultTabBar({Key key, this.indexTab, this.mainIndex, this.cartFlag})
      : super(key: key);
  @override
  BottomRock createState() => new BottomRock();
}

class BottomRock extends State<DefaultTabBar>
    with SingleTickerProviderStateMixin {
  CupertinoTabController _tabController;
  int _tabIndex = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  int cartItems = 0;

  int indexPrevValue = 0;

  void doc(int list) async {
    QuerySnapshot querySnapshot = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get();
    list = querySnapshot.docs.length;
    setState(() {
      cartItems = list;
    });
    print(list);
  }

  void initState() {
    super.initState();
    _tabController = new CupertinoTabController(initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
      print('my index is' + _tabController.index.toString());
    });
    doc(cartItems);
    _sums();
  }

  List<int> _summavsego = [];
  int summary = 0;
  int summaryz = 0;

  Future<int> _sums() async {
    var ggg = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get();
    print(ggg);
    for (int i = 0; i < ggg.size; i++) _summavsego.add(ggg.docs[i]["summa"]);

    print(_summavsego);

    _summavsego.forEach((i) {
      summary += i;
    });

    print(summary);
    print("WTF");
    _summavsego = [];
    return summary;
  }

  List list = [1, 2, 3];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size.height / 24;
    var topCir = MediaQuery.of(context).size.height / 120;
    var leftCir = MediaQuery.of(context).size.height / 46;
    var radius = MediaQuery.of(context).size.height / 110;
    print(radius);
    var fontCir = MediaQuery.of(context).size.height / 90;
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        activeColor: mainColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: media,
            ),
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(
                  Icons.shopping_bag_outlined,
                  size: media,
                ),
                new Positioned(
                    top: topCir,
                    left: leftCir,
                    child: new Center(
                        child: StreamBuilder(
                            stream: _firebaseServices.usersRef
                                .doc(_firebaseServices.getUserId())
                                .collection("cart")
                                .snapshots(),
                            builder: (context, snapshot) {
                              // list = snapshot.data.docs.length;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new CircleAvatar(
                                    radius: radius,
                                    backgroundColor: Colors.red,
                                    child: new Text(
                                      0.toString(),
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: fontCir,
                                          fontWeight: FontWeight.w500),
                                    ));
                              }
                              return new CircleAvatar(
                                  radius: radius,
                                  backgroundColor: Colors.red,
                                  child: new Text(
                                    snapshot.data.docs.length.toString(),
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: fontCir,
                                        fontWeight: FontWeight.w500),
                                  ));
                            }))),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person, size: media),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });
            break;
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Cart(),
              );
            });
            break;
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: UserPage(),
              );
            });
            break;
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });
            break;
        }
      },
    );
  }
}

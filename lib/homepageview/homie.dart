import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/homepageview/searchresults.dart';
import 'package:flowers0/model/category.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model_screen/item_info.dart';
import '../main.dart';
import '../sevices/product.dart';
import 'package:get/get.dart';

class HomePageZ extends StatefulWidget {
  final CategoryModel categoryModel;
  final int indexs;
  HomePageZ({Key key, this.categoryModel, this.indexs}) : super(key: key);
  @override
  HomePageZState createState() => new HomePageZState();
}

class HomePageZState extends State<HomePageZ>
    with SingleTickerProviderStateMixin {
  CategoryServices categoryServices;
  ProductServices productServices;
  bool _folded = true;
  TabController _tabController;

  final TextStyle topMenuStyle = new TextStyle(
      //  fontFamily: 'Avenir next',
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next',
      fontSize: 10,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  FlowerItem flowerItem;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int countCategories;

  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    if (widget.indexs != null) {
      _tabIndex = widget.indexs;
      _tabController.animateTo(_tabIndex);
    }
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
      print('my index is' + _tabController.index.toString());
    });

    // _tabController.addListener(_handleTabSelection);
    _getListName();
    _pageController = PageController(initialPage: 0, viewportFraction: 4);
  }

  List<String> _namesCategory = [];
  _getListName() async {
    await FirebaseFirestore.instance.collection("category").get().then((value) {
      for (int i = 0; i < value.docs.length; i++)
        _namesCategory.add(value.docs[i]["name"]);
    });
    print(_namesCategory);
    return _namesCategory;
  }

  String _searchString = "";

  int _tabIndex = 0;
  void _handleTabSelection() {
    setState(() {
      _tabIndex = _tabController.index;
    });

    /* await FirebaseFirestore.instance.collection("category").get().then((value) {
      if (mounted)
        setState(() {
          _category = value.docs[_tabIndex]["name"];
        });
    });

    print("$_category widget");*/
  }

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference dataPostavki =
      FirebaseFirestore.instance.collection("data_postavki");
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String _category;
  PageController _pageController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: ScrollableListTabView(
          tabHeight: 48,
          bodyAnimationDuration: const Duration(milliseconds: 150),
          tabAnimationCurve: Curves.easeOut,
          tabAnimationDuration: const Duration(milliseconds: 200),
          tabs: [
            for (int i = 0; i < _namesCategory.length; i++)
              ScrollableListTab(
                  tab: ListTab(
                      label: Text(_namesCategory[i]),
                      icon: Icon(Icons.group),
                      showIconOnList: false),
                  body: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (_, index) {
                      return new FutureBuilder<QuerySnapshot>(
                          future: _productsRef
                              .where("category", isEqualTo: _namesCategory[i])
                              .get(),
                          builder: (context, snapshot) {
                            return Column(
                                children: snapshot.data.docs.map((document) {
                              //////ИСПРАВИТЬ ТИП АТРИБУТА КОЛ-ВО
                              return document.data()['quantity'] == "0"
                                  ? Text("")
                                  : FlowerItemZ(
                                      id: document.id,
                                      title: document.data()['name'],
                                      imageUrl: document.data()['imageUrl'],
                                      price: document.data()['price'],
                                      description:
                                          document.data()['description'],
                                      qpak: document.data()['qpak'],
                                      opt: document.data()['опт'],
                                      minKolvo: document.data()['мин_кол-во'],
                                      categories: document.data()['category'],
                                      quantity: document.data()["quantity"],
                                      page: _pageController,
                                    );
                            }).toList());
                            /* return Scaffold(
                                    backgroundColor: Colors.white,
                                    body: Center(
                                        child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.pink[100]),
                                    )),
                                  );*/
                          });
                    },
                  ))
          ]),
    );
  }
}

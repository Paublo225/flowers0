import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/homepageview/categorylist.dart';

import 'package:flowers0/model_screen/new_item_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  String search;
  SearchResultPage({Key key, this.search}) : super(key: key);
  @override
  _SearchResultPageState createState() => new _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("products");
  String _searchString = "";
  PageController _pageController;

  void initState() {
    // loadData();
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 4);
    print("called Search");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (widget.search.isEmpty)
            _searchField()
          else
            FutureBuilder<QuerySnapshot>(
              future: _productsRef.orderBy("search_field").startAt(
                  [widget.search]).endAt(["${widget.search}\uf8ff"]).get(),
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
                  // Display the data inside a list view
                  return ListView(
                    children: snapshot.data.docs.map((document) {
                      return FlowerItemZ(
                        id: document.id,
                        title: document.data()['name'],
                        imageUrl: document.data()['imageUrl'],
                        price: document.data()['price'],
                        description: document.data()['description'],
                        qpak: document.data()['qpak'],
                        opt: document.data()['опт'],
                        minKolvo: document.data()['мин_кол-во'],
                        categories: document.data()['category'],
                        quantity: document.data()["quantity"],
                        page: _pageController,
                      );
                    }).toList(),
                  );
                }

                // Loading State
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  _searchField() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(bottom: 60),
          height: MediaQuery.of(context).size.width + 50,
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              // padding: EdgeInsets.only(top: 10, bottom: 50),
              child: Image(
                image: AssetImage("lib/assets/searcg.png"),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Введите интересующий Вас товар",
                  style: TextStyle(
                    fontFamily: 'Avenir next',
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                )),
          ])),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  CustomInput(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "Hint Text...",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            )),
        style: Constants.regularDarkText,
      ),
    );
  }
}

class Constants {
  static const regularHeading = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const boldHeading = TextStyle(
      fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const regularDarkText = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black);
}

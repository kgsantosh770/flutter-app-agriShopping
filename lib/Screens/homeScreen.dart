import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/productScreen.dart';
import 'package:agri_shopping/Screens/SingleProductScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/mainTopBar.dart';
import 'package:agri_shopping/Widgets/roundedImageContainer.dart';
import 'package:agri_shopping/Widgets/suggestionBox.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future firebaseDataFuture;

  @override
  void initState() {
    firebaseDataFuture = _loadFirebaseData();
    super.initState();
  }

  _loadFirebaseData() async {
    return await DatabaseService().getFirebaseData();
  }

  Padding categoryTitle(
      String collectionName, dynamic itemData, double _height, double _width) {
    return Padding(
      padding: EdgeInsets.only(
          left: _width * .05,
          right: _width * .03,
          top: _height * .03,
          bottom: _height * .01),
      child: Row(
        children: <Widget>[
          Text(capitalizeFirstLetters(collectionName),
              style: TextStyle(
                color: whiteColor,
                fontSize: _height / _width * normalTextFontSize,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              )),
          Padding(
            padding: EdgeInsets.only(left: _width * .01),
            child: Icon(arrowForward, size: _height / _width * tinyIconSize),
          ),
        ],
      ),
    );
  }

  Column buildBottomContent(double _height, double _width) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
              _width * .015, _height * .035, _width * .015, 0),
          child: Divider(
            color: whiteColor,
            thickness: _height * .001,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _width * .04, vertical: _height * .01),
          child: Container(
            child: Row(
              children: <Widget>[
                Icon(
                  copyRights,
                  color: whiteColor,
                  size: _height / _width * smallIconSize,
                ),
                SizedBox(width: _width * .02),
                Text("Agri Shopping",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: _height / _width * normalTextFontSize,
                      fontFamily: 'Roboto-m',
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Column buildQueryLIst(String collectionName,
      QuerySnapshot productQuerySnaphot, double _height, double _width) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(
                      isTempCollection: false,
                      title: collectionName,
                      productQuerySnaphot: productQuerySnaphot,
                    ))),
            child: categoryTitle(
                collectionName, productQuerySnaphot, _height, _width)),
        Container(
            height: _height * .235,
            margin: EdgeInsets.all(_height / _width * .5),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final DocumentSnapshot productData =
                    productQuerySnaphot.documents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleProduct(
                              itemCategory: collectionName,
                              itemData: productQuerySnaphot.documents[index],
                            )));
                  },
                  child: RoundedImageContainer(
                    image: productData.data['photo_url'],
                    itemName: productData.documentID,
                    itemPrice: productData.data['mrp'],
                    itemQuantity: productData.data['quantity'],
                  ),
                );
              },
            )),
      ],
    );
  }

  StreamBuilder buildQueryListview(
      Map<String, dynamic> futureSnapshotData, double _height, double _width) {
    List collectionList = futureSnapshotData['collections'];
    return StreamBuilder(
        stream:
            CombineLatestStream.list(futureSnapshotData['collectionStreams']),
        builder: (context, firebaseDataStream) {
          if (firebaseDataStream.hasData) {
            final firebaseData = firebaseDataStream.data;
            return Flexible(
              child: ListView.builder(
                itemCount: collectionList.length + 1,
                itemBuilder: (context, collectionIndex) {
                  if (collectionIndex == collectionList.length) {
                    return buildBottomContent(_height, _width);
                  } else if (futureSnapshotData['tempCollections']
                      .contains(collectionList[collectionIndex])) {
                    final String collectionName =
                        collectionList[collectionIndex];
                    final QuerySnapshot productQuerySnaphot =
                        firebaseData[collectionIndex];
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Product(
                                        isTempCollection: true,
                                        title: collectionName,
                                        productQuerySnaphot:
                                            productQuerySnaphot,
                                      ))),
                          child: categoryTitle(collectionName,
                              productQuerySnaphot, _height, _width),
                        ),
                        Container(
                            height: _height * .235,
                            margin: EdgeInsets.all(_height / _width * .5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                final DocumentReference productDocRef =
                                    productQuerySnaphot.documents[index]
                                        .data['document_reference'];
                                return FutureBuilder(
                                    future: DatabaseService()
                                        .toDocumentSnapshot(productDocRef),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        final DocumentSnapshot productData =
                                            snapshot.data;
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleProduct(
                                                          itemCategory:
                                                              collectionName,
                                                          itemData: productData,
                                                        )));
                                          },
                                          child: RoundedImageContainer(
                                            image:
                                                productData.data['photo_url'],
                                            itemName: productData.documentID,
                                            itemPrice: productData.data['mrp'],
                                            itemQuantity:
                                                productData.data['quantity'],
                                          ),
                                        );
                                      } else {
                                        return RoundedImageContainer(
                                            itemName: 'Loading',
                                            itemPrice: 0,
                                            itemQuantity: 'Loading',
                                            image: 'loading');
                                      }
                                    });
                              },
                            )),
                      ],
                    );
                  } else {
                    final QuerySnapshot productQuerySnaphot =
                        firebaseData[collectionIndex];
                    final String collectionName =
                        collectionList[collectionIndex];
                    return buildQueryLIst(
                        collectionName, productQuerySnaphot, _height, _width);
                  }
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: _height / _width * normalTextFontSize,
              )),
      child: BackgroundContainer(
          child: Scaffold(
              appBar: mainTopBar(context, _height, _width),
              backgroundColor: transparentColor,
              body: FutureBuilder(
                  future: firebaseDataFuture,
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.hasData &&
                        futureSnapshot.connectionState ==
                            ConnectionState.done) {
                      final Map<String, dynamic> futureSnapshotData =
                          futureSnapshot.data;
                      return Container(
                        height: _height,
                        width: _width,
                        child: Column(
                          children: <Widget>[
                            SuggestionBox(
                                suggesstionList:
                                    futureSnapshotData['suggestions']),
                            buildQueryListview(
                                futureSnapshotData, _height, _width)
                          ],
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  }))),
    );
  }
}

import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/productScreen.dart';
import 'package:agri_shopping/Screens/SingleProductScreen.dart';
import 'package:agri_shopping/Widgets/addressBar.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/mainTopBar.dart';
import 'package:agri_shopping/Widgets/roundedImageContainer.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
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

  Column buildQueryLIst(String collectionName,
      QuerySnapshot productQuerySnapshot, double _height, double _width) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(
                      isTempCollection: false,
                      title: collectionName,
                      productQuerySnapshot: productQuerySnapshot,
                    ))),
            child: categoryTitle(
                collectionName, productQuerySnapshot, _height, _width)),
        Container(
            height: _height * .235,
            margin: EdgeInsets.all(_height / _width * .5),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final DocumentSnapshot productData =
                    productQuerySnapshot.documents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleProduct(
                              path:
                                  '$collectionName/${productQuerySnapshot.documents[index].documentID}',
                              itemData: productQuerySnapshot.documents[index],
                            )));
                  },
                  child: RoundedImageContainer(
                    image: productData.data['photo_url'],
                    itemName: productData.documentID,
                    itemPrice: productData.data['mrp'],
                    discount: productData.data['discount_percent'],
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
                itemCount: collectionList.length,
                itemBuilder: (context, collectionIndex) {
                  // if (collectionIndex == collectionList.length) {
                  //   return buildBottomContent(_height, _width);
                  // } else
                  if (futureSnapshotData['tempCollections']
                      .contains(collectionList[collectionIndex])) {
                    final String collectionName =
                        collectionList[collectionIndex];
                    final QuerySnapshot productQuerySnapshot =
                        firebaseData[collectionIndex];
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Product(
                                        isTempCollection: true,
                                        title: collectionName,
                                        productQuerySnapshot:
                                            productQuerySnapshot,
                                      ))),
                          child: categoryTitle(collectionName,
                              productQuerySnapshot, _height, _width),
                        ),
                        Container(
                            height: _height * .235,
                            margin: EdgeInsets.all(_height / _width * .5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                final DocumentReference productDocRef =
                                    productQuerySnapshot.documents[index]
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
                                                          path: productDocRef
                                                              .path,
                                                          itemData: productData,
                                                        )));
                                          },
                                          child: RoundedImageContainer(
                                            image:
                                                productData.data['photo_url'],
                                            itemName: productData.documentID,
                                            itemPrice: productData.data['mrp'],
                                            discount: productData
                                                .data['discount_percent'],
                                            itemQuantity:
                                                productData.data['quantity'],
                                          ),
                                        );
                                      } else {
                                        return RoundedImageContainer(
                                            itemName: 'Loading',
                                            itemPrice: 0,
                                            itemQuantity: 'Loading',
                                            discount: 0,
                                            image: 'loading');
                                      }
                                    });
                              },
                            )),
                      ],
                    );
                  } else {
                    final QuerySnapshot productQuerySnapshot =
                        firebaseData[collectionIndex];
                    final String collectionName =
                        collectionList[collectionIndex];
                    return buildQueryLIst(
                        collectionName, productQuerySnapshot, _height, _width);
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
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return BackgroundContainer(
        child: Scaffold(
            appBar: user == null
                ? mainTopBar(context)
                : mainTopBar(context, uid: user.uid),
            backgroundColor: transparentColor,
            body: FutureBuilder(
                future: firebaseDataFuture,
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.hasData &&
                      futureSnapshot.connectionState == ConnectionState.done) {
                    final Map<String, dynamic> futureSnapshotData =
                        futureSnapshot.data;
                    return Container(
                      height: _height,
                      width: _width,
                      child: Column(
                        children: <Widget>[
                          user != null
                              ? addressBar(context)
                              : SizedBox.shrink(),
                          // SuggestionBox(
                          //     suggesstionList:
                          //         futureSnapshotData['suggestions']),
                          buildQueryListview(
                              futureSnapshotData, _height, _width)
                        ],
                      ),
                    );
                  } else {
                    return Loading();
                  }
                })));
  }
}

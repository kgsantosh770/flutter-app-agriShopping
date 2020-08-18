import 'package:agri_shopping/Screens/confirmAddressScreen.dart';
import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/singleProductScreen.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favorite {
  Favorite(this.buildContext, this.uid);
  BuildContext buildContext;
  final String uid;

  favoriteItem(
      {height, width, item, discount, image, price, measure, tapFunction}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(width * .03, height * .03, width * .03, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: tapFunction,
            child: Container(
              width: width * .7,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(tinyBorderRadius),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        height: height * .07,
                        width: width * .15,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(width: width * .05),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(capitalizeFirstLetters(item),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: height / width * normalTextFontSize,
                            )),
                        SizedBox(height: height * .005),
                        Text('$rupee $price /$measure',
                            style: TextStyle(
                              fontSize: height / width * smallTextFontSize,
                            )),
                      ]),
                  SizedBox(width: width * .05),
                  discount <= 0
                      ? SizedBox.shrink()
                      : Expanded(
                          child: Text(
                            'Upto $discount% offer',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: height / width * smallTextFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {},
            icon: Icon(delete),
          )
        ],
      ),
    );
  }

  void openFavorites() {
    final _height = MediaQuery.of(buildContext).size.height;
    final _width = MediaQuery.of(buildContext).size.width;
    showModalBottomSheet(
        elevation: 3.0,
        isScrollControlled: true,
        barrierColor: blackColor.withOpacity(.65),
        backgroundColor: transparentColor,
        context: buildContext,
        builder: (builder) {
          return StreamBuilder<DocumentSnapshot>(
              stream: DatabaseService(uid: uid).userData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                } else {
                  final Map favoritesData = snapshot.data.data['favorites'];
                  return Container(
                    height: _height * 0.78,
                    color: blackColor,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: _height * .08,
                          color: primaryColor,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .035),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: _height * .02),
                                child: Text("Your Favorites",
                                    style: TextStyle(
                                      fontSize:
                                          _height / _width * largeTextFontSize,
                                      fontFamily: 'Roboto-m',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: _height * .02,
                                      bottom: _height * .025),
                                  child: ListView.builder(
                                    itemCount: favoritesData.keys.length,
                                    itemBuilder: (context, index) {
                                      return StreamBuilder<DocumentSnapshot>(
                                          stream: Firestore.instance
                                              .document(favoritesData.entries
                                                  .elementAt(index)
                                                  .value
                                                  .path)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return SizedBox.shrink();
                                            else {
                                              final productData =
                                                  snapshot.data.data;

                                              return favoriteItem(
                                                  tapFunction: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SingleProduct(
                                                                  path: favoritesData
                                                                      .entries
                                                                      .elementAt(
                                                                          index)
                                                                      .value[
                                                                          'document_reference']
                                                                      .path,
                                                                  itemData:
                                                                      snapshot
                                                                          .data,
                                                                )));
                                                  },
                                                  height: _height,
                                                  width: _width,
                                                  item: favoritesData.keys
                                                      .elementAt(index),
                                                  discount: productData[
                                                      'discount_percent'],
                                                  image:
                                                      productData['photo_url'],
                                                  price: productData['mrp'],
                                                  measure:
                                                      productData['quantity']);
                                            }
                                          });
                                    },
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: _height * .1,
                                  width: _width * .9,
                                  padding: EdgeInsets.symmetric(
                                      vertical: _height * .01,
                                      horizontal: _width * .05),
                                  child: FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _width * .05,
                                          vertical: _height * .025),
                                      color: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Checkout',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: _height / _width * 9,
                                            ),
                                          ),
                                          SizedBox(width: _width * .02),
                                          Icon(
                                            arrowForward,
                                            color: whiteColor,
                                            size: mediumIconSize,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            buildContext,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmAddress(
                                                orderData: {
                                                  'type': 'multiple',
                                                  'item_names':
                                                      favoritesData.keys,
                                                  'item_discount_price':
                                                      favoritesData['total'] -
                                                          favoritesData[
                                                              'total_with_discount'],
                                                  'total': favoritesData[
                                                      'total_with_discount']
                                                },
                                              ),
                                            ));
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
        });
  }
}

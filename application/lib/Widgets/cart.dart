import 'package:agri_shopping/Screens/confirmAddressScreen.dart';
import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/singleProductScreen.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart {
  Cart(this.buildContext, this.uid);
  BuildContext buildContext;
  final String uid;

  cartItem(
      {double height,
      double width,
      String item,
      String image,
      double discountPrice,
      String path,
      String docId,
      var price,
      var minQuantity,
      var maxQuantity,
      var quantity,
      String measure,
      var total,
      Function tapFunction}) {
    double itemQuantity;
    if (quantity != null) itemQuantity = quantity;

    return Padding(
      padding: EdgeInsets.fromLTRB(width * .001, height * .03, width * .001, 0),
      child: item == 'SubTotal :'
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item,
                      style: TextStyle(
                          fontSize: height / width * largeTextFontSize,
                          fontWeight: FontWeight.bold)),
                  Text('$rupee ${(total).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: height / width * largeTextFontSize,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            )
          : Container(
              width: width * .9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: tapFunction,
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(tinyBorderRadius),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                height: height * .07,
                                width: width * .15,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(width: width * .05),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(capitalizeFirstLetters(item),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            height / width * normalTextFontSize,
                                      )),
                                  SizedBox(height: height * .005),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text: '$rupee ',
                                          style: TextStyle(
                                            fontSize: height /
                                                width *
                                                smallTextFontSize,
                                          )),
                                      TextSpan(
                                          text: '${price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: height /
                                                  width *
                                                  smallTextFontSize,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness:
                                                  strikeThickness)),
                                      TextSpan(
                                          text:
                                              '  ${discountPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: height /
                                                width *
                                                smallTextFontSize,
                                          )),
                                    ]),
                                  ),
                                ]),
                          ),
                          SizedBox(width: width * .03),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                if (itemQuantity > minQuantity) {
                                  itemQuantity =
                                      itemQuantity - minQuantity.toInt();

                                  dynamic result =
                                      await DatabaseService(uid: uid)
                                          .changeCartQuantity(item, price,
                                              discountPrice, itemQuantity);
                                  if (result == null)
                                    print(
                                        'Error occured changing the quantity');
                                } else if (itemQuantity == minQuantity) {
                                  dynamic result =
                                      await DatabaseService(uid: uid)
                                          .removeProduct(
                                              from: 'cart',
                                              path: path,
                                              itemDocId: docId);

                                  if (result == null)
                                    print('item not added');
                                  else
                                    print(result);
                                }
                              },
                              iconSize: height / width * smallIconSize,
                              icon: Icon(
                                itemQuantity == minQuantity ? delete : remove,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: width * .1,
                              child: Text(itemQuantity.toInt().toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        height / width * normalTextFontSize,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                if (itemQuantity < maxQuantity) {
                                  itemQuantity =
                                      itemQuantity + minQuantity.toInt();
                                  dynamic result =
                                      await DatabaseService(uid: uid)
                                          .changeCartQuantity(item, price,
                                              discountPrice, itemQuantity);
                                  if (result == null)
                                    print(
                                        'Error occured changing the quantity');
                                }
                              },
                              iconSize: height / width * smallIconSize,
                              icon: Icon(add),
                            ),
                          ),
                          Expanded(
                            child: Text(measure,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: height / width * normalTextFontSize,
                                )),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
    );
  }

  void openCart() {
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
                  final Map cartData = snapshot.data.data['cart'];
                  final List cartOrder = cartData['order'].reversed.toList();
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
                                child: Text("Your Cart",
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
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 5,
                                        child: ListView.builder(
                                          itemCount: cartOrder.length,
                                          itemBuilder: (context, index) {
                                            if (cartOrder[index] == 'total' ||
                                                cartOrder[index] ==
                                                    'total_with_discount' ||
                                                cartOrder[index] == 'order') {
                                              return SizedBox.shrink();
                                            } else {
                                              return StreamBuilder<
                                                      DocumentSnapshot>(
                                                  stream: Firestore.instance
                                                      .document(cartData[
                                                                  cartOrder[
                                                                      index]][
                                                              'document_reference']
                                                          .path)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData)
                                                      return SizedBox.shrink();
                                                    else {
                                                      final productData =
                                                          snapshot.data.data;

                                                      return cartItem(
                                                          tapFunction: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SingleProduct(
                                                                              path: cartData[cartOrder[index]]['document_reference'].path,
                                                                              itemData: snapshot.data,
                                                                            )));
                                                          },
                                                          height: _height,
                                                          width: _width,
                                                          item:
                                                              cartOrder[index],
                                                          image: productData[
                                                              'photo_url'],
                                                          path: cartData[cartOrder[index]][
                                                                  'document_reference']
                                                              .path,
                                                          docId: snapshot
                                                              .data.documentID,
                                                          discountPrice:
                                                              productData['mrp'] -
                                                                  (productData['mrp'] *
                                                                      (productData['discount_percent'] /
                                                                          100)),
                                                          price: productData[
                                                              'mrp'],
                                                          minQuantity: productData[
                                                              'min_quantity'],
                                                          maxQuantity: productData[
                                                              'max_quantity'],
                                                          quantity: cartData[
                                                                  cartOrder[
                                                                      index]]
                                                              ['quantity'],
                                                          measure: productData[
                                                              'quantity']);
                                                    }
                                                  });
                                            }
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: cartItem(
                                            height: _height,
                                            width: _width,
                                            item: 'SubTotal :',
                                            total: cartData[
                                                    'total_with_discount'] ??
                                                0),
                                      ),
                                    ],
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
                                      child: Text(
                                        'Proceed To Buy',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: _height /
                                              _width *
                                              normalTextFontSize,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Map items = Map();
                                        cartData.forEach((key, value) async {
                                          if (key != 'total' &&
                                              key != 'total_with_discount' &&
                                              key != 'order') {
                                            String measure;
                                            DocumentReference documentReference;
                                            documentReference =
                                                value['document_reference'];
                                            await documentReference.get().then(
                                                (docValue) => measure = docValue
                                                    .data['quantity']
                                                    .toString());
                                            items[key] = {
                                              'quantity': value['quantity'],
                                              'measure': measure,
                                            };
                                          }
                                        });
                                        Navigator.push(
                                            buildContext,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmAddress(
                                                orderData: {
                                                  'type': 'multiple',
                                                  'items': items,
                                                  'discount_price': cartData[
                                                          'total'] -
                                                      cartData[
                                                          'total_with_discount'],
                                                  'total': cartData['total'],
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

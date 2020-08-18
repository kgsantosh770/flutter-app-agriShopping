import 'package:agri_shopping/Screens/confirmAddressScreen.dart';
import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';
import 'package:agri_shopping/Widgets/cart.dart';
import 'package:agri_shopping/Widgets/favorite.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  const SingleProduct({Key key, this.path, this.itemData}) : super(key: key);
  final String path;
  final DocumentSnapshot itemData;
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool loading = false;
  bool isInCart;
  double quantity;

  @override
  void initState() {
    quantity = widget.itemData.data['min_quantity'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final discountPrice = widget.itemData.data['mrp'] *
        (widget.itemData.data['discount_percent'] / 100);
    final totalWithDiscount = widget.itemData.data['mrp'] - discountPrice;
    TextStyle rupeeTextStyle = TextStyle(
      fontSize: _height / _width * mediumTextFontSize,
      fontWeight: FontWeight.bold,
    );

    return BackgroundContainer(
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: transparentColor,
              appBar: topBar(context),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildImageBox(_height, _width, context),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _width * .05, vertical: _height * .02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  capitalizeFirstLetters(
                                      widget.itemData.documentID),
                                  style: TextStyle(
                                      fontFamily: "Roboto-m",
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: _height /
                                          _width *
                                          extraLargeFontSize)),
                              user != null
                                  ? StreamBuilder<DocumentSnapshot>(
                                      stream: DatabaseService(uid: user.uid)
                                          .userData,
                                      builder: (streamContext, snapshot) {
                                        if (snapshot.hasData) {
                                          final userFavoriteData =
                                              snapshot.data.data['favorites'];
                                          return Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle),
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () async {
                                                if (userFavoriteData
                                                    .containsKey(widget
                                                        .itemData.documentID)) {
                                                  print(widget
                                                      .itemData.documentID);
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  dynamic result =
                                                      await DatabaseService(
                                                              uid: user.uid)
                                                          .removeProduct(
                                                              from: 'favorites',
                                                              itemDocId: widget
                                                                  .itemData
                                                                  .documentID);
                                                  if (result == null)
                                                    print('item not removed');
                                                  else
                                                    print(result);
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  dynamic result =
                                                      await DatabaseService(
                                                              uid: user.uid)
                                                          .addProduct(
                                                              to: 'favorites',
                                                              path: widget.path,
                                                              itemDocId: widget
                                                                  .itemData
                                                                  .documentID);
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  if (result == null)
                                                    print('item not added');
                                                  else {
                                                    print('res = $result');
                                                    Favorite(context, user.uid)
                                                        .openFavorites();
                                                  }
                                                }
                                              },
                                              icon: Icon(
                                                userFavoriteData.containsKey(
                                                        widget.itemData
                                                            .documentID)
                                                    ? favorite
                                                    : favoriteOutline,
                                                color: userFavoriteData
                                                        .containsKey(widget
                                                            .itemData
                                                            .documentID)
                                                    ? favoriteColor
                                                    : whiteColor,
                                                size: _height /
                                                    _width *
                                                    extraLargeFontSize,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Loading();
                                        }
                                      })
                                  : Container(
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('signInScreen');
                                        },
                                        icon: Icon(
                                          favoriteOutline,
                                          color: whiteColor,
                                          size: _height / _width * 16,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Quantity :\t\t\t",
                                style: rupeeTextStyle,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (quantity >
                                        widget.itemData.data['min_quantity']) {
                                      setState(() {
                                        quantity = quantity -
                                            widget
                                                .itemData.data['min_quantity'];
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    remove,
                                    size: _height / _width * mediumIconSize,
                                  )),
                              Flexible(
                                child: Container(
                                  decoration: transparentBorder.copyWith(
                                      color: greyColor),
                                  padding: EdgeInsets.symmetric(
                                      vertical: _height * .01,
                                      horizontal: _width * .04),
                                  child: Text(
                                    '${quantity.toInt()}',
                                    style: rupeeTextStyle,
                                  ),
                                ),
                              ),
                              Text(
                                '  ${widget.itemData.data['quantity']}',
                                style: rupeeTextStyle,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (quantity <
                                        widget.itemData.data['max_quantity']) {
                                      setState(() {
                                        quantity = quantity +
                                            widget
                                                .itemData.data['min_quantity'];
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    add,
                                    size: _height / _width * mediumIconSize,
                                  )),
                            ],
                          ),
                          SizedBox(height: _height * .02),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    '$rupee ${totalWithDiscount.toStringAsFixed(2)} /${widget.itemData.data['quantity']}\n',
                                style: TextStyle(
                                  fontSize:
                                      _height / _width * largeTextFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'MRP: ',
                                style: rupeeTextStyle,
                              ),
                              TextSpan(
                                text:
                                    '$rupee ${widget.itemData.data['mrp']} /${widget.itemData.data['quantity']}',
                                style: rupeeTextStyle.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: strikeThickness),
                              ),
                              TextSpan(
                                text: '  Savings: ',
                                style: rupeeTextStyle,
                              ),
                              TextSpan(
                                text:
                                    '$rupee ${discountPrice.toStringAsFixed(2)} /${widget.itemData.data['quantity']}',
                                style: rupeeTextStyle,
                              ),
                            ]),
                          ),
                          SizedBox(height: _height * .05),
                          Text(
                            toBeginningOfSentenceCase(
                                widget.itemData.data['description']),
                            style: TextStyle(
                              fontFamily: "Roboto-t",
                              fontSize: _height / _width * normalTextFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: user != null
                  ? StreamBuilder<DocumentSnapshot>(
                      stream: DatabaseService(uid: user.uid).userData,
                      builder: (streamContext, snapshot) {
                        if (snapshot.hasData) {
                          final userCartData = snapshot.data.data['cart'];

                          return bottomBar(
                            height: _height,
                            width: _width,
                            firstButtonText: 'Buy now',
                            firstButtonIcon: shoppingBag,
                            firstButtonAction: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmAddress(
                                      orderData: {
                                        'type': 'single',
                                        'items': {
                                          widget.itemData.documentID: {
                                            'quantity': quantity,
                                            'measure':
                                                widget.itemData.data['quantity']
                                          }
                                        },
                                        'discount_price': (widget
                                                    .itemData.data['mrp'] *
                                                (widget.itemData.data[
                                                        'discount_percent'] /
                                                    100)) *
                                            quantity,
                                        'total': widget.itemData.data['mrp'] *
                                            quantity,
                                      },
                                    ),
                                  ));
                            },
                            secondButtonText: 'Add To Cart',
                            secondButtonIcon: !userCartData
                                    .containsKey(widget.itemData.documentID)
                                ? add
                                : tick,
                            secondButtonAction: () async {
                              if (!userCartData
                                  .containsKey(widget.itemData.documentID)) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await DatabaseService(
                                        uid: user.uid)
                                    .addProduct(
                                        to: 'cart',
                                        quantity: quantity,
                                        path: widget.path,
                                        itemDocId: widget.itemData.documentID);
                                setState(() {
                                  loading = false;
                                });
                                if (result == null)
                                  print('item not added');
                                else {
                                  print(result);
                                  Cart(context, user.uid).openCart();
                                }
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await DatabaseService(
                                        uid: user.uid)
                                    .removeProduct(
                                        from: 'cart',
                                        path: widget.path,
                                        itemDocId: widget.itemData.documentID);
                                setState(() {
                                  loading = false;
                                });
                                if (result == null)
                                  print('item not added');
                                else
                                  print(result);
                              }
                            },
                          );
                        } else {
                          return Loading();
                        }
                      },
                    )
                  : bottomBar(
                      height: _height,
                      width: _width,
                      firstButtonText: 'Buy Now',
                      firstButtonAction: () {
                        Navigator.pushNamed(context, 'signInScreen');
                      },
                      firstButtonIcon: shoppingBag,
                      secondButtonText: 'Add To Cart',
                      secondButtonIcon: add,
                    ),
            ),
    );
  }

  Stack _buildImageBox(double _height, double _width, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(height: _height * .35, width: _width, color: whiteColor),
        Hero(
          tag: widget.itemData.documentID,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FullScreenImage(
                    heroTag: widget.itemData.documentID,
                    imageUrl: widget.itemData.data['photo_url']))),
            child: Container(
                height: _height * .35,
                width: _width,
                child: CachedNetworkImage(
                    imageUrl: widget.itemData.data['photo_url'],
                    fit: BoxFit.contain)),
          ),
        ),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({Key key, this.heroTag, this.imageUrl})
      : super(key: key);
  final String heroTag;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height,
      width: _width,
      color: whiteColor,
      child: Hero(
        tag: heroTag,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

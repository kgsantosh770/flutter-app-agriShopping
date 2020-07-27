import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';
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
  const SingleProduct({Key key, this.itemCategory, this.itemData})
      : super(key: key);
  final String itemCategory;
  final DocumentSnapshot itemData;
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isFavorite = false;
  bool isInCart;

  @override
  Widget build(BuildContext context) {
    print(widget.itemCategory);
    print(widget.itemData.documentID);
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: topBar(context, _height, _width),
        bottomNavigationBar: user != null
            ? StreamBuilder(
                stream: DatabaseService(uid: user.uid).userCartData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var userCartData = snapshot.data;
                    return bottomBar(
                      context,
                      _height,
                      _width,
                      'Buy Now',
                      isNavigatable: true,
                      routeName: 'paymentScreen',
                      secondButtonText: 'Add To Cart',
                      secondButtonData: {
                        'uid': user.uid,
                        'itemCategory': widget.itemCategory,
                        'itemDocId': widget.itemData.documentID,
                      },
                      firstButtonIcon: shoppingBag,
                      secondButtonIcon: !userCartData.data
                              .containsKey(widget.itemData.documentID)
                          ? add
                          : tick,
                    );
                  } else {
                    return Loading();
                  }
                },
              )
            : bottomBar(context, _height, _width, 'Buy Now',
                firstButtonIcon: shoppingBag,
                isNavigatable: true,
                routeName: 'signInScreen'),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: _height * .35, width: _width, color: whiteColor),
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
              ),
              Container(
                decoration: BoxDecoration(
                    color: transparentColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: _width * .05,
                          right: _width * .05,
                          top: _height * .03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              capitalizeFirstLetters(
                                  widget.itemData.documentID),
                              style: TextStyle(
                                  fontFamily: "Roboto-m",
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _height / _width * 15)),
                          user != null
                              ? StreamBuilder<Object>(
                                  stream: DatabaseService(uid: user.uid)
                                      .userFavoriteData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final DocumentSnapshot userFavoriteData =
                                          snapshot.data;
                                      return Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () async {
                                            if (userFavoriteData.data
                                                .containsKey(widget
                                                    .itemData.documentID)) {
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .removeFromFavorite(
                                                      widget.itemCategory,
                                                      widget
                                                          .itemData.documentID);
                                            } else {
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .addToFavorites(
                                                      widget.itemCategory,
                                                      widget
                                                          .itemData.documentID);
                                            }
                                          },
                                          icon: Icon(
                                            userFavoriteData.data.containsKey(
                                                    widget.itemData.documentID)
                                                ? favorite
                                                : favoriteOutline,
                                            color: userFavoriteData.data
                                                    .containsKey(widget
                                                        .itemData.documentID)
                                                ? favoriteColor
                                                : whiteColor,
                                            size: _height / _width * 16,
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
                                    onPressed: () async {
                                      if (isFavorite == true) {
                                        await DatabaseService(uid: user.uid)
                                            .removeFromFavorite(
                                                widget.itemCategory,
                                                widget.itemData.documentID);
                                      } else {
                                        await DatabaseService(uid: user.uid)
                                            .addToFavorites(widget.itemCategory,
                                                widget.itemData.documentID);
                                      }
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
                                    },
                                    icon: Icon(
                                      isFavorite ? favorite : favoriteOutline,
                                      color: isFavorite
                                          ? favoriteColor
                                          : whiteColor,
                                      size: _height / _width * 16,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    // SizedBox(height: 12),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 30),
                    //   child: Text(
                    //     "Random subtitle",
                    //     style: TextStyle(
                    //       fontFamily: "Roboto-r",
                    //       fontSize: _height / _width * 10,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: _width * .05),
                      child: Text(
                        rupee +
                            widget.itemData.data['mrp'].toString() +
                            ' /' +
                            widget.itemData.data['quantity'].toString(),
                        style: TextStyle(
                          color: lightPrimaryColor,
                          fontSize: _height / _width * largeTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: _width * .05),
                      child: Text(
                        toBeginningOfSentenceCase(
                            widget.itemData.data['description']),
                        style: TextStyle(
                          fontFamily: "Roboto-t",
                          fontSize: _height / _width * normalTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

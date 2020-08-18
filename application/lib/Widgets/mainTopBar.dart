import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import '../constants.dart';

mainTopBar(BuildContext context,
    {String uid, bool automaticallyImplyLeading = false}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[primaryColor, lightGreenColor])),
    ),
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 4,
    title: GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('homeScreen');
      },
      child: Text(appName,
          style: TextStyle(
            color: whiteColor,
            fontFamily: 'Oleo',
            fontWeight: FontWeight.bold,
            fontSize: _height / _width * extraLargeFontSize,
          )),
    ),
    iconTheme: IconThemeData(
        color: whiteColor, size: _height / _width * mediumIconSize),
    actions: <Widget>[
      IconButton(
        onPressed: () async {
          await AuthService().signOut();
        },
        icon: Icon(
          search,
          size: _height / _width * mediumIconSize,
          color: whiteColor,
        ),
      ),
      IconButton(
        onPressed: () {
          uid == null
              ? Navigator.of(context).pushNamed('signInScreen')
              : Cart(context, uid).openCart();
        },
        icon: Icon(
          shoppingCart,
          size: _height / _width * mediumIconSize,
          color: whiteColor,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('settingsScreen');
        },
        icon: Icon(
          account,
          size: _height / _width * mediumIconSize,
          color: whiteColor,
        ),
      )
    ],
  );
}

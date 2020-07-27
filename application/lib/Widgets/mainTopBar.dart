// import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import '../constants.dart';

AppBar mainTopBar(BuildContext context, double _height, double _width,
    {bool automaticallyImplyLeading = false}) {
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
      child: Text('AGRI',
          style: TextStyle(
              color: whiteColor,
              fontFamily: 'Akronim-r',
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * extraLargeFontSize,
              letterSpacing: 3.5)),
    ),
    iconTheme: IconThemeData(
        color: whiteColor, size: _height / _width * mediumIconSize),
    actions: <Widget>[
      // ignore: missing_required_param
      IconButton(
        // onPressed: () async {
        // await AuthService().signOut();
        // },
        icon: Icon(
          search,
          size: _height / _width * mediumIconSize,
          color: whiteColor,
        ),
      ),
      IconButton(
        onPressed: () {
          Cart(context, _height, _width).openCart();
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

import 'package:flutter/material.dart';
import '../constants.dart';

topBar(BuildContext context, {Widget child1, Widget child2}) {
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
      // automaticallyImplyLeading: false,
      elevation: 0,
      actions: <Widget>[
        child1 != null ? child1 : SizedBox.shrink(),
        child2 != null ? child2 : SizedBox.shrink(),
      ],
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
      ));
}

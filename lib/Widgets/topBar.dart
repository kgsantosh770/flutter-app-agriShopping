import 'package:flutter/material.dart';
import '../constants.dart';

topBar(BuildContext context, double height, double width,
    {Widget child1, Widget child2}) {
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
        child: Text('AGRI',
            style: TextStyle(
                color: whiteColor,
                fontFamily: 'Akronim-r',
                fontWeight: FontWeight.bold,
                fontSize: height / width * 16,
                letterSpacing: 3.5)),
      ));
}

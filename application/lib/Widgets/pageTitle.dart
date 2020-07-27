import 'package:flutter/material.dart';

import '../constants.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
          left: _width * .04, bottom: _height * .01, top: _height * .02),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto-m',
          fontSize: _height / _width * mediumTextFontSize,
          color: whiteColor,
        ),
      ),
    );
  }
}

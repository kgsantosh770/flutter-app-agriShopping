import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

errorBox(double _height, double _width, bool isError, String error,
    {String errorTitle = 'Error'}) {
  return Center(
    child: isError
        ? Container(
            width: _width,
            decoration: errorTitle != 'Error'
                ? primaryColorBorder.copyWith(color: whiteColor)
                : errorBorder.copyWith(color: whiteColor),
            margin: EdgeInsets.only(
                top: _height * .02, left: _width * .05, right: _width * .05),
            padding: EdgeInsets.symmetric(vertical: _height * .01),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$errorTitle\n',
                      style: TextStyle(
                          fontFamily: 'roboto-b',
                          fontWeight: FontWeight.bold,
                          fontSize: _height / _width * mediumTextFontSize,
                          color: errorTitle != 'Error'
                              ? primaryColor
                              : errorColor)),
                  Text(error,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _height / _width * normalTextFontSize,
                          color: errorTitle != 'Error'
                              ? primaryColor
                              : errorColor)),
                ],
              ),
            ),
          )
        : SizedBox.shrink(),
  );
}

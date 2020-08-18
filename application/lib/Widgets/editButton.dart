import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

editButton({
  @required double height,
  @required double width,
  @required double buttonHeight,
  @required Function onTapFunction,
  @required EdgeInsetsGeometry margin,
}) {
  return Container(
    height: buttonHeight,
    margin: margin,
    child: FlatButton(
        color: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tinyBorderRadius),
        ),
        child: Center(
          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: height / width * normalTextFontSize,
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: onTapFunction),
  );
}

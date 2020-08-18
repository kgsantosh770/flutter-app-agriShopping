import 'package:flutter/material.dart';
import 'package:agri_shopping/constants.dart';

Column buildBottomContent(double _height, double _width) {
  TextStyle headingStyle = TextStyle(
      fontSize: _height / _width * mediumTextFontSize,
      fontWeight: FontWeight.bold);
  TextStyle normalStyle = TextStyle(
    fontSize: _height / _width * normalTextFontSize,
  );
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(
            _width * .015, _height * .035, _width * .015, 0),
        child: Divider(
          color: whiteColor,
          thickness: _height * .001,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _width * .04, vertical: _height * .01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("About", style: headingStyle),
                  Text("About Us", style: normalStyle),
                  Text("Contact Us", style: normalStyle),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Help", style: headingStyle),
                  Text("Your Account", style: normalStyle),
                  Text("FAQ", style: normalStyle)
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Support", style: headingStyle),
                  Text("agrishopping90@gmail.com", style: normalStyle),
                  Text("Phone:+91-9876543210", style: normalStyle),
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}

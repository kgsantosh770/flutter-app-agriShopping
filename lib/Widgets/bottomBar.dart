import 'package:agri_shopping/services/database.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

bottomBar(
  BuildContext context,
  double _height,
  double _width,
  String buttonText, {
  bool isNavigatable = false,
  String routeName = '',
  String secondButtonText = '',
  IconData firstButtonIcon,
  IconData secondButtonIcon,
  Map secondButtonData,
}) {
  return BottomAppBar(
      color: transparentColor,
      elevation: 3,
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: _height * .015, horizontal: _width * .08),
          child: secondButtonText != ''
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .02,
                              vertical: _height * .025),
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(smallBorderRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              firstButtonIcon != null
                                  ? Icon(
                                      firstButtonIcon,
                                      color: whiteColor,
                                    )
                                  : SizedBox.shrink(),
                              Padding(
                                padding: EdgeInsets.only(left: _width * .02),
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    fontSize:
                                        _height / _width * normalTextFontSize,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (isNavigatable) {
                              Navigator.of(context).pushNamed(routeName);
                            }
                          }),
                    ),
                    SizedBox(width: _width * .03),
                    Expanded(
                      child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .02,
                              vertical: _height * .025),
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(smallBorderRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              secondButtonIcon != null
                                  ? Icon(
                                      secondButtonIcon,
                                      color: whiteColor,
                                    )
                                  : SizedBox.shrink(),
                              Padding(
                                padding: EdgeInsets.only(left: _width * .02),
                                child: Text(
                                  secondButtonText,
                                  style: TextStyle(
                                    fontSize:
                                        _height / _width * normalTextFontSize,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (secondButtonIcon == add) {
                              dynamic result = await DatabaseService(
                                      uid: secondButtonData['uid'])
                                  .addToCart(secondButtonData['itemCategory'],
                                      secondButtonData['itemDocId']);
                              if (result == null)
                                print('item not added');
                              else
                                print(result);
                            } else {
                              DatabaseService(uid: secondButtonData['uid'])
                                  .removeFromCart(
                                      secondButtonData['itemCategory'],
                                      secondButtonData['itemDocId']);
                            }
                          }),
                    ),
                  ],
                )
              : FlatButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * .1, vertical: _height * .025),
                  color: isNavigatable ? primaryColor : greyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(smallBorderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      firstButtonIcon != null
                          ? Icon(
                              firstButtonIcon,
                              color: whiteColor,
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.only(left: _width * .02),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: _height / _width * normalTextFontSize,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (isNavigatable) {
                      Navigator.of(context).pushNamed(routeName);
                    }
                  })));
}

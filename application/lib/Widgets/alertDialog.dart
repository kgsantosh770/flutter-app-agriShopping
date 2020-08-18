import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

alertDialog(BuildContext buildContext, String title, String content,
    String successButtonText, Function successFunction,
    {String failureButtonText, Function failureFunction}) {
  final double _width = MediaQuery.of(buildContext).size.width;
  final double _height = MediaQuery.of(buildContext).size.height;
  showDialog(
      context: buildContext,
      builder: (context) => Center(
            child: AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: _height / _width * largeTextFontSize,
                      fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: _height * .13,
                width: _width * .9,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Center(
                        child: Text(
                          content,
                          style: TextStyle(
                            color: blackColor,
                            fontSize: _height / _width * normalTextFontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          failureButtonText != null
                              ? FlatButton(
                                  onPressed: failureFunction,
                                  child: Text(
                                    failureButtonText,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize:
                                          _height / _width * normalTextFontSize,
                                    ),
                                  ))
                              : SizedBox.shrink(),
                          FlatButton(
                              onPressed: successFunction,
                              child: Text(
                                successButtonText,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize:
                                      _height / _width * normalTextFontSize,
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(smallBorderRadius))),
            ),
          ));
}

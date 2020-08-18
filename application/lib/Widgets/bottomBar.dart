import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

bottomBar({
  @required double height,
  @required double width,
  @required String firstButtonText,
  IconData firstButtonIcon,
  @required Function firstButtonAction,
  String secondButtonText,
  IconData secondButtonIcon,
  Function secondButtonAction,
  bool enabled = true,
}) {
  _buildButton({IconData icon, String buttonText, Function onTapFunction}) {
    return FlatButton(
        padding: EdgeInsets.symmetric(
            horizontal: width * .02, vertical: height * .025),
        color: enabled ? primaryColor : greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon != null
                ? Icon(
                    icon,
                    color: whiteColor,
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.only(left: width * .02),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: height / width * normalTextFontSize,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
        onPressed: enabled
            ? onTapFunction
            : () {
                print("Button not enabled");
              });
  }

  return BottomAppBar(
      color: transparentColor,
      elevation: 3,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * .02, horizontal: width * .05),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: _buildButton(
                      icon: firstButtonIcon,
                      buttonText: firstButtonText,
                      onTapFunction: firstButtonAction)),
              secondButtonText != null
                  ? SizedBox(width: width * .03)
                  : SizedBox.shrink(),
              secondButtonText != null
                  ? Expanded(
                      child: _buildButton(
                      icon: secondButtonIcon,
                      buttonText: secondButtonText,
                      onTapFunction: secondButtonAction ?? secondButtonAction,
                      // () async {
                      //   if (secondButtonData != null) {
                      //     if (secondButtonIcon == add) {
                      //       dynamic result = await DatabaseService(
                      //               uid: secondButtonData['uid'])
                      //           .addProduct(
                      //               to: 'cart',
                      //               quantity: 1,
                      //               path: secondButtonData['path'],
                      //               itemDocId:
                      //                   secondButtonData['itemDocId']);
                      //       if (result == null)
                      //         print('item not added');
                      //       else
                      //         print(result);
                      //     } else {
                      //       DatabaseService(uid: secondButtonData['uid'])
                      //           .removeProduct(
                      //               from: 'cart',
                      //               path: secondButtonData['path'],
                      //               itemDocId:
                      //                   secondButtonData['itemDocId']);
                      //     }
                      //   } else {
                      //     Navigator.of(context).pushNamed('signInScreen');
                      //   }
                      // }
                    ))
                  : SizedBox.shrink(),
            ],
          )));
}

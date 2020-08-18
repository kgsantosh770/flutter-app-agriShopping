import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Donate extends StatefulWidget {
  Donate({Key key}) : super(key: key);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String donationPeriod = 'One-Time';
  double amount = 10;
  bool isError = false;
  String error = '';

  @override
  void initState() {
    amountController.text = amount.toStringAsFixed(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return BackgroundContainer(
      child: Scaffold(
          backgroundColor: transparentColor,
          appBar: topBar(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _height * .05, horizontal: _width * .05),
              child: Column(
                children: <Widget>[
                  Text(
                    "Make a donation",
                    style: TextStyle(
                      fontSize: _height / _width * extraLargeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  errorBox(_height, _width, isError, error),
                  SizedBox(height: _height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: _height * .026, horizontal: _width * .13),
                        onPressed: () {
                          setState(() {
                            donationPeriod = 'One-Time';
                          });
                        },
                        child: Text(
                          'One-Time',
                          style: TextStyle(
                              color: donationPeriod == 'One-Time'
                                  ? primaryColor
                                  : blackColor,
                              fontSize: _height / _width * normalTextFontSize),
                        ),
                        color: whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(circularBorderRadius),
                              bottomLeft:
                                  Radius.circular(circularBorderRadius)),
                        ),
                      ),
                      SizedBox(width: _width * .002),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: _height * .026, horizontal: _width * .13),
                        onPressed: () {
                          setState(() {
                            donationPeriod = 'Monthly';
                          });
                        },
                        child: Text(
                          "Monthly",
                          style: TextStyle(
                              color: donationPeriod == 'Monthly'
                                  ? primaryColor
                                  : blackColor,
                              fontSize: _height / _width * normalTextFontSize),
                        ),
                        color: whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(circularBorderRadius),
                              bottomRight:
                                  Radius.circular(circularBorderRadius)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * .1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        rupee,
                        style: TextStyle(
                          fontSize: _height / _width * extraLargeFontSize,
                        ),
                      ),
                      SizedBox(width: _width * .03),
                      Container(
                        decoration: whiteBorder,
                        height: _height * .1,
                        width: _width * .7,
                        padding: EdgeInsets.symmetric(horizontal: _width * .03),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(9),
                            ],
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: _height / _width * 25,
                            ),
                            decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(color: transparentColor, height: 0),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isError = true;
                                  error = "Amount cannot be empty";
                                });
                                return error;
                              } else if (double.parse(value) > 100000) {
                                setState(() {
                                  isError = true;
                                  error =
                                      "Due to security reasons, we have kept the maximum amount as $rupee 1 Lakh.";
                                });
                                return error;
                              } else if (double.parse(value) < 1) {
                                setState(() {
                                  isError = true;
                                  error =
                                      "The minimum amount of donation is $rupee 1.";
                                });
                                return error;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                amount = double.parse(value);
                                print(amount);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: _width * .05),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                if (amount < 100000) {
                                  setState(() {
                                    amount = amount + 10;
                                    amountController.text =
                                        amount.toStringAsFixed(2);
                                  });
                                }
                              },
                              child: Icon(
                                arrowUp,
                                size: _height / _width * mediumIconSize,
                              )),
                          SizedBox(height: _height * .02),
                          GestureDetector(
                              onTap: () {
                                if (amount > 10) {
                                  setState(() {
                                    amount = amount - 10;
                                    amountController.text =
                                        amount.toStringAsFixed(2);
                                  });
                                }
                              },
                              child: Icon(
                                arrowDown,
                                size: _height / _width * mediumIconSize,
                              )),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: _height * .03),
                  Text(
                    "Your donation is ${NumberFormat.currency(locale: 'en_IN', symbol: rupee).format(amount)}",
                    style: TextStyle(
                      fontSize: _height / _width * mediumTextFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: _height * .05),
                  Text(
                    "Your support is vital, if we are to make a lasting difference to our farmers.",
                    style: TextStyle(
                      fontSize: _height / _width * mediumTextFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: _height * .05),
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isError = true;
                          error = 'The donation feature is currently disabled.';
                        });
                        // Navigator.pop(context, 'success');
                      }
                    },
                    padding: EdgeInsets.symmetric(vertical: _height * .025),
                    color: lightGreenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(smallBorderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Donate',
                            style: TextStyle(
                              fontSize: _height / _width * normalTextFontSize,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

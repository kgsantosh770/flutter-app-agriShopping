import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/editButton.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'loadingScreen.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({
    @required this.cardHolderName,
    @required this.cardNumber,
    @required this.expiryMonth,
    @required this.expiryYear,
  });
  final String cardHolderName;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  bool loading = false;
  bool isError = false;
  String error = '';
  bool isEditable = false;
  String _expiryMonth;
  String _expiryYear;
  List months = List.generate(12, (index) => (index + 1).toString());
  List years =
      List.generate(21, (index) => (DateTime.now().year + index).toString());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cardNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNameController.text = widget.cardHolderName;
    _cardNumberController.text = widget.cardNumber;
    _expiryMonth = widget.expiryMonth;
    _expiryYear = widget.expiryYear;
  }

  _dropDownDialog(
      double _height, double _width, List dropDownList, String title) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return Container(
            height: _height * .5,
            width: _width * .5,
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(color: blackColor),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    icon: Icon(close, color: blackColor),
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                    height: _height * .5,
                    width: _width * .4,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: dropDownList.length,
                      itemBuilder: (itemContext, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                title == 'Expiry Month'
                                    ? _expiryMonth = dropDownList[index]
                                    : _expiryYear = dropDownList[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: _height * .06,
                              width: _width * .7,
                              color: transparentColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _width * .02,
                                    vertical: _height * .015),
                                child: Center(
                                  child: Text(
                                    dropDownList[index],
                                    style: TextStyle(color: blackColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: _height * .001,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
        });
  }

  _buildCardHolderName(double height, double width) {
    return Padding(
      padding: EdgeInsets.only(top: height * .01, bottom: height * .03),
      child: TextFormField(
          enabled: isEditable,
          controller: _cardNameController,
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                isError = true;
                error = "Name cannot be empty";
              });
              return error;
            }
            return null;
          },
          keyboardType: TextInputType.text,
          onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
          style: TextStyle(color: blackColor),
          decoration: inputDecoration(height, width).copyWith(
            hintText: "eg: John Abraham",
          )),
    );
  }

  _buildCardNumber(double height, double width) {
    return Padding(
      padding: EdgeInsets.only(top: height * .01, bottom: height * .03),
      child: TextFormField(
          enabled: isEditable,
          controller: _cardNumberController,
          inputFormatters: [
            MaskedTextInputFormatter(
              mask: 'xxxx xxxx xxxx xxxx',
              separator: ' ',
            ),
            LengthLimitingTextInputFormatter(19),
          ],
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                error = "Enter card Number";
              });
              return "Enter card number";
            } else if (!VisaCardValidation()
                .validateCardNumber(value.replaceAll(' ', ''))) {
              print("error in card number");
              setState(() {
                error = "Invalid card Number";
              });
              return "Invalid card Number";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
          style: TextStyle(color: blackColor),
          decoration: inputDecoration(height, width).copyWith(
            hintText: "XXXX XXXX XXXX XXXX",
          )),
    );
  }

  _buildExpiry(double _height, double _width) {
    return Container(
      padding: EdgeInsets.only(top: _height * .01, bottom: _height * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: !isEditable
                  ? null
                  : () {
                      _dropDownDialog(_height, _width, months, 'Expiry Month');
                    },
              child: Container(
                decoration: whiteBorder.copyWith(color: whiteColor),
                margin: EdgeInsets.symmetric(horizontal: _width * .04),
                padding: EdgeInsets.symmetric(vertical: _height * .022),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        _expiryMonth,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: _height / _width * smallTextFontSize),
                      ),
                    ),
                    Icon(
                      arrowDropDown,
                      color: blackColor,
                      size: largeIconSize,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !isEditable
                  ? null
                  : () {
                      _dropDownDialog(_height, _width, years, 'Expiry Year');
                    },
              child: Container(
                decoration: whiteBorder.copyWith(color: whiteColor),
                margin: EdgeInsets.symmetric(horizontal: _width * .04),
                padding: EdgeInsets.symmetric(vertical: _height * .022),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        _expiryYear,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: _height / _width * smallTextFontSize),
                      ),
                    ),
                    Icon(
                      arrowDropDown,
                      color: blackColor,
                      size: largeIconSize,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    TextStyle labelStyle = TextStyle(
        fontSize: _height / _width * normalTextFontSize,
        fontWeight: FontWeight.bold);

    return loading
        ? Loading()
        : BackgroundContainer(
            child: Scaffold(
              backgroundColor: transparentColor,
              appBar: topBar(context),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          PageTitle(title: 'Credit Card'),
                          !isEditable
                              ? Expanded(
                                  child: editButton(
                                      height: _height,
                                      width: _width,
                                      buttonHeight: _height * .05,
                                      margin: EdgeInsets.only(
                                          top: _height * .01,
                                          right: _width * .02,
                                          left: _width * .54),
                                      onTapFunction: () {
                                        setState(() {
                                          isEditable = true;
                                        });
                                      }))
                              : SizedBox.shrink(),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .05,
                              vertical: _height * .05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Enter your credit card information. We'll save this card so you can use it again later.",
                                style: labelStyle,
                              ),
                              SizedBox(height: _height * .04),
                              Text("Name in card :", style: labelStyle),
                              _buildCardHolderName(_height, _width),
                              Text("Card number :", style: labelStyle),
                              _buildCardNumber(_height, _width),
                              Text("Expiry date :", style: labelStyle),
                              _buildExpiry(_height, _width),
                              SizedBox(height: _height * .04),
                              errorBox(_height, _width, isError, error),
                              FlatButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _height * .025),
                                  color: isEditable ? primaryColor : greyColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontSize: _height /
                                                _width *
                                                normalTextFontSize,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    if (isEditable) {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isError = false;
                                        });
                                        _formKey.currentState.save();
                                        var cardData = {
                                          'credit_card': [
                                            {
                                              'card_type': 'visa',
                                              'card_name':
                                                  _cardNameController.text,
                                              'card_number':
                                                  _cardNumberController.text,
                                              'expiry_date': {
                                                'month': _expiryMonth,
                                                'year': _expiryYear,
                                              }
                                            }
                                          ]
                                        };
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await DatabaseService(uid: user.uid)
                                                .updateUserData(cardData);
                                        setState(() {
                                          loading = false;
                                        });
                                        if (result
                                            .toString()
                                            .startsWith("Error")) {
                                          setState(() {
                                            isError = true;
                                            error =
                                                result.toString().substring(7);
                                          });
                                        } else {
                                          Navigator.pop(context, 'success');
                                        }
                                      }
                                    }
                                  }),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              // bottomNavigationBar:
              //     bottomBar(context, 'Save Card', onPressedFunction: () async {
              //   if (_formKey.currentState.validate()) {
              //     setState(() {
              //       isError = false;
              //     });
              //     _formKey.currentState.save();
              //     var cardData = {
              //       'credit_card': [
              //         {
              //           'card_type': 'visa',
              //           'card_name': _cardNameController.text,
              //           'card_number': _cardNumberController.text,
              //           'expiry_date': {
              //             'month': _expiryMonth,
              //             'year': _expiryYear,
              //           }
              //         }
              //       ]
              //     };
              //     setState(() {
              //       loading = true;
              //     });
              //     dynamic result = await DatabaseService(uid: user.uid)
              //         .updateUserData(cardData);
              //     setState(() {
              //       loading = false;
              //     });
              //     if (result.toString().startsWith("Error")) {
              //       setState(() {
              //         isError = true;
              //         error = result.toString().substring(7);
              //       });
              //     } else {
              //       Navigator.pop(context, 'success');
              //     }
              //   } else {
              //     setState(() {
              //       isError = true;
              //     });
              //   }
              // }),
            ),
          );
  }
}

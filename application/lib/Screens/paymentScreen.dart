import 'package:agri_shopping/Screens/confirmScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Payment extends StatefulWidget {
  const Payment({this.orderData});
  final Map orderData;
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String cvv;
  String cardHolderName;
  String validUntill;
  String field1, field2, field3, field4;
  String cardNumber;
  bool isSwitched = true;
  bool proceedError = true;
  bool cardNameError = true;
  bool cardNumberError = true;
  bool cardValidityError = true;
  bool cardCvvError = true;
  String paymentType = 'VISA';
  bool isValidCard;

  final GlobalKey<FormState> _cardNameFormKey = GlobalKey<FormState>();
  TextEditingController _cardNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardValidityController = TextEditingController();
  TextEditingController _cardCvvController = TextEditingController();

  checkProceed() {
    if ((!cardNameError &&
            !cardNumberError &&
            !cardValidityError &&
            !cardCvvError &&
            paymentType == 'VISA') ||
        paymentType == 'CASH') {
      proceedError = false;
    } else {
      proceedError = true;
    }
  }

  paymentOption(_height) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _height * 0.03,
      ),
      padding: EdgeInsets.all(15.0),
      height: _height * 0.14,
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              paymentType = 'VISA';
            });
            checkProceed();
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color:
                        paymentType == 'VISA' ? whiteColor : transparentColor,
                    width: 2.5)),
            child: Image.asset(
              visaImage,
              height: 70,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _cardCvvController.text = '';
              cardCvvError = true;
              paymentType = 'CASH';
            });
            checkProceed();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: paymentType == 'CASH' ? whiteColor : transparentColor,
                  width: 2.5),
            ),
            child: Image.asset(
              cashImage,
              height: 70,
            ),
          ),
        )
      ]),
    );
  }

  _buildCardHolderName(double _height, double _width) {
    return Form(
      key: _cardNameFormKey,
      child: TextFormField(
        controller: _cardNameController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(40),
        ],
        decoration: InputDecoration(
          labelText: 'Name in card',
          labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
          suffixIcon: cardNameError
              ? Icon(
                  errorIconOutline,
                  color: errorColor,
                  size: _height / _width * smallIconSize,
                )
              : Icon(
                  checkCircleOutline,
                  color: primaryColor,
                  size: _height / _width * smallIconSize,
                ),
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          if (value.length != 0 && !isOnlyNumeric(value)) {
            setState(() {
              cardHolderName = value;
              cardNameError = false;
            });
          } else {
            cardNameError = true;
          }
          checkProceed();
        },
      ),
    );
  }

  _buildCardNumber(double _height, double _width) {
    return TextFormField(
      controller: _cardNumberController,
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: 'xxxx-xxxx-xxxx-xxxx',
          separator: '-',
        ),
      ],
      decoration: InputDecoration(
        labelText: 'Card Number',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
        errorStyle: TextStyle(height: 0, color: transparentColor),
        suffixIcon: cardNumberError
            ? Icon(
                errorIconOutline,
                color: errorColor,
                size: _height / _width * smallIconSize,
              )
            : Icon(
                checkCircleOutline,
                color: primaryColor,
                size: _height / _width * smallIconSize,
              ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (cardNumberError || value.length <= 19) {
          setState(() {
            cardNumber = value.replaceAll('-', '');
            cardNumberError =
                !VisaCardValidation().validateCardNumber(cardNumber);
          });
        }
        checkProceed();
      },
    );
  }

  _buildValidUntil(double _height, double _width) {
    return TextFormField(
      controller: _cardValidityController,
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: 'xx/xx',
          separator: '/',
        ),
      ],
      decoration: InputDecoration(
        labelText: 'Expiry Date',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
        errorStyle: TextStyle(height: 0, color: transparentColor),
        suffixIcon: cardValidityError
            ? Icon(
                errorIconOutline,
                color: errorColor,
                size: _height / _width * smallIconSize,
              )
            : Icon(
                checkCircleOutline,
                color: primaryColor,
                size: _height / _width * smallIconSize,
              ),
      ),
      keyboardType: TextInputType.datetime,
      onChanged: (String value) {
        if (cardValidityError || value.length <= 5) {
          setState(() {
            validUntill = value.replaceAll('/', '');
            cardValidityError =
                !VisaCardValidation().validateExpiry(validUntill);
          });
        }
        checkProceed();
      },
    );
  }

  _buildCvv(double _height, double _width) {
    return TextFormField(
      controller: _cardCvvController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        labelText: 'CVV',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
        errorStyle: TextStyle(height: 0, color: transparentColor),
        suffixIcon: cardCvvError
            ? Icon(
                errorIconOutline,
                color: errorColor,
                size: _height / _width * smallIconSize,
              )
            : Icon(
                checkCircleOutline,
                color: primaryColor,
                size: _height / _width * smallIconSize,
              ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (cardCvvError || value.length <= 3) {
          setState(() {
            cvv = value;
            cardCvvError = !VisaCardValidation().validateCvv(cvv);
          });
        }
        checkProceed();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(bodyColor: blackColor)),
      child: BackgroundContainer(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10) {
              setState(() {
                paymentType = 'VISA';
              });
              checkProceed();
            } else if (details.delta.dx < -10) {
              setState(() {
                paymentType = 'CASH';
              });
              checkProceed();
            }
          },
          child: Scaffold(
            backgroundColor: transparentColor,
            appBar: topBar(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PageTitle(title: "Payment Options"),
                  Container(
                      child: Center(
                    child: paymentOption(_height),
                  )),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: _width * .05),
                      child: paymentType != 'CASH'
                          ? Theme(
                              data: ThemeData(
                                  cursorColor: Theme.of(context).cursorColor,
                                  primaryColor: Theme.of(context).primaryColor,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .apply(bodyColor: blackColor)),
                              child: Container(
                                decoration:
                                    whiteBorder.copyWith(color: whiteColor),
                                padding: EdgeInsets.symmetric(
                                    horizontal: _width * .04),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _buildCardHolderName(_height, _width),
                                    SizedBox(height: _height * .02),
                                    Container(
                                      child: _buildCardNumber(_height, _width),
                                    ),
                                    SizedBox(height: _height * .02),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: _buildValidUntil(
                                                _height, _width),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: _buildCvv(_height, _width),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: _height * .01),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              'Save card data for future payments'),
                                          Switch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                              });
                                            },
                                            activeTrackColor: lightGreenColor,
                                            activeColor: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "You have selected ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto-r',
                                              fontSize: _height /
                                                  _width *
                                                  normalTextFontSize,
                                            )),
                                        TextSpan(
                                            text: "Cash on devlivery (COD) ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto-r',
                                              fontSize: _height /
                                                  _width *
                                                  mediumTextFontSize,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(
                                            text:
                                                "option.\n\nYour product(s) will be delivered within 2-3 days.\n",
                                            style: TextStyle(
                                              fontFamily: 'Roboto-r',
                                              fontSize: _height /
                                                  _width *
                                                  normalTextFontSize,
                                            ))
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                ],
              ),
            ),
            bottomNavigationBar: bottomBar(
                height: _height,
                width: _width,
                firstButtonText: 'Proceed To Confirm',
                enabled: !proceedError,
                firstButtonAction: () {
                  Map orderData = {'payment_method': paymentType};
                  orderData.addAll(widget.orderData);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Confirm(
                          orderData: orderData,
                        ),
                      ));
                }),
          ),
        ),
      ),
    );
  }
}

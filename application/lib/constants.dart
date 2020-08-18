import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

// App name
String appName = ". Agri .";

// Symbols
String rupee = "\u20B9";

// Date Formats
String dateFormatter(date) => DateFormat('dd MMMM yyyy').format(date);
String getDayName(date) => DateFormat('EEEE').format(date);

// Line strike thickness
double strikeThickness = 1.8;

// Constant border sizes
double tinyBorderRadius = 6.0;
double smallBorderRadius = 8.0;
double normalBorderRadius = 10.0;
double mediumBorderRadius = 12.0;
double largeBorderRadius = 14.0;
double extraLargeBorderRadius = 23.0;
double circularBorderRadius = 25.0;

// Icon Size
double tinyIconSize = 7;
double smallIconSize = 11;
double mediumIconSize = 15;
double largeIconSize = 18;

// Font Size
double labelFontSize = 7.5;
double smallTextFontSize = 7.0;
double normalTextFontSize = 7.5;
double mediumTextFontSize = 8.5;
double largeTextFontSize = 11;
double extraLargeFontSize = 13;

// Icons
IconData errorIconOutline = Icons.error_outline;
IconData checkCircleOutline = Icons.check_circle_outline;
IconData location = Icons.location_on;
IconData iosArrowBack = Icons.arrow_back_ios;
IconData arrowBack = Icons.arrow_back;
IconData arrowDown = Icons.keyboard_arrow_down;
IconData arrowUp = Icons.keyboard_arrow_up;
IconData arrowDropUp = Icons.arrow_drop_up;
IconData arrowDropDown = Icons.arrow_drop_down;
IconData arrowForward = Icons.arrow_forward_ios;
IconData search = Icons.search;
IconData add = Icons.add;
IconData remove = Icons.remove;
IconData close = Icons.close;
IconData tick = Icons.check;
IconData delete = Icons.delete;
IconData payment = Icons.payment;
IconData calender = Icons.date_range;
IconData favorite = Icons.favorite;
IconData favoriteOutline = Icons.favorite_border;
IconData logout = Icons.exit_to_app;
IconData group = Icons.group;
IconData person = Icons.person;
IconData mail = Icons.mail;
IconData edit = Icons.edit;
IconData iphone = Icons.phone_iphone;
IconData eyeOpen = Icons.visibility;
IconData eyeClose = Icons.visibility_off;
IconData lock = Icons.lock;
IconData info = Icons.info;
IconData creditCard = Icons.credit_card;

//Material Design Icons
IconData shoppingCart = MdiIcons.cartOutline;
IconData account = MdiIcons.accountCircle;
IconData shoppingBag = MdiIcons.shopping;
IconData cash = MdiIcons.cash;
IconData address = MdiIcons.door;
IconData cardScan = MdiIcons.creditCardSettings;
//Colors
Color blackColor = Colors.black;
Color lightGreyColor = Colors.grey[200];
Color mediumGreyColor = Colors.grey[300];
Color greyColor = Colors.grey[600];
Color whiteColor = Colors.white;
Color shadowColor = Color.fromARGB(255, 240, 235, 235);
Color transparentColor = Colors.transparent;
Color primaryColor = Colors.green[600];
Color lightPrimaryColor = Color.fromARGB(255, 0, 220, 0);
Color lightGreenColor = Colors.green[500];
Color errorColor = Colors.red[800];
Color linkColor = Colors.blueAccent;
Color favoriteColor = Colors.red[400];

//images
String signinBackground = "assets/media/images/SigninBackground.jpg";
String tickAnimation = "assets/media/gif/tick.gif";
String logo = "assets/media/images/logo.png";
String logoSmall = "assets/media/images/logoSmall.png";
String visaImage = "assets/media/images/icons8-visa.png";
String cashImage = "assets/media/images/icons8-cash.png";
String fruits = "assets/media/images/fruits.jpg";
String rices = "assets/media/images/rices.jpg";
String vegetables = "assets/media/images/vegetable.jpg";
String spices = "assets/media/images/spices.jpg";

//Container Decorations
BoxDecoration blackBorder = BoxDecoration(
    border: Border.all(color: blackColor),
    borderRadius: BorderRadius.circular(smallBorderRadius));
BoxDecoration whiteBorder = BoxDecoration(
    border: Border.all(color: whiteColor),
    borderRadius: BorderRadius.circular(tinyBorderRadius));
BoxDecoration primaryColorBorder = BoxDecoration(
    border: Border.all(color: primaryColor),
    borderRadius: BorderRadius.circular(tinyBorderRadius));
BoxDecoration transparentBorder =
    BoxDecoration(borderRadius: BorderRadius.circular(tinyBorderRadius));
BoxDecoration errorBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(tinyBorderRadius),
    border: Border.all(color: errorColor));

// Input Decoration
InputDecoration inputDecoration(height, width) => InputDecoration(
    contentPadding:
        EdgeInsets.symmetric(vertical: height * .005, horizontal: width * .05),
    errorStyle: TextStyle(color: transparentColor, height: 0),
    filled: true,
    fillColor: whiteColor,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: width * .005),
    ),
    border: transparentInputBorder,
    hintStyle: TextStyle(
      fontSize: height / width * normalTextFontSize,
    ));
//Input Border
OutlineInputBorder transparentInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(tinyBorderRadius)));
//Functions
bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

bool isOnlyNumeric(String value) {
  try {
    double.parse(value);
    return true;
  } on FormatException {
    return false;
  }
}

List pullListElementToFront(List collection,
    [String textToPull = 'daily_necessities']) {
  if (collection.contains(textToPull)) collection.remove(textToPull);
  collection.insert(0, textToPull);
  return collection;
}

pullStreamElementToFront(List collectionNames, List querySnapshots,
    [String textToPull = 'daily_necessities']) {
  int index;
  Stream<QuerySnapshot> tempQuerySnapshot;

  if (collectionNames.contains(textToPull)) {
    index = collectionNames.indexOf(textToPull);
  }

  tempQuerySnapshot = querySnapshots.elementAt(index);
  querySnapshots.removeAt(index);
  querySnapshots.insert(0, tempQuerySnapshot);

  return querySnapshots;
}

String capitalizeFirstLetters(String text, {String seperator}) {
  String splitter = text.contains('_') ? '_' : '-';
  String separator = seperator ?? ' ';
  List<String> words = text.split(splitter);

  for (var i = 0; i < words.length; i++) {
    words[i] = toBeginningOfSentenceCase(words[i]);
  }
  return words.join(separator);
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) return false;
  return true;
}

RichText buildAddress(
    double _height, double _width, String name, String shippingAddress) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
      text: '$name\n',
      style: TextStyle(
        color: blackColor,
        fontWeight: FontWeight.bold,
        fontSize: _height / _width * normalTextFontSize,
      ),
    ),
    TextSpan(
      text: shippingAddress,
      style: TextStyle(
        color: blackColor,
        fontSize: _height / _width * normalTextFontSize,
      ),
    ),
  ]));
}

class VisaCardValidation {
  bool validateCardNumber(String value) {
    Map<String, dynamic> cardData = CreditCardValidator.getCard(value);
    bool isValidCard = cardData[CreditCardValidator.isValidCard];
    return isValidCard;
  }

  bool validateExpiry(String value) {
    bool result;
    int month = int.parse(value.substring(0, 2));
    int year = int.parse(value.substring(2));
    if (month >= 1 && month <= 12)
      result = year >= 20 && year <= 80 ? true : false;
    else
      result = false;
    return result;
  }

  bool validateCvv(String value) {
    bool result;
    try {
      double.parse(value);
      result = value.length == 3 ? true : false;
    } catch (e) {
      result = false;
    }
    return result;
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

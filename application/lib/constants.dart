import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

//Symbols
String rupee = "\u20B9";

//Date Formats
String formatter(date) => DateFormat('d MMMM yy').format(date);

//constant sizes
double smallBorderRadius = 8.0;

//Font Size
double tinyIconSize = 8;
double smallIconSize = 11;
double mediumIconSize = 14;
double labelFontSize = 7.5;
double smallTextFontSize = 7.0;
double normalTextFontSize = 8.0;
double mediumTextFontSize = 10.5;
double largeTextFontSize = 12;
double extraLargeFontSize = 16;

//Icons
IconData errorIconOutline = Icons.error_outline;
IconData checkCircleOutline = Icons.check_circle_outline;
IconData iosArrowBack = Icons.arrow_back_ios;
IconData arrowBack = Icons.arrow_back;
IconData arrowDown = Icons.arrow_downward;
IconData arrowDropDown = Icons.arrow_drop_down;
IconData arrowForward = Icons.arrow_forward_ios;
IconData search = Icons.search;
IconData copyRights = Icons.copyright;
IconData add = Icons.add;
IconData remove = Icons.remove;
IconData tick = Icons.check;
IconData delete = Icons.delete;
IconData payment = Icons.payment;
IconData calender = Icons.date_range;
IconData favorite = Icons.favorite;
IconData favoriteOutline = Icons.favorite_border;
IconData logout = Icons.exit_to_app;
IconData help = Icons.help;
IconData person = Icons.person;
IconData edit = Icons.edit;

//Material Design Icons
IconData shoppingCart = MdiIcons.cartOutline;
IconData account = MdiIcons.accountCircle;
IconData shoppingBag = MdiIcons.shopping;
IconData cash = MdiIcons.cash;
IconData address = MdiIcons.door;

//Colors
Color blackColor = Colors.black;
Color lightGreyColor = Colors.grey[200];
Color mediumGreyColor = Colors.grey[300];
Color greyColor = Colors.grey[600];
Color whiteColor = Colors.white;
Color shadowColor = Color.fromARGB(255, 240, 235, 235);
Color transparentColor = Colors.transparent;
Color primaryColor = Colors.green[600];
Color lightPrimaryColor = Color.fromARGB(255, 0, 230, 0);
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
    borderRadius: BorderRadius.circular(8.0));
BoxDecoration whiteBorder = BoxDecoration(
    border: Border.all(color: whiteColor),
    borderRadius: BorderRadius.circular(8.0));
BoxDecoration primaryColorBorder = BoxDecoration(
    border: Border.all(color: primaryColor),
    borderRadius: BorderRadius.circular(8.0));
BoxDecoration transparentBorder =
    BoxDecoration(borderRadius: BorderRadius.circular(8.0));
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

String capitalizeFirstLetters(String text) {
  String splitter = text.contains('_') ? '_' : '-';
  String separator = ' ';
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

Padding suggestionChip(
    BuildContext context, double _height, double _width, String suggestionText,
    [String navigationScreen]) {
  return Padding(
    padding: EdgeInsets.only(right: _width * .02),
    child: GestureDetector(
      onTap: () {
        if (navigationScreen != null) {
          Navigator.of(context).pushNamed(navigationScreen);
        }
      },
      child: Text(capitalizeFirstLetters(suggestionText),
          style: TextStyle(
            color: whiteColor,
            fontSize: _height / _width * normalTextFontSize,
            fontFamily: 'Roboto-r',
            fontWeight: FontWeight.bold,
          )),
    ),
  );
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

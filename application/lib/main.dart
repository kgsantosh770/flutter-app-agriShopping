import 'package:agri_shopping/Screens/landingScreen.dart';
import 'package:agri_shopping/Screens/orderScreen.dart';
import 'package:agri_shopping/Screens/productScreen.dart';
import 'package:agri_shopping/Screens/settings/addressScreen.dart';
import 'package:agri_shopping/Screens/settings/editProfile.dart';
import 'package:agri_shopping/Screens/singleProductScreen.dart';
import 'package:agri_shopping/Screens/settings/settingsScreen.dart';
import 'package:agri_shopping/Screens/tickScreen.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/confirmScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/paymentScreen.dart';
import 'Screens/signInScreen.dart';
import 'Screens/signUpScreen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: _auth.user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agri Shopping',
        routes: {
          'landingScreen': (context) => Landing(),
          'homeScreen': (context) => Home(),
          'signInScreen': (context) => SignIn(),
          'signUpScreen': (context) => SignUp(),
          'paymentScreen': (context) => Payment(),
          'confirmScreen': (context) => Confirm(),
          'settingsScreen': (context) => Settings(),
          'editProfileScreen': (context) => EditProfile(),
          'productScreen': (context) => Product(),
          'singleProductScreen': (context) => SingleProduct(),
          'tickScreen': (context) => Tick(),
          'orderScreen': (context) => Order(),
          'addressScreen': (context) => Address(),
        },
        theme: ThemeData(
            iconTheme: IconThemeData(color: whiteColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: primaryColor,
            cursorColor: primaryColor,
            fontFamily: 'roboto-r',
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: whiteColor)),
        home: Home(),
      ),
    );
  }
}

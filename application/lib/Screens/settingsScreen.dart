import 'package:agri_shopping/Screens/cardScreen.dart';
import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/addressScreen.dart';
import 'package:agri_shopping/Screens/editProfile.dart';
import 'package:agri_shopping/Widgets/alertDialog.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/cart.dart';
import 'package:agri_shopping/Widgets/favorite.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map userData;
  Map staticData;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    ListTile optionTitle(
        IconData iconName, String option, Function onTapFunction) {
      return ListTile(
        title: option == 'Not'
            ? Text('Logout',
                style: TextStyle(
                  fontSize: _height / _width * 10,
                ))
            : GestureDetector(
                onTap: onTapFunction,
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: _height / _width * 10,
                  ),
                ),
              ),
        leading: IconButton(
          icon: Icon(
            iconName,
            color: whiteColor,
            size: _height / _width * 15,
          ),
          onPressed: () {},
        ),
      );
    }

    return BackgroundContainer(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: transparentColor,
          appBar: topBar(context),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              user != null
                  ? StreamBuilder(
                      stream: CombineLatestStream.list([
                        DatabaseService(uid: user.uid).userData,
                        DatabaseService().staticData
                      ]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        } else {
                          final userData = snapshot.data[0].data;
                          final staticData = snapshot.data[1].data;

                          return Column(
                            children: <Widget>[
                              optionTitle(account, 'Hi. ' + userData['name'],
                                  () async {
                                final result = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    userData: userData,
                                    supportedCountryCodes:
                                        staticData['supported_country_codes'],
                                  ),
                                ));
                                if (result == 'success') {
                                  alertDialog(
                                      context,
                                      "Success",
                                      "You have successfully changed your account.",
                                      "Ok", () {
                                    Navigator.pop(context);
                                  });
                                }
                              }),
                              optionTitle(shoppingCart, 'Cart',
                                  () => Cart(context, user.uid).openCart()),
                              optionTitle(shoppingBag, 'Your orders', () {
                                Navigator.pushNamed(context, 'orderScreen');
                              }),
                              optionTitle(
                                  favorite,
                                  'Favourites',
                                  () => Favorite(context, user.uid)
                                      .openFavorites()),
                              optionTitle(account, 'Your Address', () async {
                                final result = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => Address(
                                    editable: false,
                                    deliverableStates:
                                        staticData['deliverable_states'],
                                    deliverableCountries:
                                        staticData['deliverable_countries'],
                                    userAddress: userData['default_address'],
                                  ),
                                ));
                                if (result == 'success') {
                                  alertDialog(
                                      context,
                                      "Success",
                                      "You have successfully changed your address",
                                      "Ok", () {
                                    Navigator.pop(context);
                                  });
                                }
                              }),
                              optionTitle(payment, 'Your Card', () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreditCard(
                                              cardHolderName:
                                                  userData['credit_card'][0]
                                                      ['card_name'],
                                              cardNumber:
                                                  userData['credit_card'][0]
                                                      ['card_number'],
                                              expiryMonth:
                                                  userData['credit_card'][0]
                                                      ['expiry_date']['month'],
                                              expiryYear:
                                                  userData['credit_card'][0]
                                                      ['expiry_date']['year'],
                                            )));
                                if (result == 'success') {
                                  alertDialog(
                                      context,
                                      "Success",
                                      "You have successfully changed your credit card.",
                                      "Ok", () {
                                    Navigator.pop(context);
                                  });
                                }
                              }),
                              optionTitle(logout,
                                  'Not ${userData['name']}?\t\t\t\tLogout',
                                  () async {
                                alertDialog(
                                    context,
                                    'Confirmation',
                                    'Do you want to signout ?',
                                    'Confirm',
                                    () async {
                                      dynamic result = await _auth.signOut();
                                      if (result
                                          .toString()
                                          .startsWith('Error')) {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Error occurred. Please try again later.'),
                                        ));
                                      }
                                      Navigator.pushNamed(
                                          context, 'homeScreen');
                                    },
                                    failureButtonText: 'Cancel',
                                    failureFunction: () {
                                      Navigator.pop(context);
                                    });
                              })
                            ],
                          );
                        }
                      })
                  : optionTitle(account, 'Hi. SignIn', () {
                      Navigator.pushNamed(context, 'signInScreen');
                    }),
              optionTitle(cash, 'Donate To Farmers', () {
                Navigator.pushNamed(context, 'donateScreen');
              }),
              optionTitle(group, 'About Us', () {
                Navigator.pushNamed(context, 'aboutUsScreen');
              }),
              optionTitle(person, 'Contact Us', () async {
                final result =
                    await Navigator.pushNamed(context, 'contactUsScreen');
                if (result == 'success') {
                  alertDialog(
                      context,
                      "Success",
                      "Message has been sent successfully. We will contact you soon.",
                      "Ok", () {
                    Navigator.pop(context);
                  });
                }
              }),
            ],
          ))),
    );
  }
}

import 'package:agri_shopping/Screens/settings/addressScreen.dart';
import 'package:agri_shopping/Screens/settings/editProfile.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/cart.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    ListTile optionsListTile(IconData iconName, String option) {
      return ListTile(
        title: option == 'Not'
            ? Text('Logout',
                style: TextStyle(
                  fontSize: _height / _width * 10,
                ))
            : Text(
                option,
                style: TextStyle(
                  fontSize: _height / _width * 10,
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
          appBar: topBar(context, _height, _width),
          body: ListView(
            children: <Widget>[
              user != null
                  ? StreamBuilder(
                      stream: CombineLatestStream.list([
                        DatabaseService(uid: user.uid).userData,
                        DatabaseService().staticData
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userData = snapshot.data[0];
                          final supportedCountryCodes =
                              snapshot.data[1].data['supported_country_codes'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  countryCode: userData['phone']
                                      ['country_code'],
                                  supportedCountryCodes: supportedCountryCodes,
                                ),
                              ));
                            },
                            child: optionsListTile(
                                account, 'Hi. ' + userData.data['name']),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      })
                  : optionFunction(context, user, 'signInScreen',
                      optionsListTile(account, 'Hi. SignIn')),
              GestureDetector(
                  onTap: () {
                    user != null
                        ? Cart(context, _height, _width).openCart()
                        : Navigator.of(context).pushNamed('signInScreen');
                  },
                  child: optionsListTile(shoppingCart, 'Cart')),
              optionFunction(context, user, 'orderScreen',
                  optionsListTile(shoppingBag, 'Your orders')),
              optionFunction(context, user, 'paymentScreen',
                  optionsListTile(favorite, 'Favourites')),
              user != null
                  ? StreamBuilder(
                      stream: CombineLatestStream.list([
                        DatabaseService(uid: user.uid).userData,
                        DatabaseService().staticData
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userAddress =
                              snapshot.data[0].data['default_address'];
                          final deliverableCountries =
                              snapshot.data[1].data['deliverable_countries'];
                          final deliverableStates =
                              snapshot.data[1].data['deliverable_states'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Address(
                                  deliverableStates: deliverableStates,
                                  currentState: userAddress['state'],
                                  deliverableCountries: deliverableCountries,
                                  currentCountry: userAddress['country'],
                                ),
                              ));
                            },
                            child: optionsListTile(account, 'Your Address'),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      })
                  : optionFunction(context, user, 'signInScreen',
                      optionsListTile(account, 'Your Address')),
              optionFunction(context, user, 'paymentScreen',
                  optionsListTile(payment, 'Your Payment')),
              GestureDetector(
                  onTap: () async {
                    if (user != null) {
                      dynamic result = await _auth.signOut();
                      if (result.toString().startsWith('Error')) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content:
                              Text('Error occurred. Please try again later.'),
                        ));
                      } else {
                        dynamic result = await _auth.signInAnonymous();
                        if (!result.toString().startsWith('Error'))
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              'homeScreen', (route) => false);
                      }
                    } else
                      Navigator.of(context).pushNamed('signInScreen');
                  },
                  child:
                      optionsListTile(logout, user != null ? 'Not' : 'SignIn')),
              optionsListTile(cash, 'Donate To Farmers'),
              optionsListTile(help, 'Help'),
              optionsListTile(person, 'Contact Us'),
            ],
          )),
    );
  }

  GestureDetector optionFunction(
      BuildContext context, FirebaseUser user, String routeName, Widget child) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(user == null ? 'signInScreen' : routeName);
      },
      child: child,
    );
  }
}

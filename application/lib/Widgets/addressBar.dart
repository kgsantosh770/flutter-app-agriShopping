import 'package:agri_shopping/Screens/addressScreen.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

addressBar(BuildContext context) {
  final user = Provider.of<FirebaseUser>(context);
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  return StreamBuilder(
      stream: CombineLatestStream.list([
        DatabaseService(uid: user.uid).userData,
        DatabaseService().staticData
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data[0].data['default_address']['name'] == '') {
          final userAddress = snapshot.data[0].data['default_address'];
          final deliverableCountries =
              snapshot.data[1].data['deliverable_countries'];
          final deliverableStates = snapshot.data[1].data['deliverable_states'];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Address(
                  editable: true,
                  deliverableStates: deliverableStates,
                  deliverableCountries: deliverableCountries,
                  userAddress: userAddress,
                ),
              ));
            },
            child: Container(
              color: whiteColor.withOpacity(.2),
              height: _height * .06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    location,
                    size: largeIconSize,
                  ),
                  SizedBox(width: _width * .02),
                  Text(
                    "Set your delivery location.",
                  ),
                  SizedBox(width: _width * .02),
                  Icon(
                    arrowForward,
                    size: mediumIconSize,
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      });
}

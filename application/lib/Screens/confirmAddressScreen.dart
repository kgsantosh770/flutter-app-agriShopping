import 'package:agri_shopping/Screens/addressScreen.dart';
import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Screens/paymentScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ConfirmAddress extends StatefulWidget {
  const ConfirmAddress({this.orderData});
  final Map orderData;

  @override
  _ConfirmAddressState createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final user = Provider.of<FirebaseUser>(context);

    return BackgroundContainer(
      child: StreamBuilder(
          stream: CombineLatestStream.list([
            DatabaseService(uid: user.uid).userData,
            DatabaseService().staticData
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              final userAddress = snapshot.data[0].data['default_address'];
              final deliverableCountries =
                  snapshot.data[1].data['deliverable_countries'];
              final deliverableStates =
                  snapshot.data[1].data['deliverable_states'];
              final shippingAddress =
                  "${userAddress['house_number']}\n${userAddress['area']},\n${userAddress['landmark']},\n${userAddress['city']}, ${userAddress['state']} ${userAddress['pincode']}\n${userAddress['country']}";
              return Scaffold(
                backgroundColor: transparentColor,
                appBar: topBar(context),
                body: Column(
                  children: <Widget>[
                    PageTitle(title: "Confirm Delivery Address"),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _width * .05, vertical: _height * .05),
                      padding: EdgeInsets.symmetric(
                          vertical: _height * .02, horizontal: _width * .05),
                      decoration: transparentBorder.copyWith(color: whiteColor),
                      width: _width * .8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Delivery Address',
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: _height / _width * mediumTextFontSize,
                            ),
                          ),
                          SizedBox(height: _height * .05),
                          buildAddress(_height, _width,
                              userAddress['name'].toString(), shippingAddress),
                          SizedBox(height: _height * .05),
                          GestureDetector(
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
                            child: Text(
                              'Change Address ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      _height / _width * mediumTextFontSize,
                                  color: primaryColor),
                            ),
                          ),
                          SizedBox(height: _height * .05),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: bottomBar(
                    height: _height,
                    width: _width,
                    firstButtonText: 'Proceed To Payment',
                    firstButtonAction: () {
                      Map orderData = {
                        'shipping_address':
                            '${userAddress['name']}:$shippingAddress'
                      };
                      orderData.addAll(widget.orderData);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Payment(
                              orderData: orderData,
                            ),
                          ));
                    }),
              );
            }
          }),
    );
  }
}

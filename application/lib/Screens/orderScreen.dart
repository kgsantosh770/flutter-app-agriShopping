import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  const Order({this.successMessage});
  final String successMessage;
  @override
  _OrderState createState() => _OrderState();
}

// final Map<String, Map<String, dynamic>> orders = {
//   'A': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'B': {
//     'is_delivered': false,
//     'delivered_date': '17 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'C': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'D': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'E': {
//     'is_delivered': false,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'F': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'G': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'H': {
//     'is_delivered': false,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
//   'I': {
//     'is_delivered': true,
//     'delivered_date': '19 Jul 2020',
//     'ordered_date': '15 Jul 2020'
//   },
// };

class _OrderState extends State<Order> {
  bool loading = false;

  List<String> sortById(List<String> keys) {
    for (var i = 0; i < keys.length; i++) {
      for (var j = i + 1; j < keys.length; j++) {
        if (int.parse(keys[j].substring(4)) > int.parse(keys[i].substring(4))) {
          String temp = keys[j];
          keys[j] = keys[i];
          keys[i] = temp;
        }
      }
    }
    return keys;
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushNamedAndRemoveUntil(context, 'homeScreen', (route) => false);
    return true;
  }

  Future<bool> _willGoBack() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        if (widget.successMessage != null)
          return _willPopCallback();
        else
          return _willGoBack();
      },
      child: loading
          ? Loading()
          : BackgroundContainer(
              child: Theme(
                data: ThemeData(
                    textTheme: Theme.of(context)
                        .textTheme
                        .apply(bodyColor: blackColor)),
                child: Scaffold(
                  backgroundColor: transparentColor,
                  appBar: topBar(context),
                  body: Column(
                    children: <Widget>[
                      PageTitle(title: "Orders"),
                      widget.successMessage == null
                          ? SizedBox.shrink()
                          : errorBox(
                              _height, _width, true, widget.successMessage,
                              errorTitle: "Success"),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .05,
                              vertical: _height * .02),
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: DatabaseService(uid: user.uid).userData,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Loading();
                                else {
                                  final Map orders =
                                      snapshot.data.data['orders'];
                                  final sortedOrderId =
                                      sortById(orders.keys.toList());
                                  return ListView.builder(
                                    itemCount: sortedOrderId.length,
                                    itemBuilder: (context, index) {
                                      final String orderId =
                                          sortedOrderId[index];
                                      final String orderedDate =
                                          orders[orderId]['order_date'];
                                      final String deliveredDate =
                                          orders[orderId]['delivered_date'];
                                      return Container(
                                          decoration: transparentBorder
                                              .copyWith(color: whiteColor),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: _width * .02,
                                              vertical: _height * .01),
                                          margin: EdgeInsets.only(
                                              bottom: _height * .02),
                                          height: _height * .12,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      deliveredDate != null
                                                          ? 'Delivered on $deliveredDate'
                                                          : 'Estimated Delivery on or before ${orders[orderId]['guaranteed_delivery']}',
                                                      style: TextStyle(
                                                        color: deliveredDate !=
                                                                null
                                                            ? primaryColor
                                                            : errorColor,
                                                        fontSize: _height /
                                                            _width *
                                                            smallTextFontSize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(
                                                    'Order Id : $orderId',
                                                    style: TextStyle(
                                                      fontSize: _height /
                                                          _width *
                                                          mediumTextFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Ordered on $orderedDate',
                                                    style: TextStyle(
                                                        fontSize: _height /
                                                            _width *
                                                            smallTextFontSize,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundImage:
                                                      AssetImage(fruits),
                                                  maxRadius: _height /
                                                      _width *
                                                      extraLargeBorderRadius),
                                            ],
                                          )
                                          // ListTile(
                                          //   title: Padding(
                                          //     padding: EdgeInsets.only(
                                          //         top: _height * .005),
                                          //     child: Text(
                                          //       'Order Id : $orderId',
                                          //       style: TextStyle(
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   subtitle: Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     children: <Widget>[
                                          //       Flexible(
                                          //         child: Text(
                                          //           orderedDate,
                                          //           style: TextStyle(
                                          //               fontSize: _height /
                                          //                   _width *
                                          //                   smallTextFontSize,
                                          //               color: Colors.black),
                                          //         ),
                                          //       ),
                                          //       SizedBox(height: _height * .01),
                                          //       Flexible(
                                          //         child: Text(
                                          //           deliveredDate != null
                                          //               ? 'Delivered on $deliveredDate'
                                          //               : 'Estimated Delivery on ${orders[orderId]['guaranteed_delivery']}',
                                          //           style: TextStyle(
                                          //             color: deliveredDate != null
                                          //                 ? primaryColor
                                          //                 : errorColor,
                                          //             fontSize: _height /
                                          //                 _width *
                                          //                 smallTextFontSize,
                                          //             fontWeight: FontWeight.bold,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          //   trailing: CircleAvatar(
                                          //     backgroundImage: AssetImage(fruits),
                                          //     maxRadius: _height /
                                          //         _width *
                                          //         mediumIconSize,
                                          //   ),
                                          //   isThreeLine: true,
                                          // ),
                                          );
                                    },
                                  );
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

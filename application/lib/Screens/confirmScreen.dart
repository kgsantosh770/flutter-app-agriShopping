import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Confirm extends StatefulWidget {
  const Confirm({this.orderData});
  final Map orderData;
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool loading = false;
  bool isError = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final double deliveryCharge = 40.0;
    final double orderTotal = deliveryCharge +
        widget.orderData['total'] -
        widget.orderData['discount_price'];
    final discountPercent =
        (widget.orderData['discount_price'] / widget.orderData['total']) * 100;
    final DateTime guaranteedDelivery = DateTime.now().add(Duration(days: 7));

    _outerContainer({Widget child}) {
      return Center(
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _height * .02, horizontal: _width * .09),
            decoration: transparentBorder.copyWith(color: whiteColor),
            width: _width * .9,
            child: child),
      );
    }

    _buildOrderConfirmation() {
      return _outerContainer(
          child: Column(
        children: <Widget>[
          Text(
            "Order Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * mediumTextFontSize,
            ),
          ),
          SizedBox(height: _height * .05),
          confirmDetails(_height, _width, 'Items :',
              '$rupee ${widget.orderData['total'].toStringAsFixed(2)}'),
          widget.orderData['discount_price'] != 0
              ? confirmDetails(_height, _width, 'Total Discount :',
                  '- $rupee ${widget.orderData['discount_price'].toStringAsFixed(2)}')
              : SizedBox.shrink(),
          widget.orderData['discount_price'] != 0
              ? confirmDetails(_height, _width, 'Subtotal :',
                  '$rupee ${(widget.orderData['total'] - widget.orderData['discount_price']).toStringAsFixed(2)}')
              : SizedBox.shrink(),
          confirmDetails(_height, _width, 'Delivery :',
              '$rupee ${deliveryCharge.toStringAsFixed(2)}'),
          confirmDetails(_height, _width, 'Order Total :',
              '$rupee ${orderTotal.toStringAsFixed(2)}',
              isBold: true),
          widget.orderData['discount_price'] != 0
              ? SizedBox(height: _height * .02)
              : SizedBox.shrink(),
          widget.orderData['discount_price'] != 0
              ? confirmDetails(_height, _width, "Your Savings :",
                  "$rupee ${widget.orderData['discount_price'].toStringAsFixed(2)} (${discountPercent.round()}%)",
                  textColor: errorColor, isBold: true)
              : SizedBox.shrink(),
        ],
      ));
    }

    _buildItems() {
      return _outerContainer(
          child: Column(
        children: <Widget>[
          Text(
            "Order Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * mediumTextFontSize,
            ),
          ),
          SizedBox(height: _height * .05),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.orderData['items'].length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return confirmDetails(_height, _width, 'Items ', 'Quantity',
                    isBold: true);
              } else {
                String title = capitalizeFirstLetters(
                    widget.orderData['items'].entries.elementAt(index - 1).key);
                String description = widget.orderData['items'].entries
                    .elementAt(index - 1)
                    .value['quantity']
                    .toString();
                String measure = widget.orderData['items'].entries
                    .elementAt(index - 1)
                    .value['measure']
                    .toString();
                return confirmDetails(
                    _height, _width, title, '$description $measure');
              }
            },
          )
        ],
      ));
    }

    _buildDeliveryConfirmation() {
      return _outerContainer(
          child: Column(
        children: <Widget>[
          Text(
            'Guaranteed Delivery on or before',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * mediumTextFontSize,
            ),
          ),
          SizedBox(height: _height * .05),
          Text(
            '${dateFormatter(guaranteedDelivery)}\t\t(${getDayName(guaranteedDelivery)})',
            style: TextStyle(
              fontSize: _height / _width * normalTextFontSize,
            ),
          ),
        ],
      ));
    }

    _buildAddressConfirmation() {
      return _outerContainer(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Shipping Address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * mediumTextFontSize,
            ),
          ),
          SizedBox(height: _height * .05),
          Align(
            alignment: Alignment.topLeft,
            child: buildAddress(
                _height,
                _width,
                widget.orderData['shipping_address'].split(':')[0],
                widget.orderData['shipping_address'].split(':')[1]),
          ),
          SizedBox(height: _height * .05),
        ],
      ));
    }

    _buildPaymentConfirmation() {
      return _outerContainer(
          child: Column(
        children: <Widget>[
          Text(
            'Payment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / _width * mediumTextFontSize,
            ),
          ),
          SizedBox(height: _height * .05),
          confirmDetails(_height, _width, "Payment Type",
              widget.orderData['payment_method'].toString()),
          SizedBox(height: _height * .04),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Change payment type',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _height / _width * normalTextFontSize,
                  color: primaryColor),
            ),
          ),
        ],
      ));
    }

    return loading
        ? Loading()
        : Theme(
            data: ThemeData(
                textTheme:
                    Theme.of(context).textTheme.apply(bodyColor: blackColor)),
            child: BackgroundContainer(
              child: StreamBuilder(
                  stream: CombineLatestStream.list([
                    DatabaseService(uid: user.uid).userData,
                    DatabaseService().staticData
                  ]),
                  builder: (streamContext, snapshot) {
                    if (!snapshot.hasData)
                      return Loading();
                    else {
                      final Map userOrders = snapshot.data[0].data['orders'];
                      final Map allOrders = snapshot.data[1].data['all_orders'];
                      final totalOrders =
                          snapshot.data[1].data['all_orders'].keys.length;
                      final orderId = 'AGRI$totalOrders';
                      return Scaffold(
                        appBar: topBar(context),
                        bottomNavigationBar: bottomBar(
                            height: _height,
                            width: _width,
                            firstButtonText: 'Confirm Order and Pay',
                            firstButtonAction: () async {
                              Map generatedData = {
                                'order_date': dateFormatter(DateTime.now()),
                                'order_total': orderTotal.toString(),
                                'guaranteed_delivery':
                                    dateFormatter(guaranteedDelivery),
                                'delivery_stage': 0,
                                'delivered_date': null,
                              };

                              generatedData.addAll(widget.orderData);

                              Map allOrderData = {'uid': user.uid};
                              allOrderData.addAll(generatedData);
                              allOrders[orderId] = allOrderData;

                              userOrders[orderId] = generatedData;

                              setState(() {
                                loading = true;
                              });

                              dynamic result1 = await DatabaseService()
                                  .updateStaticOrderData(
                                      {'all_orders': allOrders});
                              dynamic result2 =
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData({'orders': userOrders});
                              if (widget.orderData['type'] == 'multiple')
                                DatabaseService(uid: user.uid).updateUserData({
                                  'cart': {
                                    'total': 0,
                                    'total_with_discount': 0,
                                    'order': []
                                  }
                                });
                              setState(() {
                                loading = false;
                              });

                              if (result1.toString().startsWith("Error")) {
                                setState(() {
                                  isError = true;
                                  error = result1;
                                });
                              } else if (result2
                                  .toString()
                                  .startsWith("Error")) {
                                setState(() {
                                  isError = true;
                                  error = result2;
                                });
                              } else {
                                Navigator.pushNamed(context, 'tickScreen');
                              }
                            }),
                        backgroundColor: transparentColor,
                        body: Padding(
                          padding: EdgeInsets.only(top: _height * .045),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                isError
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom: _height * .05),
                                        child: errorBox(
                                            _height, _width, isError, error),
                                      )
                                    : SizedBox.shrink(),
                                _buildOrderConfirmation(),
                                SizedBox(height: _height * .05),
                                _buildItems(),
                                SizedBox(height: _height * .05),
                                _buildDeliveryConfirmation(),
                                SizedBox(height: _height * .05),
                                _buildAddressConfirmation(),
                                SizedBox(height: _height * .05),
                                _buildPaymentConfirmation(),
                                SizedBox(height: _height * .05),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          );
  }

  confirmDetails(
      double _height, double _width, String title, String description,
      {Color textColor, bool isBold}) {
    return Padding(
      padding: EdgeInsets.only(bottom: _height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: textColor ?? blackColor,
              fontSize: isBold != null
                  ? _height / _width * mediumTextFontSize
                  : _height / _width * normalTextFontSize,
              fontWeight: isBold != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: isBold != null
                  ? _height / _width * mediumTextFontSize
                  : _height / _width * normalTextFontSize,
              fontWeight: isBold != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

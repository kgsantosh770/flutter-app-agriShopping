import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';
import 'package:agri_shopping/Widgets/topBar.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

final Map<String, Map<String, dynamic>> orders = {
  'A': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'B': {
    'is_delivered': false,
    'delivered_date': '17 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'C': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'D': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'E': {
    'is_delivered': false,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'F': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'G': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'H': {
    'is_delivered': false,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
  'I': {
    'is_delivered': true,
    'delivered_date': '19 Jul 2020',
    'ordered_date': '15 Jul 2020'
  },
};

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: transparentColor,
      appBar: topBar(context, _height, _width),
      body: Column(
        children: <Widget>[
          PageTitle(title: "Orders"),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final String itemName = orders.keys.toList()[index];
                  final String orderedDate =
                      orders.values.toList()[index]['ordered_date'];
                  final bool isDelivered =
                      orders.values.toList()[index]['is_delivered'];
                  final String deliveredDate =
                      orders.values.toList()[index]['delivered_date'];
                  return Container(
                    height: _height * .13,
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: _height * .01, horizontal: _width * .02),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(top: _height * .005),
                          child: Text(
                            itemName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                orderedDate,
                                style: TextStyle(
                                    fontSize:
                                        _height / _width * smallTextFontSize,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: _height * .01),
                            Flexible(
                              child: Text(
                                isDelivered
                                    ? 'Delivered on $deliveredDate'
                                    : 'Estimated Delivery on $deliveredDate',
                                style: TextStyle(
                                  color:
                                      isDelivered ? primaryColor : errorColor,
                                  fontSize:
                                      _height / _width * smallTextFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          backgroundImage: AssetImage(fruits),
                          maxRadius: _height / _width * mediumIconSize,
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

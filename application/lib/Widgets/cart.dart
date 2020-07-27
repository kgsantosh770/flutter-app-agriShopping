import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class Cart {
  Cart(this.context, this.height, this.width);
  var context;
  final double height;
  final double width;

  Container cartItem(
      String item, double price, double quantity, String measure) {
    double total = price * quantity;
    return Container(
      padding: EdgeInsets.only(
        right: width * .02,
        bottom: height * .03,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item != 'Total'
                      ? <Widget>[
                          Container(
                            width: width * .42,
                            child: Text(item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: height / width * 10,
                                  fontFamily: 'Roboto-r',
                                )),
                          ),
                          SizedBox(height: height * .005),
                          Text('\u20B9 $total',
                              style: TextStyle(
                                color: lightGreenColor,
                                fontSize: height / width * 7.5,
                                fontFamily: 'Roboto-m',
                              )),
                        ]
                      : <Widget>[
                          Text(item,
                              style: TextStyle(
                                  fontSize: height / width * 14,
                                  fontFamily: 'Roboto-m',
                                  fontWeight: FontWeight.bold)),
                        ],
                ),
                Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: item != 'Total'
                        ? <Widget>[
                            Container(
                                height: height * .055,
                                child: Row(children: <Widget>[
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      quantity <= 0.5 ? delete : remove,
                                      size: height / width * 9,
                                    ),
                                  ),
                                  Text(quantity.toString(),
                                      style: TextStyle(
                                          fontFamily: 'roboto-r',
                                          fontSize: height / width * 9,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      add,
                                      size: height / width * 9,
                                    ),
                                  ),
                                ])),
                            Padding(
                              padding: EdgeInsets.only(left: width * .02),
                              child: Text(measure,
                                  style: TextStyle(
                                    fontSize: height / width * 9,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ]
                        : <Widget>[
                            Text('\u20B9 $total',
                                style: TextStyle(
                                  color: lightGreenColor,
                                  fontSize: height / width * 10.5,
                                  fontFamily: 'Roboto-m',
                                )),
                          ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openCart() {
    showModalBottomSheet(
        elevation: 3.0,
        isScrollControlled: true,
        barrierColor: blackColor.withOpacity(.65),
        backgroundColor: transparentColor,
        context: context,
        builder: (builder) {
          return Container(
            height: height * 0.78,
            color: blackColor,
            child: Stack(
              children: <Widget>[
                Container(
                  height: height * .08,
                  color: primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .035),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * .02, left: width * .02),
                        child: Text("My Cart",
                            style: TextStyle(
                              fontSize: height / width * 13,
                              fontFamily: 'Roboto-m',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height * .02, bottom: height * .025),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              cartItem("Apple", 40, 1, "kg"),
                              cartItem("Carrot", 20, 0.5, "kg"),
                              cartItem("Apple", 40, 1, "kg"),
                              cartItem("Carrot", 20, 4, "g"),
                              cartItem("Custard Apple", 40, 1, "kg"),
                              cartItem("Carrot", 20, 4, "kg"),
                              cartItem("Total", 400, 1, "kg")
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: height * .1,
                          width: width * .9,
                          padding: EdgeInsets.symmetric(
                              vertical: height * .01, horizontal: width * .05),
                          child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * .05,
                                  vertical: height * .025),
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: height / width * 9,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('paymentScreen');
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

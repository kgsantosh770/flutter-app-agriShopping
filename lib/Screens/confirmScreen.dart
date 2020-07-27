import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/roundedImageContainer.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/Widgets/bottomBar.dart';

import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final String address =
        "7, Narasimapuram, Kamarajar, Salai, Madurai, TamilNadu, India - 625009 ";
    return Theme(
      data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(bodyColor: blackColor)),
      child: BackgroundContainer(
        child: Scaffold(
          appBar: topBar(context, _height, _width),
          bottomNavigationBar: bottomBar(
            context,
            _height,
            _width,
            'Confirm Order and Pay',
            isNavigatable: true,
            routeName: 'tickScreen',
          ),
          backgroundColor: transparentColor,
          body: Padding(
            padding: EdgeInsets.only(top: _height * .045),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: _width * .06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration:
                                transparentBorder.copyWith(color: whiteColor),
                            height: _height * .4,
                            width: _width * .9,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(smallBorderRadius),
                                        topRight:
                                            Radius.circular(smallBorderRadius)),
                                    color: primaryColor,
                                  ),
                                  height: _height * .07,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _width * .03,
                                        vertical: _height * .02,
                                      ),
                                      child: Text(
                                        'Shipping to:   $address',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _height /
                                                _width *
                                                normalTextFontSize,
                                            color: whiteColor),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: _height * .02),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          confirmDetails(_height, _width,
                                              'Items :', '$rupee 100'),
                                          confirmDetails(_height, _width,
                                              'Delivery :', '$rupee 40'),
                                          confirmDetails(_height, _width,
                                              'Total :', '$rupee 140'),
                                          confirmDetails(_height, _width,
                                              'Discount :', '-$rupee 10'),
                                          confirmDetails(_height, _width,
                                              'Order Total :', '$rupee 130'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: _height * .05),
                            decoration:
                                transparentBorder.copyWith(color: whiteColor),
                            height: _height * .25,
                            width: _width * .9,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(smallBorderRadius),
                                        topRight:
                                            Radius.circular(smallBorderRadius)),
                                    color: primaryColor,
                                  ),
                                  height: _height * .07,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _width * .03,
                                        vertical: _height * .02,
                                      ),
                                      child: Text(
                                        'Shipping Address',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _height /
                                                _width *
                                                normalTextFontSize,
                                            color: whiteColor),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: _height * .03),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: _width * .04,
                                              ),
                                              child: Text(
                                                address,
                                                style: TextStyle(
                                                  fontSize: _height /
                                                      _width *
                                                      normalTextFontSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.of(context)
                                                //     .pushNamed('confirmScreen');
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: _width * .06,
                                                    vertical: _height * .02),
                                                // color: greyColor,

                                                child: Text(
                                                  'Change Address ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _height /
                                                          _width *
                                                          normalTextFontSize,
                                                      color: primaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(
                          //       top: _height * .05, bottom: _height * .02),
                          //   decoration:
                          //       transparentBorder.copyWith(color: whiteColor),
                          //   height: _height * .5,
                          //   width: _width * .9,
                          //   child: Stack(
                          //     children: <Widget>[
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(7.0),
                          //               topRight: Radius.circular(7.0)),
                          //           color: primaryColor,
                          //         ),
                          //         height: _height * .07,
                          //       ),
                          // Container(
                          //   child: Column(
                          //     crossAxisAlignment:
                          //         CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //         padding: EdgeInsets.only(
                          //             left: _width * .03,
                          //             top: _height * .02,
                          //             bottom: _height * .02),
                          //         child: Text(
                          //           'Your items',
                          //           style: TextStyle(
                          //               fontSize: _height / _width * 9,
                          //               fontFamily: 'roboto-m',
                          //               color: whiteColor),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Scrollbar(
                          //           controller: _scrollController,
                          //           isAlwaysShown: true,
                          //           child: Container(
                          //             padding: EdgeInsets.only(
                          //                 bottom: _height * .02),
                          //             child: ListView.builder(
                          //                 shrinkWrap: true,
                          //                 controller: _scrollController,
                          //                 itemCount: itemCount,
                          //                 itemBuilder: (context, index) {
                          //                   return confirmItem(
                          //                       _height,
                          //                       _width,
                          //                       vegetables,
                          //                       'Custard Apple',
                          //                       3,
                          //                       'kg',
                          //                       45);
                          //                 }),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding confirmDetails(
      double _height, double _width, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _width * .06, vertical: _height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: title == 'Order Total :' ? 'roboto-m' : 'roboto-r',
                fontSize: title == 'Order Total :'
                    ? _height / _width * mediumTextFontSize
                    : _height / _width * normalTextFontSize,
                fontWeight: title == 'Order Total :'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontFamily: title == 'Order Total :' ? 'roboto-m' : 'roboto-r',
              fontSize: title == 'Order Total :'
                  ? _height / _width * mediumTextFontSize
                  : _height / _width * normalTextFontSize,
              fontWeight: title == 'Order Total :'
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Padding confirmItem(double _height, double _width, String image, String item,
      double quantity, String measure, double price) {
    double total = price * quantity;
    return Padding(
      padding: EdgeInsets.only(bottom: _height * .02),
      child: Row(
        children: <Widget>[
          RoundedImageContainer(
            itemName: 'Name',
            itemPrice: 20,
            itemQuantity: 'g',
            image: image,
            imageHeight: _height * .06,
            imageWidth: _width * .12,
            borderRadius: 6.0,
          ),
          SizedBox(width: _width * .02),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: _height / _width * 8,
                // color: whiteColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$quantity $measure',
              style: TextStyle(
                // color: whiteColor,
                fontSize: _height / _width * 7,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$rupee $total',
              style: TextStyle(
                fontSize: _height / _width * 7,
                // color: whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

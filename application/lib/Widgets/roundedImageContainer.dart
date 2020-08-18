import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedImageContainer extends StatelessWidget {
  const RoundedImageContainer({
    Key key,
    @required this.image,
    this.itemName,
    this.itemPrice,
    this.discount,
    this.itemQuantity,
    this.isNetworkImage = true,
    this.imageHeight = .17,
    this.imageWidth = .4,
    this.borderRadius = 11.0,
  }) : super(key: key);

  final bool isNetworkImage;
  final String image;
  final String itemName;
  final itemPrice;
  final discount;
  final String itemQuantity;
  final double imageHeight;
  final double imageWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    final TextStyle textStyle = TextStyle(
        color: blackColor, fontSize: _height / _width * smallTextFontSize);
    return Container(
        decoration: transparentBorder.copyWith(
            color: whiteColor,
            borderRadius: BorderRadius.circular(borderRadius + 1)),
        width: _width * .5,
        margin: EdgeInsets.symmetric(horizontal: _width * .01),
        child: Column(
          children: <Widget>[
            Container(
              height: _height * imageHeight,
              width: _width * imageWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius)),
                child: isNetworkImage
                    ? CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) => Center(child: Loading()),
                        fit: BoxFit.contain)
                    : Image(
                        height: imageHeight,
                        width: imageWidth,
                        image: AssetImage(image),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            itemName == null
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                        left: _width * .03,
                        right: _width * .03,
                        top: _height * .005),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(capitalizeFirstLetters(itemName),
                                style: textStyle),
                            Text(
                              '$rupee ${itemPrice.toDouble().toString()} /$itemQuantity',
                              style: textStyle,
                            ),
                          ],
                        ),
                        discount == 0
                            ? SizedBox.shrink()
                            : Text(
                                'upto $discount% offer per $itemQuantity',
                                style: textStyle.copyWith(
                                    color: errorColor,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                  )
          ],
        ));
  }
}

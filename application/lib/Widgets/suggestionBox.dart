import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class SuggestionBox extends StatelessWidget {
  SuggestionBox({this.suggesstionList});
  final List suggesstionList;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    suggestionChip(String suggestionText, [String navigationScreen]) {
      return Padding(
        padding: EdgeInsets.only(right: _width * .02),
        child: GestureDetector(
          onTap: () {
            if (navigationScreen != null) {
              Navigator.of(context).pushNamed(navigationScreen);
            }
          },
          child: Text(capitalizeFirstLetters(suggestionText),
              style: TextStyle(
                color: whiteColor,
                fontSize: _height / _width * normalTextFontSize,
                fontFamily: 'Roboto-r',
                fontWeight: FontWeight.bold,
              )),
        ),
      );
    }

    return Container(
      height: _height * .08,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggesstionList.length,
        itemBuilder: (context, index) => Container(
            padding: EdgeInsets.only(
              left: _width * .04,
              right: _width * .04,
              top: _height * .025,
            ),
            child: suggestionChip(suggesstionList[index])),
      ),
    );
  }
}

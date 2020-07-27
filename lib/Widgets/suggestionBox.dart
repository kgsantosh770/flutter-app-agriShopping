import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class SuggestionBox extends StatelessWidget {
  SuggestionBox({this.suggesstionList});
  final List suggesstionList;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
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
            child: suggestionChip(
                context, _height, _width, suggesstionList[index])),
      ),
    );
  }
}

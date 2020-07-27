import 'package:flutter/material.dart';

import '../constants.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken),
        image: AssetImage(signinBackground),
        fit: BoxFit.fill,
      )),
      child: child,
    );
  }
}

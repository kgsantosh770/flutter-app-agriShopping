import 'dart:async';

import 'package:agri_shopping/Screens/homeScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Home())));
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: transparentColor,
        body: FadeTransition(
          opacity: animationController.drive(CurveTween(curve: Curves.easeOut)),
          child: Center(
            child: Image.asset(
              logo,
              fit: BoxFit.contain,
              height: _height * .3,
              width: _width * .9,
            ),
          ),
        ),
      ),
    );
  }
}

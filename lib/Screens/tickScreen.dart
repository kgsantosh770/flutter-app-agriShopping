import 'dart:async';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class Tick extends StatefulWidget {
  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> with SingleTickerProviderStateMixin {
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
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            'orderScreen', ModalRoute.withName('homeScreen')));
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: transparentColor,
        body: Center(
          child: Container(
            height: _height * .3,
            width: _width * .3,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(tickAnimation),
              fit: BoxFit.contain,
            )),
          ),
        ),
      ),
    );
  }
}

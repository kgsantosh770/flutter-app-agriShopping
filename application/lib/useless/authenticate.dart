// import 'package:agri_shopping/Screens/homeScreen.dart';
// import 'package:agri_shopping/services/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:agri_shopping/Screens/loadingScreen.dart';

// class Authenticate extends StatefulWidget {
//   @override
//   _AuthenticateState createState() => _AuthenticateState();
// }

// class _AuthenticateState extends State<Authenticate> {
//   // final AuthService _auth = AuthService();

//   // bool anonymousSignInError = false;
//   // String error = '';

//   // anonymousSignin() async {
//   //   dynamic result = await _auth.signInAnonymous();
//   //   if (result.toString().startsWith("Error")) {
//   //     setState(() {
//   //       anonymousSignInError = true;
//   //       error = result.toString().substring(7);
//   //     });
//   //   } else {
//   //     anonymousSignInError = false;
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<FirebaseUser>(context);
//     // print('*******************Authenticate*****************************');
//     // print(user);
//     // print(user.uid);
//     // print(user.isAnonymous);
//     // print(user.email);
//     // print(user.isAnonymous);
//     // print('*******************End*****************************');
//     // if (user == null) {
//     //   anonymousSignin();
//     // }
//     return Home();
//   }
// }

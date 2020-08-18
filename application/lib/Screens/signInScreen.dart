import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'loadingScreen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool passwordVisible = false;
  bool isError = false;
  String error = '';
  String email = '';
  String password = '';
  String signupMessage = '';
  String errorBoxTitle = 'Error';
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(
        color: transparentColor,
      ));

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return BackgroundContainer(
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: transparentColor,
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: _width * .1,
                    right: _width * .1,
                  ),
                  child: ListView(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        logo,
                        height: _height * .2,
                        width: _width * .35,
                        fit: BoxFit.scaleDown,
                      )),
                      errorBox(_height, _width, isError, error,
                          errorTitle: errorBoxTitle),
                      Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto-m',
                              fontSize: _height / _width * 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, _height * .05, 0, _height * .03),
                        child: Container(
                          height: _height * .08,
                          child: TextFormField(
                            style: TextStyle(color: blackColor),
                            validator: (value) {
                              if (!validateEmail(value)) {
                                setState(() {
                                  isError = true;
                                  error = "Invalid Email";
                                  errorBoxTitle = 'Error';
                                });
                                return error;
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) =>
                                FocusScope.of(context).nextFocus(),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: transparentColor, height: 0),
                                filled: true,
                                fillColor: whiteColor,
                                enabledBorder: border,
                                focusedBorder: border,
                                border: border,
                                hintText: 'Email',
                                prefixIcon: Icon(person),
                                hintStyle: TextStyle(
                                  fontSize: _height / _width * 8,
                                )),
                          ),
                        ),
                      ),
                      Container(
                        height: _height * .08,
                        child: TextFormField(
                          style: TextStyle(color: blackColor),
                          validator: (value) {
                            if (value.length < 6 || value == null) {
                              setState(() {
                                isError = true;
                                error =
                                    "Password should contain atleast 6 characters";
                                errorBoxTitle = 'Error';
                              });
                              return error;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          obscureText: passwordVisible ? false : true,
                          decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(color: transparentColor, height: 0),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: border,
                              focusedBorder: border,
                              border: border,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                              hintStyle:
                                  TextStyle(fontSize: _height / _width * 8)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: _height * .05,
                              left: _width * .3,
                              right: _width * .3),
                          child: RawMaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPasswrod(
                                        email, password);
                                setState(() {
                                  loading = false;
                                });
                                if (result.toString().startsWith("Error")) {
                                  setState(() {
                                    isError = true;
                                    error = result.toString().substring(7);
                                    errorBoxTitle = 'Error';
                                  });
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'homeScreen', (route) => false);
                                }
                              }
                            },
                            elevation: 4.0,
                            constraints: BoxConstraints.tight(
                                Size(_width * .1, _height * .1)),
                            fillColor: lightPrimaryColor,
                            child: Icon(
                              arrowForward,
                              size: _height / _width * mediumIconSize,
                            ),
                            shape: CircleBorder(),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: _height * .05),
                        child: GestureDetector(
                          onTap: () async {
                            if (!validateEmail(email)) {
                              setState(() {
                                isError = true;
                                error =
                                    "Enter a valid email to send a password reset link.";
                                errorBoxTitle = 'Error';
                              });
                            } else {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.resetPassword(email);
                              setState(() {
                                loading = false;
                              });
                              if (result.toString().startsWith("Error")) {
                                setState(() {
                                  isError = true;
                                  error = result.toString().substring(7);
                                  errorBoxTitle = 'Error';
                                });
                              } else {
                                setState(() {
                                  isError = true;
                                  error =
                                      'Password reset link has been sent to your email address.';
                                  errorBoxTitle = 'Success';
                                });
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              'Forgot your password ?',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto-r',
                                fontSize: _height / _width * 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _height * .03),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('signUpScreen');
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Don't have an account?  ",
                                    style: TextStyle(
                                      fontFamily: 'Roboto-r',
                                      fontSize: _height / _width * 8,
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 250, 0),
                                      fontFamily: 'Roboto-r',
                                      fontSize: _height / _width * 9,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

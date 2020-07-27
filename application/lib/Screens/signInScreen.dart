import 'package:agri_shopping/Screens/signUpScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'loadingScreen.dart';

class SignIn extends StatefulWidget {
  SignIn({this.signupMessage});
  final String signupMessage;
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
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  @override
  void initState() {
    signupMessage = widget.signupMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: blackColor),
          primaryColor: primaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: blackColor)),
      child: BackgroundContainer(
        child: loading
            ? Loading()
            : Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
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
                        Center(
                          child: isError || signupMessage != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: whiteColor,
                                      border: Border.all(
                                        color: signupMessage != null
                                            ? primaryColor
                                            : errorColor,
                                      )),
                                  margin:
                                      EdgeInsets.only(bottom: _height * .05),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * .01,
                                      vertical: _height * .01),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: _width * .1),
                                          child: Text(
                                            signupMessage != null
                                                ? signupMessage
                                                : error,
                                            style: TextStyle(
                                                fontSize: _height / _width * 9,
                                                color: signupMessage != null
                                                    ? primaryColor
                                                    : errorColor),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isError = false;
                                              signupMessage = null;
                                            });
                                          },
                                          icon: Icon(Icons.close)),
                                    ],
                                  ),
                                )
                              : Container(height: 0),
                        ),
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
                              0, _height * .05, 0, _height * .04),
                          child: Container(
                            height: _height * .08,
                            child: TextFormField(
                              validator: (value) {
                                if (!validateEmail(value)) {
                                  setState(() {
                                    isError = true;
                                    error = "Invalid Email";
                                  });
                                  return error;
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
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
                            validator: (value) {
                              if (value.length < 6 || value == null) {
                                setState(() {
                                  isError = true;
                                  error =
                                      "Password should contain atleast 6 characters";
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
                                errorStyle: TextStyle(
                                    color: Colors.transparent, height: 0),
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
                                  // await _auth.signOut();
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
                                    });
                                  } else {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'homeScreen', (route) => false);
                                  }
                                }
                              },
                              elevation: 4.0,
                              constraints: BoxConstraints.tight(
                                  Size(_width * .1, _height * .1)),
                              fillColor: lightPrimaryColor,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: _width * .06,
                              ),
                              shape: CircleBorder(),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: _height * .05),
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
                        Padding(
                          padding: EdgeInsets.only(top: _height * .03),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUp()));
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
      ),
    );
  }
}

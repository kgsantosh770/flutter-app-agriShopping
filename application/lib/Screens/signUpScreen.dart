import 'package:agri_shopping/Screens/otpScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'loadingScreen.dart';
import '../constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool loading = false;
  bool isError = false;
  String error = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String _countryCode = 'IN  +91';
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    _dropDownDialog(List supportedCountries) {
      return showDialog(
          context: context,
          builder: (context) {
            return Container(
              height: _height * .5,
              width: _width * .5,
              child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Country code',
                      style: TextStyle(color: blackColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(close, color: blackColor),
                    )
                  ],
                ),
                content: SingleChildScrollView(
                  child: Container(
                      height: _height * .5,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: supportedCountries.length,
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _countryCode = supportedCountries[index]
                                          ['short_form'] +
                                      '  ' +
                                      supportedCountries[index]['code'];
                                });
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                height: _height * .06,
                                width: _width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * .02,
                                      vertical: _height * .015),
                                  child: Center(
                                    child: Text(
                                      supportedCountries[index]['country'] +
                                          '  ' +
                                          supportedCountries[index]['code'],
                                      style: TextStyle(color: blackColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: _height * .001,
                            )
                          ],
                        ),
                      )),
                ),
              ),
            );
          });
    }

    _buildName() {
      return Container(
        margin: EdgeInsets.only(top: _height * .03),
        height: _height * .09,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                isError = true;
                error = "Enter your name";
              });
              return error;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
          onSaved: (value) {
            setState(() {
              name = value;
            });
          },
          style: TextStyle(color: blackColor),
          decoration: inputDecoration(_height, _width).copyWith(
              hintText: 'Name',
              prefixIcon: Icon(person),
              suffixIcon: nameController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        nameController.clear();
                        setState(() {
                          name = '';
                        });
                      },
                      icon: Icon(close))
                  : null),
        ),
      );
    }

    _buildEmail() {
      return Container(
        margin: EdgeInsets.only(top: _height * .03),
        height: _height * .09,
        child: TextFormField(
          controller: emailController,
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
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
          onSaved: (value) {
            setState(() {
              email = value;
            });
          },
          style: TextStyle(color: blackColor),
          decoration: inputDecoration(_height, _width).copyWith(
              hintText: 'Email',
              prefixIcon: Icon(mail),
              suffixIcon: emailController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        emailController.clear();
                        setState(() {
                          email = '';
                        });
                      },
                      icon: Icon(close))
                  : null),
        ),
      );
    }

    _buildPhoneNumber(List supportedCountries) {
      return Container(
        margin: EdgeInsets.only(top: _height * .03),
        height: _height * .09,
        width: _width * .2,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  _dropDownDialog(supportedCountries);
                },
                child: Container(
                  decoration: whiteBorder.copyWith(color: whiteColor),
                  padding: EdgeInsets.symmetric(horizontal: _width * .02),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 4,
                          child: Text(
                            _countryCode,
                            style: TextStyle(
                                color: blackColor,
                                fontSize: _height / _width * smallTextFontSize),
                          ),
                        ),
                        // SizedBox(width: _width * .01),
                        Flexible(
                          flex: 1,
                          child: Icon(
                            arrowDropDown,
                            color: blackColor,
                            size: largeIconSize,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: _width * .03),
                child: TextFormField(
                  controller: phoneNumberController,
                  validator: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        isError = true;
                        error = "Enter your mobile number";
                      });
                      return error;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                  onSaved: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  style: TextStyle(color: blackColor),
                  decoration: inputDecoration(_height, _width).copyWith(
                      hintText: 'Mobile number',
                      prefixIcon: Icon(iphone),
                      suffixIcon: phoneNumberController.text.length > 0
                          ? IconButton(
                              onPressed: () {
                                phoneNumberController.clear();
                                setState(() {
                                  phoneNumber = '';
                                });
                              },
                              icon: Icon(close))
                          : null),
                ),
              ),
            ),
          ],
        ),
      );
    }

    _buildPassword() {
      return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: _height * .03),
            height: _height * .09,
            child: TextFormField(
                validator: (value) {
                  if (value.length < 6 || value == null) {
                    setState(() {
                      isError = true;
                      error = "Passwords must be atleast 6 characters";
                    });
                    return error;
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: passwordVisible ? false : true,
                style: TextStyle(color: blackColor),
                decoration: inputDecoration(_height, _width).copyWith(
                  hintText: 'Password',
                  prefixIcon: Icon(lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: passwordVisible ? Icon(eyeOpen) : Icon(eyeClose),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: _height * .01),
            child: Row(
              children: <Widget>[
                Icon(
                  info,
                  size: largeIconSize,
                ),
                Text(
                  " Passwords must be atleast 6 characters.",
                  style:
                      TextStyle(fontSize: _height / _width * smallTextFontSize),
                )
              ],
            ),
          )
        ],
      );
    }

    return BackgroundContainer(
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: transparentColor,
              body: StreamBuilder<DocumentSnapshot>(
                  stream: DatabaseService().staticData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Loading();
                    } else {
                      final List supportedCountries =
                          snapshot.data['supported_country_codes'];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _width * .05,
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: <Widget>[
                              Center(
                                  child: Image.asset(
                                logo,
                                height: _height * .15,
                                width: _width * .3,
                              )),
                              Center(
                                child: Text(
                                  'Create your account',
                                  style: TextStyle(
                                      fontSize:
                                          _height / _width * mediumTextFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              _buildName(),
                              _buildPhoneNumber(supportedCountries),
                              _buildEmail(),
                              _buildPassword(),
                              errorBox(_height, _width, isError, error),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: _height * .05,
                                      left: _width * .3,
                                      right: _width * .3),
                                  child: RawMaterialButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();

                                        if (_auth.codeSent) {
                                          setState(() {
                                            data = {
                                              'method': 'phone',
                                              'name': name,
                                              'countryCode':
                                                  _countryCode.split('  ')[1],
                                              'phoneNumbeer': phoneNumber,
                                              'password': password,
                                            };
                                          });
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                Otp(userData: data),
                                          ));
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          await _auth.verifyPhone(context, name,
                                              _countryCode, phoneNumber);
                                          setState(() {
                                            loading = false;
                                          });
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
                                padding: EdgeInsets.symmetric(
                                    vertical: _height * .03),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "Already have an account?  ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto-r',
                                              fontSize: _height /
                                                  _width *
                                                  normalTextFontSize,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(
                                            text: "Sign in",
                                            style: TextStyle(
                                              color: lightPrimaryColor,
                                              fontSize: _height /
                                                  _width *
                                                  mediumTextFontSize,
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
                      );
                    }
                  }),
            ),
    );
  }
}

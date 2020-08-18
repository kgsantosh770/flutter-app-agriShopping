import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactUsState();
  }
}

class ContactUsState extends State<ContactUs> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool isError = false;
  String error = '';
  String name;
  String email;
  String message;

  _buildTextFormField(
      {double height,
      double width,
      String hintText,
      bool optional = false,
      Function onChangeFunction,
      TextInputType textInputType}) {
    return Padding(
      padding: EdgeInsets.only(top: height * .01, bottom: height * .03),
      child: TextFormField(
          validator: (value) {
            if (!optional && value.isEmpty) {
              setState(() {
                isError = true;
                error = "Name cannot be empty.";
              });
              return error;
            }
            return null;
          },
          keyboardType: textInputType,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
          onChanged: (value) {
            onChangeFunction(value);
          },
          decoration: inputDecoration(height, width).copyWith(
            hintText: hintText,
            prefixIcon: Icon(person),
          )),
    );
  }

  _buildMsg(
    double height,
    double width,
    Function onChangeFunction,
  ) {
    return Container(
      height: height * .3,
      padding: EdgeInsets.only(top: height * .01, bottom: height * .03),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        maxLines: 10,
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              isError = true;
              error = "Message cannot be empty.";
            });
            return error;
          }
          return null;
        },
        onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
        onChanged: (value) {
          onChangeFunction(value);
        },
        decoration: inputDecoration(height, width).copyWith(
          contentPadding: EdgeInsets.symmetric(
              vertical: height * .02, horizontal: width * .05),
          hintText: "Write your message here.",
        ),
      ),
    );
  }

  _buildEmail(double _height, double _width, String hintText) {
    return Padding(
      padding: EdgeInsets.only(top: _height * .01, bottom: _height * .03),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              isError = true;
              error = "Email cannot be empty";
            });
            return error;
          } else if (!validateEmail(value)) {
            setState(() {
              isError = true;
              error = "Invalid email";
            });
            return error;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: inputDecoration(_height, _width).copyWith(
          prefixIcon: Icon(mail),
          hintText: hintText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    TextStyle labelStyle = TextStyle(
        fontSize: _height / _width * normalTextFontSize,
        fontWeight: FontWeight.bold);

    return loading
        ? Loading()
        : BackgroundContainer(
            child: Scaffold(
              appBar: topBar(context),
              backgroundColor: transparentColor,
              body: Theme(
                data: ThemeData(
                    cursorColor: Theme.of(context).cursorColor,
                    primaryColor: Theme.of(context).primaryColor,
                    textTheme: Theme.of(context)
                        .textTheme
                        .apply(bodyColor: blackColor)),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PageTitle(title: 'Contact Us'),
                        errorBox(_height, _width, isError, error),
                        Container(
                          margin: EdgeInsets.only(
                            top: _height * .05,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name :", style: labelStyle),
                              _buildTextFormField(
                                  height: _height,
                                  width: _width,
                                  textInputType: TextInputType.text,
                                  hintText: "eg: John Abraham",
                                  onChangeFunction: (String value) {
                                    setState(() {
                                      name = value;
                                    });
                                  }),
                              user != null
                                  ? Text("Email :", style: labelStyle)
                                  : SizedBox.shrink(),
                              user != null
                                  ? _buildEmail(_height, _width,
                                      "eg: johnabraham@gmail.com")
                                  : SizedBox.shrink(),
                              Text("Message :", style: labelStyle),
                              _buildMsg(_height, _width, (String value) {
                                setState(() {
                                  message = value;
                                });
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .05,
                              vertical: _height * .01),
                          child: FlatButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isError = false;
                                  error = '';
                                });
                                final String subject =
                                    "AgriShopping Customer: ${dateFormatter(DateTime.now())}";
                                final String htmlMessage =
                                    "<b>Name:</b> $name<br><br><b>Email:</b> $email<br><br><b>Message:</b><p>$message</p>";

                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.sendEmail(subject, htmlMessage);
                                if (result.toString().startsWith("Error")) {
                                  setState(() {
                                    isError = true;
                                    error = result;
                                  });
                                } else {
                                  Navigator.pop(context, 'success');
                                }
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            padding:
                                EdgeInsets.symmetric(vertical: _height * .025),
                            color: lightGreenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(smallBorderRadius),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Send Message',
                                    style: TextStyle(
                                      fontSize:
                                          _height / _width * normalTextFontSize,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

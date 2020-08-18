import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.userData}) : super(key: key);
  final Map<String, dynamic> userData;
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool loading = false;
  bool isError = false;
  String error = '';
  String _smsCode;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final Map<String, dynamic> userData = widget.userData;

    _buildOtpFormField() {
      return Expanded(
        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
          ],
          textAlign: TextAlign.center,
          cursorColor: lightPrimaryColor,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
            color: lightPrimaryColor,
            width: _width * .004,
          ))),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _smsCode = value;
            });
          },
          validator: (String value) {
            if (value.isEmpty) {
              return 'Invalid Sms Code';
            }

            return null;
          },
        ),
      );
    }

    return loading
        ? Loading()
        : BackgroundContainer(
            child: Scaffold(
              backgroundColor: transparentColor,
              body: Padding(
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
                      child: isError
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.red,
                                  )),
                              margin: EdgeInsets.only(bottom: _height * .05),
                              padding: EdgeInsets.symmetric(
                                  horizontal: _width * .01,
                                  vertical: _height * .01),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: _width * .1),
                                      child: Text(
                                        error,
                                        style: TextStyle(
                                            fontSize: _height / _width * 9,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isError = false;
                                        });
                                      },
                                      icon: Icon(Icons.close)),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Center(
                      child: Text(
                        'One Time Password',
                        style: TextStyle(
                            fontSize: _height / _width * largeTextFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: _height * .05,
                    ),
                    Center(
                      child: Text(
                        'Enter the "One Time Password" (OTP) sent to your registered mobile number.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _height / _width * normalTextFontSize,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(_width * .05,
                            _height * .05, _width * .05, _height * .03),
                        child: Row(
                          children: <Widget>[
                            _buildOtpFormField(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: _height * .05,
                            left: _width * .3,
                            right: _width * .3),
                        child: RawMaterialButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signInWithOtp(
                                userData['name'],
                                userData['countryCode'],
                                userData['phoneNumber'],
                                _auth.verificationID,
                                _smsCode);
                            setState(() {
                              loading = false;
                            });
                            if (result.toString().startsWith("Error")) {
                              setState(() {
                                isError = true;
                                error = result.toString().substring(7);
                              });
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homeScreen', (route) => false);
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
                            Navigator.of(context).pushNamed('otpScreen');
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
          );
  }
}

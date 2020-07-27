import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key, this.countryCode, this.supportedCountryCodes})
      : super(key: key);
  final String countryCode;
  final List supportedCountryCodes;
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  Color borderColor = lightGreyColor;
  String _name;
  String _email;
  String _countryCode;
  List _countryCodeList;
  String _phoneNumber;
  bool isEditable = false;
  bool loading = false;
  String status = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();
    setState(() {
      _countryCode = widget.countryCode;
      _countryCodeList = widget.supportedCountryCodes;
    });
  }

  Widget _buildName(double _height, double _width, String initialValue) {
    return TextFormField(
      enabled: isEditable,
      decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: TextStyle(fontSize: _height / _width * labelFontSize)),
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildPhoneNumber(double _height, double _width, String initialValue) {
    return TextFormField(
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: 'Phone number',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
      ),
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.length != 10 && value.isNotEmpty) {
          return 'Phone number is invalid';
        }
        return null;
      },
      onSaved: (String value) {
        setState(() {
          _phoneNumber = value;
        });
      },
    );
  }

  Widget _buildEmail(double _height, double _width, String initialValue) {
    return TextFormField(
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: 'Email ID',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
      ),
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!validateEmail(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    Widget buildEditButton() {
      return Container(
        margin: EdgeInsets.only(
            top: _height * .01, left: _width * .45, right: _width * .05),
        child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: _height * .015),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: _height / _width * normalTextFontSize,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                borderColor = lightGreenColor;
                isEditable = true;
              });
            }),
      );
    }

    return loading
        ? Loading()
        : BackgroundContainer(
            child: Scaffold(
              appBar: topBar(context, _height, _width),
              backgroundColor: transparentColor,
              body: user == null
                  ? Loading()
                  : StreamBuilder<DocumentSnapshot>(
                      stream: DatabaseService(uid: user.uid).userData,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        } else {
                          final userData = snapshot.data;
                          return Theme(
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
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        PageTitle(title: 'Edit Profile'),
                                        Expanded(child: buildEditButton()),
                                      ],
                                    ),
                                    Center(
                                      child: status.startsWith('Error') ||
                                              status.startsWith('Saved')
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: status
                                                            .startsWith('Error')
                                                        ? errorColor
                                                        : primaryColor,
                                                  )),
                                              margin: EdgeInsets.only(
                                                  top: _height * .05,
                                                  left: _width * .05,
                                                  right: _width * .05),
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
                                                        status,
                                                        style: TextStyle(
                                                            fontSize: _height /
                                                                _width *
                                                                normalTextFontSize,
                                                            color: status
                                                                    .startsWith(
                                                                        'Error')
                                                                ? errorColor
                                                                : primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          status = '';
                                                        });
                                                      },
                                                      icon: Icon(Icons.close)),
                                                ],
                                              ),
                                            )
                                          : Container(height: 0),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: _width * .05,
                                          vertical: _height * .03),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _width * .05),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: borderColor,
                                              width: _width * .008),
                                          borderRadius: BorderRadius.circular(
                                              smallBorderRadius),
                                          color: whiteColor),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _buildName(_height, _width,
                                              userData.data['name']),
                                          SizedBox(height: _height * .02),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: _height * .03,
                                                      right: _width * .05),
                                                  child: DropdownButton<String>(
                                                    value: _countryCode,
                                                    disabledHint: !isEditable
                                                        ? Text(_countryCode)
                                                        : null,
                                                    underline:
                                                        SizedBox.shrink(),
                                                    onChanged: !isEditable
                                                        ? null
                                                        : (String newValue) {
                                                            setState(() {
                                                              _countryCode =
                                                                  newValue;
                                                            });
                                                          },
                                                    items: _countryCodeList.map(
                                                        (dynamic
                                                            dropDownCountryCode) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value:
                                                            dropDownCountryCode,
                                                        child: Text(
                                                          dropDownCountryCode,
                                                          style: TextStyle(
                                                              fontSize: _height /
                                                                  _width *
                                                                  normalTextFontSize,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )),
                                              Flexible(
                                                child: _buildPhoneNumber(
                                                    _height,
                                                    _width,
                                                    userData.data['phone']
                                                        ['phone_number']),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: _height * .02),
                                          _buildEmail(_height, _width,
                                              userData.data['email']),
                                          SizedBox(height: _height * .05),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _width * .05),
                                      child: FlatButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: _height * .025),
                                          color: isEditable
                                              ? primaryColor
                                              : greyColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: _width * .02),
                                                child: Text(
                                                  'Save Changes',
                                                  style: TextStyle(
                                                    fontSize: _height /
                                                        _width *
                                                        normalTextFontSize,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            if (isEditable) {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                Map<String, dynamic> data = {
                                                  'name': _name,
                                                  'phone': {
                                                    'country_code':
                                                        _countryCode,
                                                    'phone_number': _phoneNumber
                                                  },
                                                  'email': _email
                                                };
                                                setState(() {
                                                  borderColor = lightGreenColor;
                                                  loading = !loading;
                                                });
                                                dynamic result =
                                                    await DatabaseService(
                                                            uid: user.uid)
                                                        .updateUserData(data);
                                                setState(() {
                                                  loading = !loading;
                                                });
                                                if (result
                                                    .toString()
                                                    .startsWith("Error")) {
                                                  setState(() {
                                                    status = result;
                                                  });
                                                } else {
                                                  setState(() {
                                                    status = 'Saved Changes.';
                                                    isEditable = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  borderColor = errorColor;
                                                });
                                              }
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
            ),
          );
  }
}

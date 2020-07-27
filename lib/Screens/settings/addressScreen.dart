import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/backgroundContainer.dart';
import '../../Widgets/topBar.dart';

class Address extends StatefulWidget {
  const Address(
      {Key key,
      this.deliverableStates,
      this.currentState,
      this.deliverableCountries,
      this.currentCountry})
      : super(key: key);
  final List deliverableStates;
  final String currentState;
  final List deliverableCountries;
  final String currentCountry;
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Color borderColor = lightGreyColor;
  bool isEditable = false;
  bool loading = false;
  String status = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _stateList = ["Tamil Nadu", "Kerala", "Karnataka"];
  String _currentState = 'Tamil Nadu';
  List _countryList = ["India"];
  String _currentCountry = 'India';
  String _name, _mobileNumber, _pinCode, _houseNumber, _area, _landmark, _city;

  Widget _buildTextFormField(String labelText, TextInputType textInputType,
      double _height, double _width, String initialValue, Function onSaved) {
    return TextFormField(
      enabled: isEditable,
      keyboardType: textInputType,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: _height / _width * labelFontSize)),
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid';
        }

        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildMobileNumber(
      double _height, double _width, String initialValue) {
    return TextFormField(
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        labelStyle: TextStyle(fontSize: _height / _width * labelFontSize),
      ),
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.length != 10 && value.isNotEmpty) {
          return 'Invalid';
        }
        return null;
      },
      onSaved: (String value) {
        setState(() {
          _mobileNumber = value;
        });
      },
    );
  }

  @override
  void initState() {
    setState(() {
      _stateList = widget.deliverableStates;
      _currentState = widget.currentState;
      _countryList = widget.deliverableCountries;
      _currentCountry = widget.currentCountry;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    Widget buildEditButton(String state, String country) {
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
                _currentState = state;
                _currentCountry = country;
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
                backgroundColor: transparentColor,
                appBar: topBar(context, _height, _width),
                body: user != null
                    ? StreamBuilder<DocumentSnapshot>(
                        stream: DatabaseService(uid: user.uid).userData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Loading();
                          else {
                            final userAddress =
                                snapshot.data.data['default_address'];
                            return Theme(
                              data: ThemeData(
                                  cursorColor: Theme.of(context).cursorColor,
                                  primaryColor: Theme.of(context).primaryColor,
                                  textTheme: Theme.of(context)
                                      .textTheme
                                      .apply(bodyColor: blackColor)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        PageTitle(title: 'Address'),
                                        Expanded(
                                            child: buildEditButton(
                                                userAddress['state'],
                                                userAddress['country'])),
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
                                      margin: EdgeInsets.only(
                                          left: _width * .05,
                                          right: _width * .05,
                                          bottom: _height * .015,
                                          top: _height * .03),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _width * .05),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: borderColor,
                                              width: _width * .008),
                                          borderRadius: BorderRadius.circular(
                                              smallBorderRadius),
                                          color: isEditable
                                              ? whiteColor
                                              : lightGreyColor),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            _buildTextFormField(
                                                'Full Name',
                                                TextInputType.text,
                                                _height,
                                                _width,
                                                userAddress['name'],
                                                (String value) {
                                              setState(() {
                                                _name = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .01),
                                            _buildMobileNumber(_height, _width,
                                                userAddress['mobile_number']),
                                            SizedBox(height: _height * .01),
                                            _buildTextFormField(
                                                'PIN Code',
                                                TextInputType.number,
                                                _height,
                                                _width,
                                                userAddress['pin_code'],
                                                (String value) {
                                              setState(() {
                                                _pinCode = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .01),
                                            _buildTextFormField(
                                                "Flat, House no., Building, Company, Apartment",
                                                TextInputType.number,
                                                _height,
                                                _width,
                                                userAddress['house_number'],
                                                (String value) {
                                              setState(() {
                                                _houseNumber = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .01),
                                            _buildTextFormField(
                                                "Area, Colony, street, Sector, Village",
                                                TextInputType.text,
                                                _height,
                                                _width,
                                                userAddress['area'],
                                                (String value) {
                                              setState(() {
                                                _area = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .01),
                                            _buildTextFormField(
                                                "Landmark e.g. near Apollo Hospital",
                                                TextInputType.text,
                                                _height,
                                                _width,
                                                userAddress['landmark'],
                                                (String value) {
                                              setState(() {
                                                _landmark = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .01),
                                            _buildTextFormField(
                                                "Town/City",
                                                TextInputType.text,
                                                _height,
                                                _width,
                                                userAddress['city'],
                                                (String value) {
                                              setState(() {
                                                _city = value;
                                              });
                                            }),
                                            SizedBox(height: _height * .02),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: _width * .035,
                                                  left: _width * .01),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                dropdownColor: lightGreyColor,
                                                underline: SizedBox.shrink(),
                                                value: _currentState,
                                                disabledHint: !isEditable
                                                    ? Text(_currentState)
                                                    : null,
                                                items: _stateList.map(
                                                    (dynamic dropDownState) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: dropDownState,
                                                    child: Text(
                                                      dropDownState,
                                                      style: TextStyle(
                                                          fontSize: _height /
                                                              _width *
                                                              normalTextFontSize,
                                                          color: blackColor),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: !isEditable
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          _currentState = value;
                                                        });
                                                      },
                                              ),
                                            ),
                                            SizedBox(height: _height * .02),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: _width * .035,
                                                  left: _width * .01),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                dropdownColor: lightGreyColor,
                                                underline: SizedBox.shrink(),
                                                value: _currentCountry,
                                                disabledHint: !isEditable
                                                    ? Text(_currentCountry)
                                                    : null,
                                                items: _countryList.map(
                                                    (dynamic dropDownCountry) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: dropDownCountry,
                                                    child: Text(
                                                      dropDownCountry,
                                                      style: TextStyle(
                                                          fontSize: _height /
                                                              _width *
                                                              normalTextFontSize,
                                                          color: Colors.black),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: !isEditable
                                                    ? null
                                                    : (String value) {
                                                        setState(() {
                                                          _currentCountry =
                                                              value;
                                                        });
                                                      },
                                              ),
                                            ),
                                            SizedBox(height: _height * .02),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _width * .05,
                                          vertical: _height * .01),
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
                                                Map<String, Map> data = {
                                                  'default_address': {
                                                    'name': _name,
                                                    'mobile_number':
                                                        _mobileNumber,
                                                    'pin_code': _pinCode,
                                                    'house_number':
                                                        _houseNumber,
                                                    'area': _area,
                                                    'landmark': _landmark,
                                                    'city': _city,
                                                    'state': _currentState,
                                                    'country': _currentCountry
                                                  }
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
                            );
                          }
                        })
                    : Loading()),
          );
  }
}

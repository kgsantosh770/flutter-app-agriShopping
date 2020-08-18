import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/editButton.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Widgets/backgroundContainer.dart';
import '../Widgets/topBar.dart';

class Address extends StatefulWidget {
  const Address(
      {Key key,
      this.editable,
      this.deliverableStates,
      this.deliverableCountries,
      this.userAddress})
      : super(key: key);
  final bool editable;
  final List deliverableStates;
  final List deliverableCountries;
  final Map userAddress;
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isEditable;
  bool loading = false;
  bool isError = false;
  String error = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _stateList;
  String _currentState;
  String _countryCode;
  List _countryCodeList;
  List _countryList;
  String _currentCountry;
  String _name, _phoneNumber, _pinCode, _houseNumber, _area, _landmark, _city;

  @override
  void initState() {
    List countryCodeList = [];
    List countryList = [];
    widget.deliverableCountries.forEach((element) {
      countryCodeList.add('${element['country']} ${element['code']}');
      countryList.add('${element['country']}');
    });
    setState(() {
      isEditable = widget.editable;
      _name = widget.userAddress['name'];
      _area = widget.userAddress['area'];
      _city = widget.userAddress['city'];
      _pinCode = widget.userAddress['pincode'];
      _houseNumber = widget.userAddress['house_number'];
      _landmark = widget.userAddress['landmark'];
      _stateList = widget.deliverableStates;
      _currentState = widget.userAddress['state'];
      _countryCode = widget.userAddress['phone']['country_code'];
      _countryCodeList = countryCodeList;
      _countryList = countryList;
      _currentCountry = widget.userAddress['country'];
    });
    super.initState();
  }

  _dropDownDialog(double _height, double _width, List dropDownList,
      String title, String method) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return Container(
            height: _height * .5,
            width: _width * .01,
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(color: blackColor),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    icon: Icon(close, color: blackColor),
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                    height: _height * .4,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: dropDownList.length,
                      itemBuilder: (itemContext, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (method == "countryCode")
                                  _countryCode = dropDownList[index]
                                      .toString()
                                      .split(' ')[1];
                                else if (method == "currentCountry")
                                  _currentCountry = dropDownList[index];
                                else
                                  _currentState = dropDownList[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: _height * .06,
                              width: _width * .7,
                              color: transparentColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _width * .05,
                                    vertical: _height * .015),
                                child: Center(
                                  child: Text(
                                    dropDownList[index],
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

  _buildTextFormField(
      {double height,
      double width,
      String initialValue,
      String hintText,
      bool optional = false,
      Function onChangeFunction,
      TextInputType textInputType}) {
    return Padding(
      padding: EdgeInsets.only(top: height * .01, bottom: height * .03),
      child: TextFormField(
          initialValue: initialValue,
          enabled: isEditable,
          validator: (value) {
            if (!optional && value.isEmpty) {
              setState(() {
                isError = true;
                error = "One or more fields cannot be empty.";
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
          style: TextStyle(color: blackColor),
          decoration:
              inputDecoration(height, width).copyWith(hintText: hintText)),
    );
  }

  _buildPhoneNumber(
      double _height, double _width, String initialValue, String hintText) {
    return Container(
      padding: EdgeInsets.only(top: _height * .01, bottom: _height * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: !isEditable
                  ? null
                  : () {
                      _dropDownDialog(_height, _width, _countryCodeList,
                          "Country Code", "countryCode");
                    },
              child: Container(
                decoration: whiteBorder.copyWith(color: whiteColor),
                padding: EdgeInsets.symmetric(
                    horizontal: _width * .02, vertical: _height * .022),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        _countryCode,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: _height / _width * smallTextFontSize),
                      ),
                    ),
                    Icon(
                      arrowDropDown,
                      color: blackColor,
                      size: largeIconSize,
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(left: _width * .02),
              child: TextFormField(
                enabled: isEditable,
                initialValue: initialValue,
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
                    _phoneNumber = value;
                  });
                },
                style: TextStyle(color: blackColor),
                decoration: inputDecoration(_height, _width)
                    .copyWith(hintText: hintText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    TextStyle labelStyle = TextStyle(
        fontSize: _height / _width * normalTextFontSize,
        fontWeight: FontWeight.bold);

    return loading
        ? Loading()
        : BackgroundContainer(
            child: Scaffold(
                backgroundColor: transparentColor,
                appBar: topBar(context),
                body: Theme(
                  data: ThemeData(
                      cursorColor: Theme.of(context).cursorColor,
                      primaryColor: Theme.of(context).primaryColor,
                      textTheme: Theme.of(context)
                          .textTheme
                          .apply(bodyColor: blackColor)),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              PageTitle(title: 'Shipping Address'),
                              !isEditable
                                  ? Expanded(
                                      child: editButton(
                                          height: _height,
                                          width: _width,
                                          buttonHeight: _height * .05,
                                          margin: EdgeInsets.only(
                                              top: _height * .01,
                                              right: _width * .02,
                                              left: _width * .38),
                                          onTapFunction: () {
                                            setState(() {
                                              isEditable = true;
                                            });
                                          }))
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: _width * .05,
                                right: _width * .05,
                                bottom: _height * .015,
                                top: _height * .03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Name :", style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.text,
                                    initialValue: widget.userAddress['name'],
                                    hintText: "eg: John Abraham",
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _name = value;
                                      });
                                    }),
                                Text("Mobile Number :", style: labelStyle),
                                _buildPhoneNumber(
                                    _height,
                                    _width,
                                    widget.userAddress['phone']['phone_number'],
                                    "eg: 9876543210"),
                                Text("Pincode :", style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.number,
                                    initialValue: widget.userAddress['pincode'],
                                    hintText: "eg: 625001",
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _pinCode = value;
                                      });
                                    }),
                                Text(
                                    "Flat, House no., Building, Company, Apartment :",
                                    style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.text,
                                    hintText: "eg: 18/1 or 7",
                                    initialValue:
                                        widget.userAddress['house_number'],
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _houseNumber = value;
                                      });
                                    }),
                                Text("Area, Colony, Street, Sector, Village :",
                                    style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.text,
                                    hintText: "eg: Anna Nagar",
                                    initialValue: widget.userAddress['area'],
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _area = value;
                                      });
                                    }),
                                Text("Landmark (Optional) :",
                                    style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.text,
                                    hintText: "eg: Near Apollo Hospital",
                                    optional: true,
                                    initialValue:
                                        widget.userAddress['landmark'],
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _landmark = value;
                                      });
                                    }),
                                Text("Town/City :", style: labelStyle),
                                _buildTextFormField(
                                    height: _height,
                                    width: _width,
                                    textInputType: TextInputType.text,
                                    hintText: "eg: Madurai",
                                    initialValue: widget.userAddress['city'],
                                    onChangeFunction: (String value) {
                                      setState(() {
                                        _city = value;
                                      });
                                    }),
                                Text("State and Country :", style: labelStyle),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: _height * .01,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: !isEditable
                                            ? null
                                            : () {
                                                _dropDownDialog(
                                                    _height,
                                                    _width,
                                                    _stateList,
                                                    "State",
                                                    "currentState");
                                              },
                                        child: Container(
                                          width: _width * .42,
                                          decoration: whiteBorder.copyWith(
                                              color: whiteColor),
                                          padding: EdgeInsets.symmetric(
                                              vertical: _height * .02,
                                              horizontal: _width * .02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  _currentState,
                                                  style: TextStyle(
                                                      color: blackColor,
                                                      fontSize: _height /
                                                          _width *
                                                          smallTextFontSize),
                                                ),
                                              ),
                                              Icon(
                                                arrowDropDown,
                                                color: blackColor,
                                                size: largeIconSize,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: !isEditable
                                            ? null
                                            : () {
                                                _dropDownDialog(
                                                    _height,
                                                    _width,
                                                    _countryList,
                                                    "Country",
                                                    "currentCountry");
                                              },
                                        child: Container(
                                          width: _width * .42,
                                          decoration: whiteBorder.copyWith(
                                              color: whiteColor),
                                          padding: EdgeInsets.symmetric(
                                              vertical: _height * .02,
                                              horizontal: _width * .02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  _currentCountry,
                                                  style: TextStyle(
                                                      color: blackColor,
                                                      fontSize: _height /
                                                          _width *
                                                          smallTextFontSize),
                                                ),
                                              ),
                                              Icon(
                                                arrowDropDown,
                                                color: blackColor,
                                                size: largeIconSize,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          errorBox(
                            _height,
                            _width,
                            isError,
                            error,
                          ),
                          SizedBox(height: _height * .02),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: _width * .05,
                                vertical: _height * .01),
                            child: FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: _height * .025),
                                color: isEditable ? primaryColor : greyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(smallBorderRadius),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
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
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      Map<String, Map> data = {
                                        'default_address': {
                                          'name':
                                              toBeginningOfSentenceCase(_name),
                                          'phone': {
                                            'country_code': _countryCode,
                                            'phone_number': _phoneNumber,
                                          },
                                          'pincode': _pinCode,
                                          'house_number': _houseNumber,
                                          'area':
                                              toBeginningOfSentenceCase(_area),
                                          'landmark': toBeginningOfSentenceCase(
                                              _landmark),
                                          'city':
                                              toBeginningOfSentenceCase(_city),
                                          'state': _currentState,
                                          'country': _currentCountry
                                        }
                                      };
                                      setState(() {
                                        loading = !loading;
                                      });
                                      dynamic result =
                                          await DatabaseService(uid: user.uid)
                                              .updateUserData(data);
                                      setState(() {
                                        loading = !loading;
                                      });
                                      if (result
                                          .toString()
                                          .startsWith("Error")) {
                                        setState(() {
                                          isError = true;
                                          error = result;
                                        });
                                      } else {
                                        Navigator.pop(context, 'success');
                                      }
                                    }
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }
}

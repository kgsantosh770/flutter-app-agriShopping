import 'package:agri_shopping/Screens/loadingScreen.dart';
import 'package:agri_shopping/Widgets/backgroundContainer.dart';
import 'package:agri_shopping/Widgets/errorBox.dart';
import 'package:agri_shopping/Widgets/pageTitle.dart';
import 'package:agri_shopping/Widgets/topBar.dart';
import 'package:agri_shopping/Widgets/editButton.dart';
import 'package:agri_shopping/constants.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key, this.userData, this.supportedCountryCodes})
      : super(key: key);
  final Map userData;
  final List supportedCountryCodes;
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  bool passwordVisible = false;
  bool loading = false;
  bool isError = false;
  String error = '';
  String password = '';
  String _name;
  String _email;
  String _countryCode;
  List _countryCodeList;
  String _phoneNumber;
  bool isEditable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    List countryCodeList = [];
    widget.supportedCountryCodes.forEach((element) {
      countryCodeList.add('${element['short_form']} ${element['code']}');
    });
    setState(() {
      nameController.text = widget.userData['name'];
      emailController.text = widget.userData['email'];
      _countryCode = widget.userData['phone']['country_code'];
      _countryCodeList = countryCodeList;
    });
  }

  _dropDownDialog(
      double _height, double _width, List dropDownList, String title) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return Container(
            height: _height * .5,
            width: _width * .5,
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
                    width: _width * .1,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: dropDownList.length,
                      itemBuilder: (itemContext, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _countryCode = dropDownList[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: _height * .06,
                              width: _width * .7,
                              color: transparentColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _width * .02,
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

  _buildName(double _height, double _width, String hintText) {
    return Padding(
      padding: EdgeInsets.only(top: _height * .01, bottom: _height * .03),
      child: TextFormField(
        enabled: isEditable,
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
            _name = value;
          });
        },
        style: TextStyle(color: blackColor),
        decoration: inputDecoration(_height, _width).copyWith(
          prefixIcon: Icon(person),
          hintText: hintText,
        ),
      ),
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
                      _dropDownDialog(
                          _height, _width, _countryCodeList, "Country Code");
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
                decoration: inputDecoration(_height, _width).copyWith(
                  prefixIcon: Icon(iphone),
                  hintText: hintText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEmail(double _height, double _width, String hintText) {
    return Padding(
      padding: EdgeInsets.only(top: _height * .01, bottom: _height * .03),
      child: TextFormField(
        enabled: isEditable,
        controller: emailController,
        validator: (value) {
          if (value.isNotEmpty && !validateEmail(value)) {
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
            _email = value;
          });
        },
        style: TextStyle(color: blackColor),
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
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    TextStyle labelStyle = TextStyle(
        fontSize: _height / _width * normalTextFontSize,
        fontWeight: FontWeight.bold);
    Map userData = widget.userData;

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
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            PageTitle(title: 'Personal Information'),
                            !isEditable
                                ? Expanded(
                                    child: editButton(
                                        height: _height,
                                        width: _width,
                                        buttonHeight: _height * .05,
                                        margin: EdgeInsets.only(
                                            top: _height * .01,
                                            right: _width * .02,
                                            left: _width * .34),
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
                            top: _height * .05,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name :", style: labelStyle),
                              _buildName(_height, _width, "eg: John Abraham"),
                              Text("Mobile Number :", style: labelStyle),
                              _buildPhoneNumber(
                                  _height,
                                  _width,
                                  userData['phone']['phone_number'],
                                  "eg: 9876543210"),
                              Text("Email (Optional) :", style: labelStyle),
                              _buildEmail(
                                  _height, _width, "eg: johnabraham@gmail.com"),
                            ],
                          ),
                        ),
                        errorBox(_height, _width, isError, error),
                        SizedBox(height: _height * .02),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .05),
                          child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: _height * .025),
                              color: isEditable ? primaryColor : greyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                    Map<String, dynamic> data = {
                                      'name': _name,
                                      'phone': {
                                        'country_code': _countryCode,
                                        'phone_number': _phoneNumber
                                      },
                                      'email': _email
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
                                    if (result.toString().startsWith("Error")) {
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

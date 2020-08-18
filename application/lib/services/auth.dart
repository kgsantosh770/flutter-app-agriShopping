import 'package:agri_shopping/Screens/otpScreen.dart';
import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID;
  bool codeSent = false;
  String email = 'agrishopping90@gmail.com';
  String password = 'shoppingagri90';

  //Firebase Errors
  String selectError(var error) {
    String errorMessage = '';
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Wrong password.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;

      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Password must be atleast 6 characters.";
        break;

      case "ERROR_NETWORK_REQUEST_FAILED":
        errorMessage = "Check your internet connection and try again.";
        break;

      case "INVALID_NUMBER":
        errorMessage = "Invalid phone number.";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
    errorMessage = "Error :" + errorMessage;
    return errorMessage;
  }

  // streams when state is changed
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future getUsername() async {
    return _auth.currentUser();
  }

  // send email
  Future sendEmail(
    String subject,
    String htmlMessage,
  ) async {
    final smtpServer = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'Agri Admin')
      ..recipients.add(email)
      ..subject = subject
      ..html = htmlMessage;

    try {
      final sendReport = await send(message, smtpServer);
      return 'Message sent: ' + sendReport.toString();
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return "Error sending message.";
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPasswrod(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // if (user.isEmailVerified)
      return user;
      // else {
      //   await _auth.signOut();
      //   return "Error :Please verify your email.";
      // }
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // sign in with authentication credentials
  Future signInWithCredentials(String name, String countryCode,
      String phoneNumber, AuthCredential authCredential) async {
    try {
      // AuthResult result =
      await _auth.signInWithCredential(authCredential);
      // FirebaseUser user = result.user;
      // await DatabaseService(uid: user.uid).setUserData(name,
      //     countryCode: countryCode, phoneNumber: phoneNumber);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign in with OTP
  Future signInWithOtp(String name, String countryCode, String phoneNumber,
      String verID, String smsCode) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.getCredential(
          verificationId: verID, smsCode: smsCode);
      await signInWithCredentials(
          name, countryCode, phoneNumber, authCredential);
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      FirebaseUser user = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user.sendEmailVerification();
        return value.user;
      });
      updateName(name, user);
      await DatabaseService(uid: user.uid).setUserData(name, email: email);
      return user;
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // verify phone number
  Future verifyPhone(BuildContext context, String name, String countryCode,
      String phoneNumber) async {
    try {
      final PhoneVerificationCompleted verified =
          (AuthCredential authCredential) async {
        await signInWithCredentials(
            name, countryCode, phoneNumber, authCredential);
        // this.signedIn = true;
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        print('${authException.message}');
      };

      final PhoneCodeSent codeSent = (String verID, [int forceResend]) {
        print("came to codeSent");
        this.verificationID = verID;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Otp(userData: {
            'name': name,
            'phoneNumber': phoneNumber,
            'countryCode': countryCode
          }),
        ));
      };

      final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout =
          (String verID) {
        this.verificationID = verID;
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phoneNumber,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
        timeout: const Duration(seconds: 40),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
      );
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // Reset Password
  Future resetPassword(String email) async {
    try {
      print(email);
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // update name
  Future updateName(String name, FirebaseUser user) async {
    try {
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = name;
      user.updateProfile(userUpdateInfo);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}

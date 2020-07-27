import 'package:agri_shopping/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  // sign in anonymous
  Future signInAnonymous() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPasswrod(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return selectError(e);
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      updateName(name, user);
      await DatabaseService(uid: user.uid).setUserData(name, email);
      return user;
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

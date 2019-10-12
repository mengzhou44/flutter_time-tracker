import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String userId;
  User({@required this.userId});
}

abstract class AuthBase {
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPasswprd(String email, String password);
  Future<User> createUserWithEmailAndPasswprd(String email, String password);
  Future<User> get currentUser;
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
}

class Auth implements AuthBase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(userId: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    var authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithEmailAndPasswprd(String email, String password) async {
    var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPasswprd(
      String email, String password) async {
    var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(code: 'ERROR_MISSING_TOKEN', message:'Missing Auth Token');
      }
    } else {
        throw PlatformException(code: 'ERROR_USER_ABORT', message:'User aborted!');
    }
  }

  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );

    if (result.accessToken != null) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);

      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);

      return _userFromFirebase(authResult.user);
    } else {
       throw PlatformException(code: 'ERROR_MISSING_TOKEN', message:'Missing Auth Token');
      
    }
  }

  Future<User> get currentUser async {
    var temp = await _firebaseAuth.currentUser();
    return _userFromFirebase(temp);
  }

  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final facebookLogin = FacebookLogin();
      await facebookLogin.logOut();

      await _firebaseAuth.signOut();
    } catch (exception) {
      print(exception);
    }
  }
}

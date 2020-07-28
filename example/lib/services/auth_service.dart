import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map(
            (user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async => (await _firebaseAuth.currentUser()).uid;

  // GET CURRENT USER
  Future getCurrentUser() async => await _firebaseAuth.currentUser();

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password,
      String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(String email,
      String password) async => (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user.uid;

  // Sign Out
  // ignore: type_annotate_public_apis
  signOut() => _firebaseAuth.signOut();

  // Reset Password
  Future sendPasswordResetEmail(String email) async => _firebaseAuth.sendPasswordResetEmail(email: email);

  // Create Anonymous User
  Future singInAnonymously() => _firebaseAuth.signInAnonymously();

  Future convertUserWithEmail(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();

    final credential = EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  Future convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    // ignore: omit_local_variable_types
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    // ignore: omit_local_variable_types
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    // ignore: omit_local_variable_types
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      // ignore: omit_local_variable_types
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    // ignore: omit_local_variable_types
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    // ignore: omit_local_variable_types
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    // ignore: omit_local_variable_types
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  // APPLE
  Future signInWithApple() async {
    // ignore: omit_local_variable_types
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        // ignore: omit_local_variable_types
        final AppleIdCredential _auth = result.credential;
        // ignore: omit_local_variable_types
        final OAuthProvider oAuthProvider = OAuthProvider(providerId: "apple.com");

        final AuthCredential credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(_auth.identityToken),
          accessToken: String.fromCharCodes(_auth.authorizationCode),
        );

        await _firebaseAuth.signInWithCredential(credential);

        // update the user information
        if (_auth.fullName != null) {
          _firebaseAuth.currentUser().then( (value) async {
            var user = UserUpdateInfo();
            user.displayName = "${_auth.fullName.givenName} ${_auth.fullName.familyName}";
            await value.updateProfile(user);
          });
        }

        break;

      case AuthorizationStatus.error:
        print("Sign In Failed ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        print("User Cancled");
        break;
    }
  }

}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}

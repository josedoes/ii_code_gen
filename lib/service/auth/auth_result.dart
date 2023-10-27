import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationResult {
  /// Firebase user
  final User? user;

  /// Contains the error message for the request
  final String? errorMessage;
  final String? exceptionCode;

  FirebaseAuthenticationResult({this.user})
      : errorMessage = null,
        exceptionCode = null;

  FirebaseAuthenticationResult.error({this.errorMessage, this.exceptionCode})
      : user = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

String getErrorMessageFromFirebaseException(FirebaseAuthException exception) {
  switch (exception.code.toLowerCase()) {
    case 'email-already-in-use':
      return 'An account already exists for the email you\'re trying to use. Login instead.';
    case 'invalid-email':
      return 'The email you\'re using is invalid. Please use a valid email.';
    case 'operation-not-allowed':
      return 'The authentication is not enabled on Firebase. Please enable the Authentitcation type on Firebase';
    case 'weak-password':
      return 'Your password is too weak. Please use a stronger password.';
    case 'wrong-password':
      return 'You seemed to have entered the wrong password. Double check it and try again.';
    default:
      return exception.message ??
          'Something went wrong on our side. Please try again';
  }
}
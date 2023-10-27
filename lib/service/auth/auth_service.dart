import 'package:firebase_auth/firebase_auth.dart';
import 'package:ii_code_gen/service/data_dog_service.dart';
import 'package:open_llm_studio_api/model/terms.dart';
import 'package:open_llm_studio_api/model/user.dart';
import 'package:open_llm_studio_api/repository/project_repository.dart';
import 'package:open_llm_studio_api/repository/terms_repository.dart';
import 'package:open_llm_studio_api/repository/user_repository.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';

import '../../util/logging.dart';
import 'auth_result.dart';

FirebaseAuthService get firebaseAuthService => locate<FirebaseAuthService>();

class FirebaseAuthService {
  final tag = 'FirebaseAuthService';

  FirebaseAuth get auth => FirebaseAuth.instance;

  bool get isSignedIn => user != null;

  Terms? get _terms => termsRepository.termsCache.values.isEmpty
      ? null
      : termsRepository.termsCache.values.first;


  User? get user => auth.currentUser;

  String? get uid => user?.uid;

  AuthCredential? _pendingCredential;

  UserModel? get userModel => userModelRepository.userModelCache[uid ?? ''];

  Future<bool> initUser() async {
    devLog(tag: tag, message: 'Init user called');
    await reloadUserIfExists();
    if (hasUser) {
      // dataDogService.setUserInfo(id: uid ?? '', email: user?.email ?? '');
    }
    devLog(tag: tag, message: 'Init user returned $uid');
    return hasUser;
  }

  Future<void> reloadUserIfExists() async {
    return firebaseAuthService.auth.currentUser?.reload();
  }

  String? token;

  /// Returns the latest userToken stored in the Firebase Auth lib
  Future<String?> getUserBearerToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String? token = await user.getIdToken();
        devLog(tag: tag, message: 'Bearer $token');
        return token;
      } else {
        return null;
      }
    } catch (e) {
      devLog(
          tag: tag,
          message: "An error occurred while trying to get the token: $e");
      return null;
    }
  }

  /// Returns true when a user has logged in or signed on this device
  bool get hasUser {
    return auth.currentUser != null;
  }

  /// Exposes the authStateChanges functionality.
  Stream<User?> get authStateChanges {
    return auth.authStateChanges();
  }

  Future<bool> emailExists(String email) async {
    try {
      final signInMethods = await auth.fetchSignInMethodsForEmail(email);

      return signInMethods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      return e.code.toLowerCase() == 'invalid-email';
    }
  }

  void _clearPendingData() {
    _pendingCredential = null;
  }

  Future<FirebaseAuthenticationResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      devLog(tag: tag, message: 'email:$email');
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      devLog(
          tag: tag,
          message:
              'Sign in with email result: ${result.credential} ${result.user}');

      // Link the pending credential with the existing account
      if (_pendingCredential != null) {
        await result.user?.linkWithCredential(_pendingCredential!);
        _clearPendingData();
      }

      return FirebaseAuthenticationResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      errorLog(tag: tag, message: 'A firebase exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          exceptionCode: e.code.toLowerCase(),
          errorMessage: getErrorMessageFromFirebaseException(e));
    } on Exception catch (e) {
      errorLog(tag: tag, message: 'A general exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage:
              'We could not log into your account at this time. Please try again.');
    }
  }

  /// Uses `createUserWithEmailAndPassword` to sign up to the Firebase application
  Future<FirebaseAuthenticationResult> createAccountWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      devLog(tag: tag, message: 'Created Email: $email');

      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      devLog(
          tag: tag,
          message:
              'Create user with email result: ${result.credential} ${result.user}');

      if (result.user != null) {
        final UserModel userModel = UserModel(
          lastAcceptedTermsVersion: null,
          projects:
              projectRepository.projectCache.values.map((e) => e.id).toList(),
          id: result.user?.uid,
          email: result.user?.email,
          openaiKey: "",
          role: "admin",
          sessions: const [],
          subscribed: false,
          subscriptionExpiry: "",
          subscriptionPackage: "",
          stripeID: '',
        );

        await userModelRepository.create(
          model: userModel,
        );

        dataDogService.setUserInfo(
            id: result.user?.uid ?? '', email: result.user?.email ?? '');
      }

      return FirebaseAuthenticationResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      devLog(tag: tag, message: 'A firebase exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          exceptionCode: e.code.toLowerCase(),
          errorMessage: getErrorMessageFromFirebaseException(e));
    } on Exception catch (e) {
      devLog(tag: tag, message: 'A general exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage:
              'We could not create your account at this time. Please try again.');
    }
  }

  /// Update the [password] of the Firebase User
  Future updatePassword(String password) async {
    await auth.currentUser?.updatePassword(password);
  }

  /// Update the [email] of the Firebase User
  Future updateEmail(String email) async {
    await auth.currentUser?.updateEmail(email);
  }

  /// Send reset password link to email
  Future<bool> sendResetPasswordLink(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      errorLog(
        tag: tag,
        message: 'Could not send email with reset password link. $e',
      );
      return false;
    }
  }

  Future signUpWithEmail(
      {required String email, required String password}) async {
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  /// Sign out from firebase
  Future logout() async {
    devLog(tag: tag, message: 'Logout from firebase');

    try {
      await auth.signOut();
      dataDogService.endSession();
      _clearPendingData();
    } catch (e) {
      errorLog(tag: tag, message: 'Could not sign out of social account. $e');
    }
  }

  // void signInAnonymously() {
  //   auth.signInAnonymously();
  //   auth.currentUser?.reload();
  // }

  Future<void> createTeamMember({
    required String email,
  }) async {
    if (hasUser) {
      await auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: "https://artificial-integrity-dev.web.app/#/invite/",
          handleCodeInApp: true,
        ),
      );
    }
  }
}

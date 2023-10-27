import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:open_llm_studio_api/repository/user_repository.dart';
import 'package:stacked/stacked.dart';

import '../service/data_dog_service.dart';
import '../util/logging.dart';

class LoginViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  void initState() async {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    if (kDebugMode) {
      usernameController.text = 'test@test.test';
      passwordController.text = '12341234';
    }
  }

  bool get loginBusy => busy('onLogin');

  onLogin(BuildContext context) async {
    runBusyFuture(
      busyObject: 'onLogin',
      Future(
        () async {
          if (formKey.currentState!.validate()) {
            await login(
              context: context,
              email: usernameController.text,
              password: passwordController.text,
            );
          }
        },
      ),
    );
  }

  final tag = 'LoginModel';
  bool hasError = false;

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    resetError();

    final result = await firebaseAuthService.loginWithEmail(
      email: email,
      password: password,
    );

    if (result.user != null) {
      dataDogService.setUserInfo(
        id: result.user?.uid ?? '',
        email: result.user?.email ?? '',
      );

      final user = await userModelRepository.read(id: result.user?.uid ?? '');

      if (user.isRight) {
        OpenAI.apiKey = user.right?.openaiKey ?? '';
      }

      await firebaseAuthService.getUserBearerToken();
      devLog(tag: tag, message: 'Bearer ${firebaseAuthService.token}');
    } else {
      hasError = true;
      notifyListeners();
    }
  }

  void resetError() {
    hasError = false;
    notifyListeners();
  }

  void onForgotPassword() {}

  bool keepSignedIn() {
    return true;
  }

  void onKeepSignedInChanged(bool value) {}

  void onCreateAccount() {}
}

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:ii_code_gen/service/app_version/app_service.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:ii_code_gen/service/data_dog_service.dart';
import 'package:ii_code_gen/util/logging.dart';
import 'package:open_llm_studio_api/model/user.dart';
import 'package:open_llm_studio_api/repository/project_repository.dart';
import 'package:open_llm_studio_api/repository/terms_repository.dart';
import 'package:open_llm_studio_api/repository/user_repository.dart';
import 'package:open_llm_studio_api/service/ai_service.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';
import 'package:stacked/stacked.dart';

import '../service/navigation_service.dart';

AppViewModel get appViewModel => locate<AppViewModel>();

class AppViewModel extends BaseViewModel {
  final tag = 'AppViewModel';
  Function() refresh = () {};


  Future<void> init() async {
    runBusyFuture(Future(() async {
      final canGoToProjects = await initUser();
      if (canGoToProjects) {

      }
      devLog(tag: tag, message: 'Version: ${appService.currentPackageVersion}');
    }));
  }

  final goToProjects = 'Go To Projects';

  bool projectDropdownIsExpanded = false;

  void onProjectsExpand() {
    projectDropdownIsExpanded = !projectDropdownIsExpanded;
    notifyListeners();
  }

  Future<bool> initUser() async {
    await firebaseAuthService.initUser();
    if (firebaseAuthService.uid != null) {
      await termsRepository.read(id: 'terms');
      final response =
          await userModelRepository.read(id: firebaseAuthService.uid!);

      if (response.isRight && response.right != null) {
        final user = response.right;
        OpenAI.apiKey = user?.openaiKey ?? '';
      } else {
        await userModelRepository.create(
            model: UserModel(
          lastAcceptedTermsVersion: null,
          projects:
              projectRepository.projectCache.values.map((e) => e.id).toList(),
          id: firebaseAuthService.uid,
          email: firebaseAuthService.user?.email,
          openaiKey: '',
          role: null,
          sessions: null,
          subscribed: null,
          subscriptionExpiry: null,
          subscriptionPackage: null, stripeID: '',
        ));
      }

      await dataDogService.init();

      await dataDogService.setUserInfo(
        id: firebaseAuthService.uid ?? '',
        email: firebaseAuthService.user?.email ?? '',
      );
      return true;
    } else {
      return false;
    }
  }

  String initials() {
    return firebaseAuthService.user?.displayName
            ?.split(' ')
            .reduce((value, element) => element[0]) ??
        firebaseAuthService.user?.email?[0] ??
        '';
  }

  String email() => firebaseAuthService.user?.email ?? '';

  void goToUser() {
    navigationService.goToHome();
  }

  bool needsAPIKey() {
    devLog(tag: tag, message: 'needsAPIKey called');
    final uid = firebaseAuthService.uid;
    if (uid != null) {
      final model = firebaseAuthService.userModel;
      if (model != null) {
        final needs =
            model.openaiKey == null || (model.openaiKey?.isEmpty ?? true);
        devLog(tag: tag, message: 'needsAPIKey: returning ${needs}');
        if (model.openaiKey?.isNotEmpty ?? false) {
          OpenAI.apiKey = model.openaiKey ?? '';
        }
        return needs;
      }
    }
    devLog(tag: tag, message: 'needsAPIKey: returning false');
    return false;
  }

  final openAIKeyController = TextEditingController();

  void saveAPIKey() {
    devLog(tag: tag, message: 'saveAPIKey called');
    runBusyFuture(Future(() async {
      try {
        final key = openAIKeyController.text;
        OpenAI.apiKey = key;
        final result = await aiService.getOpenAiEmbeddings(['a']);
        final user = firebaseAuthService.userModel;

        await userModelRepository.update(
            model: user!.copyWith(
          openaiKey: key,
        ));
        devLog(tag: tag, message: 'saveAPIKey success');
      } catch (e) {
        devLog(tag: tag, message: 'Theres been an error $e');
        this.setErrorForObject(
          'saveAPIKey',
          'Error: Please ensure your key is valid',
        );
      }
    }), busyObject: 'saveAPIKey');
  }
}

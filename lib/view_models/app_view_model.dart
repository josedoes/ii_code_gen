import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:ii_code_gen/service/app_version/app_service.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:ii_code_gen/util/logging.dart';
import 'package:stacked/stacked.dart';

import '../main.dart';
import '../service/navigation_service.dart';

AppViewModel get appViewModel => locate<AppViewModel>();

class AppViewModel extends BaseViewModel {
  final tag = 'AppViewModel';
  Function() refresh = () {};

  Future<void> init() async {
    runBusyFuture(Future(() async {
      final canGoToProjects = await initUser();
      if (canGoToProjects) {}
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
    return true;
  }



  void goToUser() {
    navigationService.goToBaseModel();
  }

  final openAIKeyController = TextEditingController();

  void saveAPIKey() {
    devLog(tag: tag, message: 'saveAPIKey called');
    runBusyFuture(Future(() async {
      try {
        final key = openAIKeyController.text;
        OpenAI.apiKey = key;

        // await userModelRepository.update(
        //     model: user!.copyWith(
        //   openaiKey: key,
        // ));
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

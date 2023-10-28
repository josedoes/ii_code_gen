import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get_it/get_it.dart';
import 'package:ii_code_gen/repository/base_model_repository.dart';
import 'package:ii_code_gen/repository/project_repository.dart';
import 'package:ii_code_gen/service/app_version/app_service.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:ii_code_gen/service/base_model_service.dart';
import 'package:ii_code_gen/service/firebase/firebase_service.dart';
import 'package:ii_code_gen/service/navigation_service.dart';
import 'package:ii_code_gen/service/project_service.dart';
import 'package:ii_code_gen/service/scaffold_service.dart';
import 'package:ii_code_gen/view/app.dart';
import 'package:ii_code_gen/view_models/app_view_model.dart';

import 'flavors/prod.dart';

bool isTest = false;

Future<void> main(args, Flavor flavor) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    flavour = flavor;
    final app = await Firebase.initializeApp(
      options: kIsWeb ? firebaseOptionsByFlavor(flavor) : null,
    );

    final originalOnError = FlutterError.onError;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (!kDebugMode) {
        // DatadogSdk.instance.rum?.handleFlutterError(details);
      }
      originalOnError?.call(details);
    };

    register(FirebaseAuthService());
    register(AppService());
    register(AppViewModel());
    register(ScaffoldService());
    register(NavigationService());

    register(FirestoreService(firestore: FirebaseFirestore.instance));

    register(ProjectService());
    register(ProjectRepository());

    register(BaseModelService());
    register(BaseModelRepository());

    final appVersion = await appService.versionNumber();

    debugPrint('Running ${appVersion} ${flavor.name}');

    runApp(const App());
  }, (e, s) {
    if (!kDebugMode) {
      // DatadogSdk.instance.rum?.addErrorInfo(
      //   e.toString(),
      //   RumErrorSource.source,
      //   stackTrace: s,
      // );
    }
    if (isTest) {
      throw e;
    }
  });
}

String getBaseUrl(Flavor flavor) {
  switch (flavor) {
    case Flavor.dev:
      // return 'http://localhost:8443';
      return 'https://launch-api.com:8443';
    case Flavor.prod:
      return 'https://launch-api.com';
    case Flavor.local_dev:
      return 'http://localhost:8443';
  }
}

FirebaseOptions firebaseOptionsByFlavor(Flavor flavour) {
  const dev = FirebaseOptions(
    apiKey: "AIzaSyD3ilCEM1cKczNysDzvPB6zXwTUBLT067I",
    authDomain: "code-gen-dev.firebaseapp.com",
    projectId: "code-gen-dev",
    storageBucket: "code-gen-dev.appspot.com",
    messagingSenderId: "54290700732",
    appId: "1:54290700732:web:4f8a55846e12b8b5a473b9",
    measurementId: "G-MKBYM3D7GV",
  );

  const prod = FirebaseOptions(
      apiKey: "AIzaSyCFH67lsyE3Dkdeahc16Bb0UugGiRCzvmA",
      authDomain: "artificial-intelligence-b3136.firebaseapp.com",
      projectId: "artificial-intelligence-b3136",
      storageBucket: "artificial-intelligence-b3136.appspot.com",
      messagingSenderId: "531338076804",
      appId: "1:531338076804:web:adcf3545c8feb27df598d1",
      measurementId: "G-QMBQS0EQ17");

  switch (flavour) {
    case Flavor.dev:
      return dev;
    case Flavor.prod:
      return prod;
    case Flavor.local_dev:
      return dev;
  }
}

register<T extends Object>(T obj) => GetIt.instance.registerSingleton<T>(obj);

locate<T extends Object>() => GetIt.instance<T>();

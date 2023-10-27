import 'dart:async';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:ii_code_gen/service/app_version/app_service.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:ii_code_gen/service/data_dog_service.dart';
import 'package:ii_code_gen/service/file_service.dart';
import 'package:ii_code_gen/service/navigation_service.dart';
import 'package:ii_code_gen/service/scaffold_service.dart';
import 'package:ii_code_gen/util/logging.dart';
import 'package:ii_code_gen/view/app.dart';
import 'package:ii_code_gen/view_models/app_view_model.dart';
import 'package:open_llm_studio_api/open_llm_studio_api.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';

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
        DatadogSdk.instance.rum?.handleFlutterError(details);
      }
      originalOnError?.call(details);
    };

    await initDatadog(flavour: flavor);

    await initOpenLlmStudio(
        baseUrl: getBaseUrl(flavor),
        getFirebaseAuthToken: () async =>
            (await firebaseAuthService.getUserBearerToken()) ?? '',
        logError: (a) {
          if (kDebugMode) {
            print(a);
          } else {
            DatadogSdk.instance.logs?.error(a);
          }
        },
        log: (a) {
          if (kDebugMode) {
            print(a);
            // DatadogSdk.instance.logs?.info(a);
          } else {
            // DatadogSdk.instance.logs?.info(a);
          }
        });

    register(FirebaseAuthService());
    register(AppService());
    register(AppViewModel());
    register(ScaffoldService());
    register(NavigationService(dataDogService.observer));

    final appVersion = await appService.versionNumber();

    debugPrint('Running ${appVersion} ${flavor.name}');

    runApp(const App());
  }, (e, s) {
    if (!kDebugMode) {
      DatadogSdk.instance.rum?.addErrorInfo(
        e.toString(),
        RumErrorSource.source,
        stackTrace: s,
      );
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

Future<void> initDatadog({required Flavor flavour}) async {
  final datadog = DataDogService(
    applicationId: 'd56797e1-1dfc-4c67-802a-302840a2b93e',
    clientToken: 'pub5ca8eb677f969e1223dae68f3dc8b724',
    flavor: flavour.name,
  );

  register(datadog);

  try {
    await datadog.init();
  } catch (e) {
    errorLog(tag: 'main', message: 'Error with datadog init');
  }
}

FirebaseOptions firebaseOptionsByFlavor(Flavor flavour) {
  const dev = FirebaseOptions(
      apiKey: "AIzaSyB_wKCA_MbkNq-Rzz0YgsZRd8vVvmIGmgI",
      authDomain: "artificial-integrity-dev.firebaseapp.com",
      projectId: "artificial-integrity-dev",
      storageBucket: "artificial-integrity-dev.appspot.com",
      messagingSenderId: "371058866019",
      appId: "1:371058866019:web:4dfe289c4ddb26818f0556",
      measurementId: "G-J0073B76J0");
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

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ii_code_gen/util/logging.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';

DataDogService get dataDogService => locate<DataDogService>();

class DataDogService {
  DataDogService({
    required this.clientToken,
    required this.applicationId,
    required String flavor,
  }) {
    configuration = DdSdkConfiguration(
      clientToken: clientToken,
      env: flavor,
      site: DatadogSite.us1,
      trackingConsent: TrackingConsent.granted,
      nativeCrashReportEnabled: true,
      loggingConfiguration: LoggingConfiguration(
        bundleWithRum: true,
        bundleWithTrace: true,
        // datadogReportingThreshold: Verbosity.debug,
        sendLogsToDatadog: true,
        printLogsToConsole: kDebugMode,
      ),
      rumConfiguration: RumConfiguration(
        applicationId: applicationId,
        rumViewEventMapper: (event) {
          devLog(tag: tag, message: 'Mapper called');
          // devLog(tag:tag, message: event);
          return event;
        },
      ),
    );
  }

  final tag = 'DataDogService';
  final String clientToken;
  final String applicationId;

  late final DdSdkConfiguration configuration;

  Future<void> init() async {
    devLog(tag: tag, message: 'init called');
    await DatadogSdk.instance.initialize(configuration);
    devLog(tag: tag, message: 'init completed');
  }

  Future<void> setUserInfo({
    required String id,
    required String email,
  }) async {
    devLog(tag: tag, message: 'setUserInfo called');
    DatadogSdk.instance.setUserInfo(
      id: id,
      email: email,
    );

    DatadogSdk.instance.logs?.addAttribute(
      'uid',
      id,
    );
    devLog(tag: tag, message: 'setUserInfo completed');
  }

  DatadogNavigationObserver get observer => DatadogNavigationObserver(
        datadogSdk: DatadogSdk.instance,
        viewInfoExtractor: routeInfoExtractor,
      );

  RumViewInfo? routeInfoExtractor(Route<dynamic> route) {
    if (route is PageRoute) {
      var name = route.settings.name;
      if (name != null) {
        return RumViewInfo(name: name);
      }
    }

    return null;
  }

  void logInfo(String log) {
    DatadogSdk.instance.logs?.debug(
      log,
    );
  }

  void logError(String log) {
    DatadogSdk.instance.logs?.error(
      log,
    );
  }

  void endSession() {
    DatadogSdk.instance.rum?.stopSession();
  }
}

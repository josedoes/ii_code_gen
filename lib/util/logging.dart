import 'package:flutter/foundation.dart';
import 'package:ii_code_gen/service/data_dog_service.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';

void devLog({
  required String tag,
  required String message,
}) {
  final log = '$tag $message';
  if (kDebugMode) {
    print(log);
  } else {}
}

void errorLog({
  required String tag,
  required String message,
  StackTrace? stackTrace,
}) {
  final log = 'ERROR IN $tag: $message';
  if (kDebugMode) {
    print(log);
  } else {
    dataDogService.logError(log);
  }
}

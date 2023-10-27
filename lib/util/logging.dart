import 'package:flutter/foundation.dart';



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
  }
}

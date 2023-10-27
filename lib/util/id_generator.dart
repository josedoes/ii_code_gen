import 'dart:math';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

String newId() => uuid.v4();

bool isValidIP(String name) {
  final RegExp ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$');
  return ipRegex.hasMatch(name);
}

String generateMemoryId() {
  const validStartAndEndChars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();

  String uniqueId;

  do {
    final uuid = Uuid().v4();

    final startChar =
        validStartAndEndChars[rand.nextInt(validStartAndEndChars.length)];
    final endChar =
        validStartAndEndChars[rand.nextInt(validStartAndEndChars.length)];

    uniqueId = '$startChar$uuid$endChar';
  } while (isValidIP(uniqueId) || uniqueId.length > 63);

  return uniqueId;
}

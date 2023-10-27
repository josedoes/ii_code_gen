import 'package:either_dart/either.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../util/logging.dart';
import 'firebase_app_version_service.dart';

AppService get appService => locate<AppService>();

class AppService {
  final String tag = 'AppService';
  String currentPackageVersion = '';
  bool isMobile = true;

  Future<Either<String, String>> versionNumber() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      currentPackageVersion =
          packageInfo.version + ' + ' + packageInfo.buildNumber;
      return Right(currentPackageVersion);
    } catch (e, s) {
      errorLog(tag: tag, message: '${e}', stackTrace: s);
      return Left('Theres been an error');
    }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }

  Future<bool> appVersionIsValid({required String appVersion}) async {
    final String minVersion =
        await firebaseAppVersionService.firebaseAppVersion();
    final int appV = getExtendedVersionNumber(appVersion);
    final int minV = getExtendedVersionNumber(minVersion);

    final isValid = minV <= appV;
    return isValid;
  }
}

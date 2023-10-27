import 'package:ii_code_gen/main.dart';
import 'package:ii_code_gen/service/firebase/firebase_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  MockFirestoreService() {
    register<FirestoreService>(this);
  }
}

// class MockCloudStorageService extends Mock implements CloudStorageService {
//   MockCloudStorageService() {
//     register<CloudStorageService>(this);
//   }
// }

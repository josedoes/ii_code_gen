// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:async/async.dart';
// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:either_dart/either.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';
// import 'package:get_it/get_it.dart';
// import 'package:open_llm_studio_api/model/user_document.dart';
// import 'package:open_llm_studio_api/repository/user_document_repository.dart';
// import 'package:open_llm_studio_api/service/firebase/cloud_storage_service.dart';
// import 'package:path/path.dart';
// import 'package:universal_html/html.dart' as html;
//
// import '../util/id_generator.dart';
// import '../util/logging.dart';
// import 'auth/auth_service.dart';
//
// FileService get fileService => GetIt.instance<FileService>();
//
// class FileService {
//   final tag = 'FileService';
//   CancelableOperation? completer;
//   late DropzoneViewController controller;
//
//   Future<Either<String, String?>> manualUpload(
//       {required bool returnFileText}) async {
//     final pickedFiles = await controller.pickFiles();
//     if (pickedFiles.isNotEmpty) {
//       String? fullText;
//       final _file = pickedFiles.first;
//       final extension = (_file.name as String).split('.').last.toLowerCase();
//       final pass = extension == 'pdf' ||
//           extension == 'docx' ||
//           extension == 'txt' ||
//           extension == 'epub';
//
//       if (!pass) {
//         devLog(tag: tag, message: 'invalid doc');
//         return Left('Sorry! ${_file.name} is not in a valid format');
//       }
//
//       try {
//         print(_file.runtimeType);
//         fullText = await _uploadFile(_file, returnFileText);
//         return Right(fullText);
//       } catch (e) {
//         errorLog(tag: tag, message: '$manualUpload exception $e');
//         return Left(e.toString());
//       }
//     }
//     return Left('Sorry there was an unexpected error');
//   }
//
//   Future<Either<String, String?>> handleDropEvent(
//       event, bool getFileText) async {
//     try {
//       String? fullText;
//       final extension = (event.name as String).split('.').toList().last;
//
//       final pass = extension == 'pdf' ||
//           extension == 'docx' ||
//           extension == 'txt' ||
//           extension == 'epub';
//
//       if (!pass) {
//         devLog(tag: tag, message: 'invalid doc');
//         return const Left('Sorry your file type is invalid¬');
//       }
//
//       completer = CancelableOperation.fromFuture(
//         Future(
//           () async {
//             final fileBytes = await controller.getFileData(event);
//             final blob = html.Blob([fileBytes]);
//             final file = html.File([blob], event.name);
//
//             fullText = await _uploadFile(file, getFileText);
//           },
//         ),
//       );
//       await completer?.value;
//       return Right(fullText);
//     } catch (e) {
//       errorLog(tag: tag, message: 'handleDropEvent error: $e');
//       return Left('');
//     }
//   }
//
//   Future<String?> _uploadFile(file, bool getFileText) async {
//     const method = '_uploadFile';
//     devLog(tag: tag, message: '$method started');
//     try {
//       String? fileText;
//       const method = 'uploadFile';
//       devLog(tag: tag, message: '$method started');
//
//       final reader = html.FileReader();
//       reader.readAsArrayBuffer(file);
//       await reader.onLoadEnd.first;
//
//       final Uint8List bytes = reader.result as Uint8List;
//
//       final String fileName = basename(file.name);
//       final _newId = newId();
//
//       final uid = firebaseAuthService.uid;
//       final destinationPath = '$uid/$projectId/$_newId/$fileName';
//       devLog(tag: tag, message: '$method upload cloud storage started');
//       await cloudStorageService.uploadBytes(bytes, destinationPath);
//
//       devLog(tag: tag, message: '$method get download url started');
//       final link = await cloudStorageService.getDownloadURL(destinationPath);
//
//       final doc = UserDocument(
//         id: _newId,
//         name: file.name,
//         size: file.size,
//         projectId: projectId,
//         storagePath: destinationPath,
//         softDelete: false,
//         softDeleteTime: null,
//         storageLink: link,
//         tags: null,
//       );
//       if (getFileText) {
//         fileText = await _getFileText(
//           file,
//           bytes,
//           doc.storagePath,
//         );
//       }
//
//       devLog(tag: tag, message: '$method userDocumentRepository created doc');
//       await userDocumentRepository.create(model: doc);
//       return fileText;
//     } catch (e) {
//       errorLog(tag: tag, message: '$method exception:$e');
//     }
//   }
//
//   Future<String?> _getFileText(file, Uint8List bytes, path) async {
//     const method = 'getFileText';
//     devLog(tag: tag, message: '$method started');
//     try {
//       String? fullText;
//       String fileType = file.name.split('.').last;
//       switch (fileType) {
//         case 'pdf' || 'epub':
//           fullText = await cloudStorageService.extractTextFromPdfOrEpub(path);
//           break;
//         case 'txt':
//           fullText =
//               utf8.decode(bytes); // Handle text files by decoding the bytes.
//           break;
//         case 'docx':
//           fullText = docxToText(bytes, handleNumbering: true);
//           break;
//       }
//       return fullText;
//     } catch (e) {
//       errorLog(tag: tag, message: '$method exception:$e');
//     }
//   }
//
//   Future<Either<String, String>> getDocumentText(UserDocument document) async {
//     String fullText = '';
//     String fileType = (document.name ?? '').split('.').last;
//     switch (fileType) {
//       case 'pdf' || 'epub':
//         fullText = await cloudStorageService
//                 .extractTextFromPdfOrEpub(document.storagePath ?? '') ??
//             '';
//         break;
//       case 'txt':
//         fullText = await cloudStorageService
//                 .extractTextFromTxt(document.storagePath ?? '') ??
//             '';
//         break;
//       case 'docx':
//         fullText = await cloudStorageService
//                 .extractTextFromDocx(document.storagePath ?? '') ??
//             '';
//         break;
//     }
//     if (fullText.isNotEmpty) {
//       return Right(fullText);
//     } else {
//       return Left('Sorry there was an error reading your document');
//     }
//   }
// }

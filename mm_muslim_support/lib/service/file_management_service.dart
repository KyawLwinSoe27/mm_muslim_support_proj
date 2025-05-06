import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:path_provider/path_provider.dart';

class FileManagementService {

  /// Checks if a file with [fileName] already exists in the download directory.
  static Future<bool> fileExists(String fileName) async {
    final dir = await _getDownloadDirectory();
    final file = File('${dir.path}/$fileName');
    return file.exists();
  }

  /// Deletes a file by [fileName] from the download directory.
  static Future<void> deleteFile(String fileName) async {
    final dir = await _getDownloadDirectory();
    final file = File('${dir.path}/$fileName');
    if (await file.exists()) {
      await file.delete();
      debugPrint('File deleted: ${file.path}');
    }
  }

  /// Returns the appropriate directory for storing downloaded files.
  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory(); // safer than external on newer Androids
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<Directory> getDownloadDirectory(Folder folder) {
    return _getDownloadDirectory().then((dir) {
      final folderPath = '${dir.path}/${folder.name}';
      return Directory(folderPath).create(recursive: true);
    });
  }
}
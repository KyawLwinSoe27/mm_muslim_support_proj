import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:path_provider/path_provider.dart';

class LogService {
  late String fileName;
  static LogService? _logStorage;
  static bool? _isMockData;
  LogService._();
  Logger logger = Logger();

  static LogService get logStorage => _logStorage ??= LogService._();

  final bool _isDebug = false;

  Future<String> get _localPath async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getApplicationSupportDirectory();
    }
    return directory.path;
  }

  Future<File> get _localFile async {
    final String path = await _localPath;
    return File('$path/$fileName.txt');
  }

  Future<String> readLogs(String filename) async {
    fileName = filename;
    try {
      final File file = await _localFile;

      // Read the file
      final String contents = await file.readAsString();

      return contents;
    } on Exception catch (_) {
      // If encountering an error, return 0
      return 'null';
    }
  }

  Future<File> writeInfoLog(
    String cubit,
    String method,
    String logMessage,
  ) async {
    if (_isMockData != null && _isMockData == true) {
      return Future.value(File(''));
    } else {
      logMessage = 'Cubit: $cubit, Method: $method, Error: $logMessage';
      final String path = await _localPath;
      String logDate = DateUtility.DateTimeToString(
        DateTime.now(),
        CustomDateFormat.yearMonth2,
      );
      final File file = File('$path/${Folder.eventLog}$logDate.txt');
      await file.create(recursive: true);
      String infoLog =
          '${DateFormat('dd/MM/yyyy HH:mm:ss', 'en_US').format(DateTime.now())} $logMessage \n\n';
      return file.writeAsString(infoLog, mode: FileMode.append);
    }
  }

  // clear log by month
  Future<void> deleteLogFile(DateTime dateTime) async {
    final String path = await _localPath;
    String logDate = DateUtility.DateTimeToString(
      DateTime.now(),
      CustomDateFormat.yearMonth2,
    );
    final File file = File('$path/${Folder.eventLog}$logDate.txt');

    if (await file.exists()) {
      await file.delete();
    }
  }

  // terminal log for error
  void printErrorLog(String logMessage) {
    if (_isDebug) {
      logger.e(logMessage);
    }
  }

  void printWarningLog(String logMessage) {
    if (_isDebug) {
      logger.w(logMessage);
    }
  }

  // Add a method to set mock device information for testing/debugging.
  @visibleForTesting
  static void setMockInitialValues({bool? isMockData}) {
    _isMockData = isMockData;
  }
}

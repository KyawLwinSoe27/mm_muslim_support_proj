import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/service/log_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  static const String routeName = '/logs';

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  DateTime selectedDate = DateTime.now();
  LogService logStorage = LogService.logStorage;
  late Future<String> logMessage;
  late String formatDateTime;
  String? message;
  @override
  void initState() {
    super.initState();
    formatDateTime = DateFormat(
      'MMMM yyyy',
      'en_US',
    ).format(DateTime.parse(selectedDate.toString()));
    setUp();
  }

  void setUp() {
    String logDate = DateUtility.DateTimeToString(
      selectedDate,
      CustomDateFormat.yearMonth2,
    );
    String fileName = '${Folder.eventLog}$logDate';
    logMessage = logStorage.readLogs(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          'Activity Logs',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              bool? value = await DialogUtils.showConfirmationDialog(
                context,
                'Are you sure you want to delete logs?',
              );
              if (value == true && context.mounted) {
                context.back();
                await logStorage.deleteLogFile(selectedDate);
                setUp();
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decreaseDate,
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                Text(
                  formatDateTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _increaseDate,
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<String>(
                    future: logMessage,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error loading logs'));
                      } else if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data != 'null') {
                        final logText = snapshot.data!.replaceAll(',', '\n');
                        return SingleChildScrollView(
                          child: Text(
                            logText,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No logs found'));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _decreaseDate() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    });
    formatDateTime = DateFormat(
      'MMMM yyyy',
      'en_US',
    ).format(DateTime.parse(selectedDate.toString()));
    setUp();
  }

  void _increaseDate() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    });
    formatDateTime = DateFormat(
      'MMMM yyyy',
      'en_US',
    ).format(DateTime.parse(selectedDate.toString()));

    setUp();
  }
}

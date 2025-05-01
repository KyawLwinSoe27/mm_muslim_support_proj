import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/themes/text_theme.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class DailyQuranDuaWidget extends StatelessWidget {
  const DailyQuranDuaWidget({super.key, required this.dailyQuranDuaModel, required this.title});

  final DailyQuranDuaModel dailyQuranDuaModel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primary, // Green background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onPrimary)),
                dailyQuranDuaModel.reference.isNullOrEmpty
                    ? const SizedBox.shrink()
                    : Text(dailyQuranDuaModel.reference, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(dailyQuranDuaModel.arabic, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: arabicTextStyle(color: context.colorScheme.onPrimary)),
            ),
            const SizedBox(height: 16),
            Text(dailyQuranDuaModel.translation, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onPrimary)),
          ],
        ),
      ),
    );
  }
}

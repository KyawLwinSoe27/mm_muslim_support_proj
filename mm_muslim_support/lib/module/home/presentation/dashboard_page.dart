import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/model/historical_event.dart';
import 'package:mm_muslim_support/module/history/presentations/islamic_history_page.dart';
import 'package:mm_muslim_support/module/home/widgets/custom_card_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/feature_card_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_time_grid_widget.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/widget/islamic_history_widget.dart';
import 'package:mm_muslim_support/widget/text_button_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});



  @override
  Widget build(BuildContext context) {
    const List<String> features = [
      'Quran',
      'Qibla',
      'Hadith',
      'Donate Us',
      'Fatwa',
      'Islamic Articles',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const PrayerTimeGrid(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DailyQuranDuaWidget(title: 'Daily Dua', dailyQuranDuaModel: DailyQuranDuaModel(arabic: 'اللهم اجرني من النار.', translation: 'O Allah, protect me from Hell.', mmTranslation: '', reference: ''),),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DailyQuranDuaWidget(title: 'Daily Quran Verse', dailyQuranDuaModel: DailyQuranDuaModel(arabic: 'قَالَ لَا تَخَافَا إِنَّنِي مَعَكُمَا أَسْمَعُ وَأَرَىٰ', translation: 'Allah reassured ˹them˺, Have no fear! I am with you, hearing and seeing.', mmTranslation: '', reference: 'Surah Taha, Verse 46'),),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All Features', style: context.textTheme.titleMedium,),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100, // or whatever fits your design
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: features.length,
                    itemBuilder: (context, index) => FeatureCardWidget(title: features[index]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('History Articles', style: context.textTheme.titleMedium,),
                TextButtonWidget(text: 'See All', onPressed: () => context.navigateWithPushNamed(IslamicHistoryPage.islamicHistory),),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: historicalEvents.map((event) => IslamicHistoryWidget(event: event )).toList(),
          )
        ],
      ),
    );
  }
}



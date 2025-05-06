import 'package:mm_muslim_support/model/tasbih_model.dart';

class TasbihListModel {
  final String title;
  final String rewards;
  final List<TasbihModel> tasbihDetailDataList;

  TasbihListModel({required this.title, required this.rewards, required this.tasbihDetailDataList});
}

List<TasbihListModel> tasbihListModel = [
  TasbihListModel(title: 'သီးန်သတ်စ်ဗီဟ်', rewards: '', tasbihDetailDataList: _tasbihDetailDataList),
  TasbihListModel(title: 'سُبْحَانَ الله', rewards: '', tasbihDetailDataList: [TasbihModel(arabic: 'سُبْحَانَ الله', translation: 'Glory be to Allah', mmTranslation: '', count: 100)]),
  TasbihListModel(title: 'الحمد لله', rewards: '', tasbihDetailDataList: [TasbihModel(arabic: 'الحمد لله', translation: 'All praise is due to Allah', mmTranslation: '', count: 100)]),
  TasbihListModel(title: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهِ', rewards: '', tasbihDetailDataList: [TasbihModel(arabic: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰه', translation: 'There is no deity but God; Muhammad is the messenger of God', mmTranslation: '', count: 100)]),

];

List<TasbihModel> _tasbihDetailDataList = [
  TasbihModel(arabic: 'سبحان الله', translation: 'Glory be to Allah', mmTranslation: 'အလ္လာဟ်အရှင်အား ဂုဏ်ပြုပါ၏', count: 33),
  TasbihModel(arabic: 'الحمد لله', translation: 'All praise is due to Allah', mmTranslation: 'အလ္လာဟ်အရှင်အား ကျေးဇူးတင်ပါ၏', count: 33),
  TasbihModel(arabic: 'الله أكبر', translation: 'Allah is the Greatest', mmTranslation: 'အလ္လာဟ်အရှင်သည် အကြီးဆုံးဖြစ်သည်', count: 34),
];

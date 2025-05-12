import 'package:mm_muslim_support/model/tasbih_model.dart';

class TasbihListModel {
  final String title;
  final String rewards;
  final List<TasbihModel> tasbihDetailDataList;

  TasbihListModel({required this.title, required this.rewards, required this.tasbihDetailDataList});
}

List<TasbihListModel> tasbihListModel = [
  TasbihListModel(title: 'Tasbih, Tahmid & Takbir', rewards: '', tasbihDetailDataList: _tasbihDetailDataList),
  TasbihListModel(
    title: 'Subhanallah',
    rewards: '',
    tasbihDetailDataList: [TasbihModel(arabic: 'سُبْحَانَ اللّٰهِ', translation: 'Glory be to Allah', mmTranslation: '', count: 100, englishVoice: 'Subhanallah')],
  ),
  TasbihListModel(
    title: 'Alhamdulillah',
    rewards: '',
    tasbihDetailDataList: [TasbihModel(arabic: 'اَلْحَمْدُ لِلّٰه', translation: 'All praise is due to Allah', mmTranslation: '', count: 100, englishVoice: 'Alhamdulillah')],
  ),
  TasbihListModel(
    title: 'Shahada',
    rewards: '',
    tasbihDetailDataList: [
      TasbihModel(
        arabic: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهِ',
        translation: 'There is no deity but Allah; Muhammad is the messenger of Allah',
        mmTranslation: '',
        count: 100,
        englishVoice: 'La Ilaha Illallah Muhammadur Rasulullah',
      ),
    ],
  ),
  TasbihListModel(
    title: 'To earn one thousand hasanahs [good deeds] every day',
    rewards: '',
    tasbihDetailDataList: [
      TasbihModel(
        arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلاَ إِلَهَ إِلاَّ اللَّهُ وَاللَّهُ أَكْبَرُ وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّ',
        translation: 'Glory be to Allah, Praise be to Allah, There is no God but Allah, Allah is Great, There is no Support and No Power except in Allah. This would be the complete translation.',
        mmTranslation: '',
        count: 100,
        englishVoice: 'Subhanallah walhamdulillah wala ilaha illallah wallahu akbar wala hawla wala quwwata illa billah',
      ),
    ],
  ),
  TasbihListModel(
    title: 'Subhaanallaahi wa bihamdihi Adada khalqihi',
    rewards: '',
    tasbihDetailDataList: [
      TasbihModel(
        arabic: 'سُبْحـانَ اللهِ وَبِحَمْـدِهِ عَدَدَ خَلْـقِه ، وَرِضـا نَفْسِـه ، وَزِنَـةَ عَـرْشِـه ، وَمِـدادَ كَلِمـاتِـه',
        translation: 'Glory is to Allaah and praise is to Him, by the multitude of his creation, by His Pleasure, by the weight of His Throne, and by the extent of His Words.',
        mmTranslation: '',
        count: 100,
        englishVoice: 'Subhaanallaahi wa bihamdihi: ‘Adada khalqihi wa ridhaa nafsihi, wa zinata ‘arshihi wa midaada kalimaatihi.',
      ),
    ],
  ),
  TasbihListModel(
    title: 'Forgiveness',
    rewards: '',
    tasbihDetailDataList: [
      TasbihModel(
        arabic: 'أَسْتَغْفِرُ ٱللَّٰهَ',
        translation: 'I seek forgiveness from Allah',
        mmTranslation: '',
        count: 100,
        englishVoice: 'Astaghfirullah',
      ),
    ],
  ),
];

List<TasbihModel> _tasbihDetailDataList = [
  TasbihModel(arabic: 'سُبْحَانَ اللّٰهِ', translation: 'Glory be to Allah', mmTranslation: 'အလ္လာဟ်အရှင်အား ဂုဏ်ပြုပါ၏', count: 33, englishVoice: 'Subhanallah'),
  TasbihModel(arabic: 'اَلْحَمْدُ لِلّٰهِ', translation: 'All praise is due to Allah', mmTranslation: 'အလ္လာဟ်အရှင်အား ကျေးဇူးတင်ပါ၏', count: 33, englishVoice: 'Alhamdulillah'),
  TasbihModel(arabic: 'اَللّٰهُ أَكْبَرُ', translation: 'Allah is the Greatest', mmTranslation: 'အလ္လာဟ်အရှင်သည် အကြီးဆုံးဖြစ်သည်', count: 34, englishVoice: 'Allahu Akbar'),
];

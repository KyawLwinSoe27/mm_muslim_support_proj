import 'dart:io';

class TasbihModel {
  final String arabic;
  final String translation;
  final String mmTranslation;
  final int count;
  final File? mp3File;


  TasbihModel({
    required this.arabic,
    required this.translation,
    required this.mmTranslation,
    required this.count,
    this.mp3File,
  });
}


List<TasbihModel> tasbihList = [
  TasbihModel(
    arabic: 'سبحان الله',
    translation: 'Glory be to Allah',
    mmTranslation: 'အလ္လာဟ်အရှင်အား ဂုဏ်ပြုပါ၏',
    count: 33,
  ),
  TasbihModel(
    arabic: 'الحمد لله',
    translation: 'All praise is due to Allah',
    mmTranslation: 'အလ္လာဟ်အရှင်အား ကျေးဇူးတင်ပါ၏',
    count: 33,
  ),
  TasbihModel(
    arabic: 'الله أكبر',
    translation: 'Allah is the Greatest',
    mmTranslation: 'အလ္လာဟ်အရှင်သည် အကြီးဆုံးဖြစ်သည်',
    count: 34,
  ),
];
import 'dart:io';

class TasbihModel {
  final String arabic;
  final String translation;
  final String mmTranslation;
  final int count;
  final File? mp3File;
  final String englishVoice;


  TasbihModel({
    required this.arabic,
    required this.translation,
    required this.mmTranslation,
    required this.count,
    required this.englishVoice,
    this.mp3File,
  });
}
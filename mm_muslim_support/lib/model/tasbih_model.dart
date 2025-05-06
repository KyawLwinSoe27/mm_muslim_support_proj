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
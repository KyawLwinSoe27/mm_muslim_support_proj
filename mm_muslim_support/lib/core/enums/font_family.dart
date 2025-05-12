enum FontFamily { poppins, scheherazade }

extension FontFamilyExtension on FontFamily {
  String get name {
    switch (this) {
      case FontFamily.poppins:
        return 'Poppins';
      case FontFamily.scheherazade:
        return 'ScheherazadeNew';
    }
  }
}

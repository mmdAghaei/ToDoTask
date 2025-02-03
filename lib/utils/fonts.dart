enum Fonts {
  HandWrite,
  Lato,
  Vazir,
  VazirMedium,
  VazirBold,
  VazirBlack,
  ExtraBold
}

extension AppFontsExtension on Fonts {
  String get fontFamily {
    switch (this) {
      case Fonts.HandWrite:
        return 'Hand';
      case Fonts.Vazir:
        return 'Vazir';
      case Fonts.VazirMedium:
        return 'VazirMedium';
      case Fonts.VazirBold:
        return 'VazirBold';
      case Fonts.VazirBlack:
        return 'VazirBlack';
      case Fonts.ExtraBold:
        return 'ExtraBold';
      default:
        return 'Lato';
    }
  }
}

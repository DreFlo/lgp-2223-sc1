enum Flavor {
  FREE,
  PREMIUM,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.FREE:
        return 'Wan-of-a-Kind (Free)';
      case Flavor.PREMIUM:
        return 'Wan-of-a-Kind';
      default:
        return 'title';
    }
  }

}

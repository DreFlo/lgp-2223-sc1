enum Flavor {
  free,
  premium,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.free:
        return 'Wan-of-a-Kind (Free)';
      case Flavor.premium:
        return 'Wan-of-a-Kind';
      default:
        return 'title';
    }
  }

}

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
        return 'Wokka (Free)';
      case Flavor.premium:
        return 'Wokka';
      default:
        return 'title';
    }
  }
}

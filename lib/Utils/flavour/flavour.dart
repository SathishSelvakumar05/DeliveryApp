// import 'Helper/ApiLinksV3.dart';

enum Flavor {
  sit,
  uat,
  prod,
  aykaProd
}


class FlavorConfig{
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.sit:
        return 'YAANTRAC SIT';
      case Flavor.uat:
        return 'YAANTRAC UAT';
      case Flavor.prod:
        return 'YAANTRAC';
      case Flavor.aykaProd:
        return 'AYKA';
      default:
        return 'title';
    }
  }
  static bool get isDevelopment {
    switch (appFlavor) {
      case Flavor.sit:
        return false;
      case Flavor.uat:
        return false;
      case Flavor.prod:
        return true;
      case Flavor.aykaProd:
        return true;
      default:
        return false;
    }
  }
  static bool get isYaantrac {
    switch (appFlavor) {
      case Flavor.sit:
        return true;
      case Flavor.uat:
        return true;
      case Flavor.prod:
        return true;
      case Flavor.aykaProd:
        return false;
      default:
        return true;
    }
  }

  // static String get baseURL {
  //   switch (appFlavor) {
  //     case Flavor.sit:
  //       return ApiLinks.yaantracSIT;
  //     case Flavor.uat:
  //       return ApiLinks.yaantracUAT;
  //     case Flavor.prod:
  //       return ApiLinks.yaantrac;
  //     case Flavor.aykaProd:
  //       return ApiLinks.yaantrac;
  //     default:
  //       return ApiLinks.yaantracSIT;
  //   }
  // }

  // static String get socketBaseURL {
  //   switch (appFlavor) {
  //     case Flavor.sit:
  //       return ApiLinks.webSocketSIT;
  //     case Flavor.uat:
  //       return ApiLinks.webSocketUAT;
  //     case Flavor.prod:
  //       return ApiLinks.webSocketProd;
  //     case Flavor.aykaProd:
  //       return ApiLinks.webSocketProd;
  //     default:
  //       return ApiLinks.webSocketSIT;
  //   }
  // }


}
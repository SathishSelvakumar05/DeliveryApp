import 'package:delivery_app/main.dart' as delivery_app;

import 'Utils/flavour/flavour.dart';
Future<void> main() async {
  FlavorConfig.appFlavor = Flavor.uat;
  delivery_app.main();
}
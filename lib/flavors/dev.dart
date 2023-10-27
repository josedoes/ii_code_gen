import 'package:ii_code_gen/main.dart' as app;

import 'prod.dart';

void main() async {
  print('Building dev');
  app.main([], Flavor.dev);
}

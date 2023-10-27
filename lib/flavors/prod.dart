import 'package:ii_code_gen/main.dart' as app;

void main() async {
  print('prod');
  app.main([], Flavor.prod);
}

enum Flavor {
  local_dev,
  dev,
  prod,
}

var flavour = Flavor.dev;

bool isDev() => flavour == Flavor.dev;

bool isProd() => flavour == Flavor.prod;

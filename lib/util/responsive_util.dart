import 'package:flutter/material.dart';

class ResponsiveUtil {
  static double responsiveDouble({
    required BuildContext context,
    required double mobile,
    required double tab,
    required double laptop,
    required double desktop,
  }) {
    final Size deviceSize = MediaQuery.of(context).size;
    if (deviceSize.width < 600) {
      return mobile;
    } else if (deviceSize.width > 600) {
      return tab;
    } else if (deviceSize.width > 1200) {
      return laptop;
    } else if (deviceSize.width > 1400) {
      return desktop;
    }

    return 0.0;
  }
}

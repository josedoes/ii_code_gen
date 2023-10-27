import 'package:flutter/cupertino.dart';

double boxSizeOffset = 20.0;

class HeadSpace extends StatelessWidget {
  final double? customOffset;
  const HeadSpace({
    super.key,
    this.customOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(height: 148 - (customOffset ?? boxSizeOffset));
  }
}

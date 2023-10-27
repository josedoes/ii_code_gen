import 'package:flutter/material.dart';

class TapClick extends StatelessWidget {
  const TapClick({required this.child, required this.onTap, super.key});

  final Widget child;
  final Function() onTap;


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

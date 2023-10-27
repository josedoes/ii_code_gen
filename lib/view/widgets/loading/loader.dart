import 'package:flutter/material.dart';
import '../../../ui/colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          colorPrimary,
        ),
      ),
    );
  }
}

class PageLoadingIndicator extends StatelessWidget {
  const PageLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: AppLoader());
  }
}

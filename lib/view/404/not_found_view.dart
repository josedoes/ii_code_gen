import 'package:flutter/material.dart';
import 'package:ii_code_gen/service/auth/auth_service.dart';
import 'package:ii_code_gen/service/navigation_service.dart';
import 'package:ii_code_gen/ui/styles.dart';

import '../../ui/colors.dart';
import '../widgets/base_button.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Headline1('404 Not found'),
            SizedBox(height: 16),
            BodyText1(
              'We are sorry we could not find the page you were looking for!',
            ),
            SizedBox(height: 32),
            BaseButton(
              buttonText: 'Move on',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

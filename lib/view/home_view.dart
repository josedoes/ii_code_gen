import 'package:flutter/material.dart';
import 'package:ii_code_gen/ui/styles.dart';
import 'package:ii_code_gen/ui/theme.dart';
import 'package:ii_code_gen/view/widgets/base_button.dart';
import 'package:stacked/stacked.dart';
import '../view_models/home_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel()..init(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeadSpace(),
              Headline1('Code Gen'),
              BodyText1('Select your root file'),
              SizedBox(height: 40),
              // BodyText2('${model.projectPath}'),
              // BaseButton(buttonText: model.pickPath)
            ],
          ),
        );
      },
    );
  }
}

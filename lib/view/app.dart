import 'package:flutter/material.dart';
import 'package:ii_code_gen/ui/colors.dart';
import 'package:ii_code_gen/ui/styles.dart';
import 'package:ii_code_gen/view/widgets/base_button.dart';
import 'package:ii_code_gen/view_models/app_view_model.dart';
import 'package:stacked/stacked.dart';

import '../service/navigation_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => appViewModel..init(),
      builder: (context, model, child) {
        return AppNotifications(
          loading: model.isBusy,
          child: MaterialApp.router(
            routerConfig: navigationService.router,
            debugShowCheckedModeBanner: false,
            title: 'Intelligent Iterations',
            theme: ThemeData(
              primaryColor: colorPrimary,
            ),
          ),
        );
      },
    );
  }
}

class AppNotifications extends ViewModelWidget<AppViewModel> {
  const AppNotifications({
    required this.child,
    required this.loading,
    super.key,
  });

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context, model) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          if (loading)
            const Positioned.fill(
              child: Material(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ii_code_gen/service/data_dog_service.dart';
import 'package:ii_code_gen/view/404/not_found_view.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';
import '../view/login/login_view.dart';
import 'auth/auth_service.dart';

NavigationService get navigationService => locate<NavigationService>();

void Function() onNavigationPush = () {};

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  NavigationService(this.datadogObserver) {
    router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      observers: [
        dataDogService.observer,
      ],
      errorPageBuilder: (_, state) =>
          const NoTransitionPage(child: NotFoundView()),
      redirect: (BuildContext context, GoRouterState state) {
        // if(!kDebugMode) {
        if (!firebaseAuthService.isSignedIn) {
          if (["/register", "/login"].contains(state.matchedLocation)) {
            return state.matchedLocation;
          } else {
            return loginRoute;
          }
        } else {
          return state.matchedLocation;
        }
        // }
      },
      routes: [
        GoRoute(
          path: loginRoute,
          name: 'login',
          builder: (_, __) {
            return LoginView();
          },
        ),
      ],
    );
  }

  final DatadogNavigationObserver datadogObserver;

  late GoRouter router;

  void pop() {
    onNavigationPush();
    router.pop();
  }

  void goRoute({required String route}) {
    navigationService.router.go(route);
  }

  bool isCurrent({required String route}) {
    return router.routeInformationProvider.value.uri.path == route;
  }

  void goToHome() {
    goRoute(route: homeRoute);
  }
}

const loginRoute = "/login";
const homeRoute = "/homeRoute";

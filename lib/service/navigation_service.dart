import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ii_code_gen/view/404/not_found_view.dart';
import 'package:ii_code_gen/view/project_view/project_view.dart';
import '../main.dart';
import '../view/home_view.dart';
import '../view/login/login_view.dart';

NavigationService get navigationService => locate<NavigationService>();

void Function() onNavigationPush = () {};

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  NavigationService() {
    router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      observers: [],
      initialLocation: '/',
      errorPageBuilder: (_, state) =>
          const NoTransitionPage(child: NotFoundView()),
      redirect: (BuildContext context, GoRouterState state) {},
      routes: [
        GoRoute(
          path: homeRoute,
          name: 'home',
          builder: (_, __) {
            return HomeView();
          },
        ),
        GoRoute(
          path: projectPath,
          name: 'project',
          builder: (_, __) {
            return ProjectView();
          },
        ),
        GoRoute(
          path: loginRoute,
          name: 'LoginView',
          builder: (_, __) {
            return LoginView();
          },
        ),
      ],
    );
  }

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

  void goToProject() {
    goRoute(route: projectPath);
  }
}

const loginRoute = "/";
const homeRoute = "/home";

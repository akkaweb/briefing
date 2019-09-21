import 'package:briefing/main.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/news_detail.dart';
import 'package:briefing/news_video_player.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routerName, {dynamic arguments}) {
    return navigationKey.currentState
        .pushNamed(routerName, arguments: arguments);
  }

  bool goBack() {
    return navigationKey.currentState.pop();
  }
}

class Router {
  static const String Home = "Home";
  static const String NewsDetail = "NewsDetail";
  static const String NewsVideoDetail = "NewsVideoDetail";
  static const String SetupCategory = "SetupCategory";
  static const String SetupPublisher = "SetupPublisher";
}

Route<dynamic> generateRouter(RouteSettings settings) {
  switch (settings.name) {
    case Router.Home:
      return MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Báo đây'));
    case Router.NewsDetail:
      var arguments = settings.arguments as ScreenArgument;
      return MaterialPageRoute(
          builder: (context) =>
              DetailPage(title: arguments.title, id: arguments.data));
    case Router.NewsVideoDetail:
      var arguments = settings.arguments as ScreenArgument;
      return TransparentRoute(
          builder: (context) => NewsVideoPlayer(arguments.data),
      settings: settings);
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: Center(
                  child: Text('Không tìm thấy trang ${settings.name}'),
                ),
              ));
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
            super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}
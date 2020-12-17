import 'package:flutter/material.dart';
import 'package:ai_radio/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:splashscreen/splashscreen.dart';

// ignore: must_be_immutable
class MySplashScreen extends StatefulWidget {
  Widget screen;
  MySplashScreen({@required this.screen});
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: splashScreenSeconds,
      title: appName,
      image: new Image.network(
          'https://flutter.io/images/catalog-widget-placeholder.png'),
      backgroundColor: primaryColorGreen,
      photoSize: photoSize,
      loaderColor: primaryColorBlue,
      pageRoute: _createRoute(screen: widget.screen),
    );
  }
}

Route _createRoute({@required Widget screen}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

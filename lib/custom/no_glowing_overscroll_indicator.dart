import 'package:flutter/material.dart';

class NoGlowingOverscrollIndicator extends StatelessWidget {
  final Widget child;
  NoGlowingOverscrollIndicator({@required this.child});
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: child,
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// class NoGlowingOverscrollIndicator extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }

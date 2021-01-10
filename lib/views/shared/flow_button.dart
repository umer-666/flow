// import 'package:flutter/material.dart';

// class FlowButton extends StatefulWidget {
//   final Widget title;
//   final VoidCallback onClick;
//   final Color color;
//   final Color splashColor;
//   final Color textColor;

//   FlowButton(
//       {@required this.onClick,
//       @required this.title,
//       this.color,
//       this.splashColor,
//       this.textColor});
//   @override
//   _FlowButtonState createState() => _FlowButtonState();
// }

// class _FlowButtonState extends State<FlowButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 32,
//       margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
//       child: FlatButton(
//         ///[ROUND CORNERS SHAPE]
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         //highlightColor: Colors.blue,
//         //hoverColor: Colors.pink,
//         //focusColor: Colors.blue,
//         color: widget.color ?? Colors.pink[400],
//         splashColor: widget.splashColor ?? Colors.pink[200],
//         textColor: widget.textColor ?? Colors.white,
//         onPressed: widget.onClick,
//         child: widget.title,
//       ),
//     );
//   }
// }

// FlowButton(
//   title: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text("Don't have an account? "),
//         Text("Sign up.",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//       ]),
//   onClick: () {
//     Get.to(SignUpScreen(), transition: Transition.cupertino);
//   },
//   color: Colors.transparent,
//   splashColor: Colors.white24,
// ),

// FlowButton(
//   title: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Already have an account? '),
//         Text("Log in.",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//       ]),
//   onClick: () {},
//   color: Colors.transparent,
//   splashColor: Colors.white24,
// ),

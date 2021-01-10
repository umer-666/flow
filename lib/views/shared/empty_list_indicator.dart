import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//ignore: must_be_immutable
class EmptyListIndicator extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  EmptyListIndicator(this.text, {this.fontSize, this.color});

  @override
  _EmptyListIndicatorState createState() => _EmptyListIndicatorState();
}

class _EmptyListIndicatorState extends State<EmptyListIndicator> {
  double opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 64, 8, 64),
        child: AnimatedOpacity(
          opacity: opacityLevel,
          duration: Duration(seconds: 2),
          child: Text(
            widget.text ?? 'LIST EMPTY',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                fontSize: widget.fontSize ?? 22,
                color: widget.color ?? Colors.grey[300]),
          ),
        ),
      ),
    );
  }
}

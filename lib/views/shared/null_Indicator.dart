import 'package:flutter/material.dart';

class NullIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

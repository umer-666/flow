import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final Function onClick;
  final double radius = 9;
  TagChip({@required this.title, this.onClick, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      //DISTANCE BWTWEEN EACH TAG
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
      //color: Colors.yellow,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700], width: 1.3),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(
              child: Padding(
                /// PADDING FOR TAG LABELS
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
          onTap: onClick,
        ),
      ),
    );
  }
}

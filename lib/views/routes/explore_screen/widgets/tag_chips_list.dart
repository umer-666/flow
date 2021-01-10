import 'package:flutter/material.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/explore_screen/widgets/tag_chip.dart';

class TagChipList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.purple,
      child: NoGlowingOverscrollIndicator(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          children: <Widget>[
            TagChip(
                title: "FlowTV",
                onClick: () {
                  print('FlowTV');
                }),
            TagChip(
                title: "People",
                onClick: () {
                  print('People');
                }),
            TagChip(title: "Activities"),
            TagChip(title: "Things"),
            TagChip(title: "Animals"),
            TagChip(title: "Plants"),
            TagChip(title: "Places"),
            TagChip(title: "AR"),
            TagChip(title: "Anime"),
          ],
        ),
      ),
    );
  }
}

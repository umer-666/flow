import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  ProfileButton(
      {@required this.title, @required this.count, @required this.onClick});

  final String title;
  //final List dataList;
  final VoidCallback onClick;
  final int count;

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        //color:Colors.amber,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        height: 90,
        width: 70,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.count.toString(),
                  // style: Theme.of(context).textTheme.headline6,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Text(widget.title, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

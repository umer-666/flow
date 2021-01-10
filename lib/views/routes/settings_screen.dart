import 'package:flutter/material.dart';

//ignore:must_be_immutable
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        ListTile(
            onTap: () {},
          
            leading: ClipOval(child: FlutterLogo()),
            title: Text('Setting', style: TextStyle(color: Colors.white)),
            subtitle: Text('user name', style: TextStyle(color: Colors.white)),
            trailing: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ))
      ]),
    );
  }
}

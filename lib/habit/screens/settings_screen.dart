import 'package:flutter/material.dart';
class SettingsScreen extends StatefulWidget{
  const SettingsScreen({super.key});
 @override
  State<SettingsScreen> createState() {
    return _SettingsScreen();    
  }
}

class _SettingsScreen extends State<SettingsScreen>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Center(child: Text('Hi'),),
  );
  }

}
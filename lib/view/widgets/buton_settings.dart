import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  IconButton(onPressed: (){}, icon: Icon(Icons.settings, color: const Color(0xFFEF9737),));
  }
}

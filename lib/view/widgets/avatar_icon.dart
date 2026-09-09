import 'package:flutter/material.dart';

class AvatarButton extends StatelessWidget {
  const AvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: CircleAvatar(
        radius: 30,
        child: Icon(Icons.person, size: 40),
      ),
    );
  }
}
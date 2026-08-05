import 'package:adota_facil/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String leadingName;

  const AppbarWidget({super.key, required this.leadingName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80, 
        leadingWidth: 130,
        backgroundColor: Colors.white,
        leading: Center(
          child: Text(
            leadingName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFEF9737),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/Parceiros.png", height: 70, width: 70),
          ],
        ),
        centerTitle: true,
        actions: [AvatarButton()],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

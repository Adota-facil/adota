import 'package:adota_facil/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String leadingName;
  final bool mostrarBotaoVoltar;

  const AppbarWidget({
    super.key,
    required this.leadingName,
    this.mostrarBotaoVoltar = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80,
        leadingWidth: mostrarBotaoVoltar ? 170 : 130,
        backgroundColor: Colors.white,
        leading: Center(
          child: mostrarBotaoVoltar
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFEF9737),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Flexible(
                      child: Text(
                        leadingName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF9737),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  leadingName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF9737),
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
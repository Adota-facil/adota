import 'package:adota_facil/view/widgets/avatar_icon.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String leadingName;

  const AppbarWidget({super.key, required this.leadingName});

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return AppBar(
      toolbarHeight: 80,
      leadingWidth: 140,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: canPop
          ? InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFFEF9737),
                      size: 38,
                    ),
                    Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF9737),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Text(
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
      actions: const [AvatarButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

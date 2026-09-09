import 'package:adota_facil/controllers/notificacao_controller.dart';
import 'package:adota_facil/view/widgets/avatar_icon.dart';
import 'package:adota_facil/view/widgets/notificacoes_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        actions: [
          Consumer<NotificacaoController>(
            builder: (context, notificacao, _) {
              final count = notificacao.naoLidas;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFFEF9737),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const NotificacoesSheet(),
                      );
                      notificacao.marcarComoLidas();
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints:
                            const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          AvatarButton(),
        ],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
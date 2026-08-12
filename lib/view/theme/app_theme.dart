import 'package:flutter/material.dart';

/// Estilos e decorações compartilhados dos formulários do app.
///
/// Antes, cada tela (ex: CadastroPetView) definia sua própria
/// `_estiloBorda()` e repetia as mesmas cores/paddings em vários lugares.
/// Centralizar aqui é manutenção preventiva: se um dia a identidade visual
/// mudar, é uma edição só, e não uma caça a cada tela do app.
class AppTheme {
  AppTheme._();

  static const Color corPrimaria = Colors.blue;
  static const Color corBordaPadrao = Color(0xFFE0E0E0);
  static const Color corFundoCampo = Color(0xFFFAFAFA);

  static const TextStyle rotuloCampo = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.black87,
  );

  static OutlineInputBorder bordaPadrao({Color? cor, double largura = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: cor ?? corBordaPadrao, width: largura),
    );
  }

  static InputDecoration decoracaoCampo({
    required String dica,
    IconData? icone,
  }) {
    return InputDecoration(
      hintText: dica,
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
      prefixIcon: icone != null ? Icon(icone, color: corPrimaria) : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: corFundoCampo,
      enabledBorder: bordaPadrao(),
      focusedBorder: bordaPadrao(cor: corPrimaria, largura: 1.5),
    );
  }
}
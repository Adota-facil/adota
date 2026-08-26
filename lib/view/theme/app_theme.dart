import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color corPrimaria = Colors.blue;
  static const Color corBordaPadrao = Color(0xFFE0E0E0);
  static const Color corFundoCampo = Color(0xFFFAFAFA);

  static const double espacamentoHorizontalCampo = 14;

  static const double espacamentoVerticalCampo = 12;

  static const double raioBorda = 8;

  static const double larguraBordaPadrao = 1.2;
  
  static const double larguraBordaFoco = 1.5;

  static const TextStyle rotuloCampo = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.black87,
  );

  static OutlineInputBorder bordaPadrao({Color? cor, double? largura}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(raioBorda),
      borderSide: BorderSide(
        color: cor ?? corBordaPadrao,
        width: largura ?? larguraBordaPadrao,
      ),
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: espacamentoHorizontalCampo,
        vertical: espacamentoVerticalCampo,
      ),
      filled: true,
      fillColor: corFundoCampo,
      enabledBorder: bordaPadrao(),
      focusedBorder: bordaPadrao(cor: corPrimaria, largura: larguraBordaFoco),
    );
  }
}

import 'package:adota_facil/view/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoTextoFormulario extends StatelessWidget {
  const CampoTextoFormulario({
    super.key,
    required this.label,
    required this.dica,
    required this.controller,
    this.icone,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final String dica;
  final TextEditingController controller;
  final IconData? icone;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.rotuloCampo),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator ?? _validarObrigatorio,
            decoration: AppTheme.decoracaoCampo(dica: dica, icone: icone),
          ),
        ],
      ),
    );
  }

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
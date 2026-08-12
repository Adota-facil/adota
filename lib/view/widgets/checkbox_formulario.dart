import 'package:adota_facil/view/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CheckboxFormulario extends StatelessWidget {
  const CheckboxFormulario({
    super.key,
    required this.label,
    required this.valorAtual,
    required this.onChanged,
  });

  final String label;
  final bool valorAtual;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: valorAtual,
            onChanged: onChanged,
            activeColor: AppTheme.corPrimaria,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: AppTheme.corBordaPadrao, width: 1.5),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
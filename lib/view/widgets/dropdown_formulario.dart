import 'package:adota_facil/view/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DropdownFormulario<T> extends StatelessWidget {
  const DropdownFormulario({
    super.key,
    required this.label,
    required this.itens,
    required this.onChanged,
    this.valorSelecionado,
    this.dica,
    this.icone,
  });

  final String label;
  final List<T> itens;
  final T? valorSelecionado;
  final ValueChanged<T?> onChanged;
  final String? dica;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.rotuloCampo),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: valorSelecionado,
            hint: dica != null
                ? Text(
                    dica!,
                    style: const TextStyle(color: Colors.black26, fontSize: 14),
                  )
                : null,
            decoration: InputDecoration(
              prefixIcon:
                  icone != null ? Icon(icone, color: AppTheme.corPrimaria) : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: AppTheme.corFundoCampo,
              enabledBorder: AppTheme.bordaPadrao(),
              focusedBorder:
                  AppTheme.bordaPadrao(cor: AppTheme.corPrimaria, largura: 1.5),
            ),
            items: itens
                .map((item) =>
                    DropdownMenuItem<T>(value: item, child: Text(item.toString())))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
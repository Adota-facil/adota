import 'dart:convert';
import 'package:flutter/material.dart';

/// Exibe a foto do pet, priorizando Base64 (salvo direto no Firestore).
/// Cai pra [fotoUrl] se não houver base64, e pro ícone padrão se não
/// houver nenhuma foto.
class PetImageWidget extends StatelessWidget {
  final String fotoBase64;
  final String fotoUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PetImageWidget({
    super.key,
    this.fotoBase64 = '',
    this.fotoUrl = '',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (fotoBase64.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(fotoBase64),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      } catch (_) {
        return _placeholder();
      }
    }

    if (fotoUrl.isNotEmpty) {
      return Image.network(
        fotoUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFD4CFCF),
      child: Icon(
        Icons.pets,
        size: (width ?? height ?? 80) / 2,
        color: const Color(0xFF7E7C79),
      ),
    );
  }
}
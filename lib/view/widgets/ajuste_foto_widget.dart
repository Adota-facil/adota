import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class AjusteFoto extends StatefulWidget {
  final Uint8List imageBytes;

  const AjusteFoto({super.key, required this.imageBytes});

  @override
  State<AjusteFoto> createState() => _AjusteFotoState();
}

class _AjusteFotoState extends State<AjusteFoto> {
  final CropController _cropController = CropController();
  bool _processando = false;

  Uint8List _otimizarImagem(Uint8List bytesOriginais) {
    try {
      final img.Image? imagemOriginal = img.decodeImage(bytesOriginais);
      if (imagemOriginal == null) return bytesOriginais;

      final img.Image imagemRedimensionada = img.copyResize(
        imagemOriginal,
        width: 600,
        height: 600,
        maintainAspect: true,
      );

      return Uint8List.fromList(
        img.encodeJpg(imagemRedimensionada, quality: 85),
      );
    } catch (e) {
      return bytesOriginais;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ajustar Imagem',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          if (_processando)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green, size: 28),
              onPressed: _processando
                  ? null
                  : () {
                      setState(() {
                        _processando = true;
                      });
                      _cropController.crop();
                    },
            ),
        ],
      ),
      body: SafeArea(
        child: Crop(
          image: widget.imageBytes,
          controller: _cropController,
          aspectRatio: 1 / 1,
          cornerDotBuilder: (size, edgeAlignment) =>
              const DotControl(color: Colors.green),
          baseColor: Colors.black,
          maskColor: Colors.black.withOpacity(0.7),
          onCropped: (CropResult result) async {
            if (!mounted) return;

            if (result is CropSuccess) {
              final bytesOtimizados = await Future.microtask(
                () => _otimizarImagem(result.croppedImage),
              );

              if (!mounted) return;
              Navigator.of(context).pop(bytesOtimizados);
            } else if (result is CropFailure) {
              setState(() {
                _processando = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Falha ao recortar a imagem.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

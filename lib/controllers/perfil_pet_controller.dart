import 'package:flutter/material.dart';
import 'package:adota_facil/models/pet_model.dart';

class PerfilPetController extends ChangeNotifier {
  final PetModel pet;

  PerfilPetController({required this.pet});

  int _fotoSelecionadaIndex = 0;
  int get fotoSelecionadaIndex => _fotoSelecionadaIndex;

  List<String> get galeriaFotos {
    return pet.fotosBase64.isNotEmpty ? pet.fotosBase64 : pet.fotos;
  }

  bool get usaBase64 => pet.fotosBase64.isNotEmpty;

  void selecionarFoto(int index) {
    if (index >= 0 && index < galeriaFotos.length) {
      _fotoSelecionadaIndex = index;
      notifyListeners();
    }
  }

  void entrarEmContato(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando contato sobre o(a) ${pet.nome}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:adota_facil/models/pet_model.dart';

class PerfilPetController extends ChangeNotifier {
  String nomeAnunciante = '';
  String? fotoAnunciante;
  bool carregandoAnunciante = true;

  int quantidadeAvaliacoes = 0;
  double mediaAvaliacao = 0.0;

  Future<void> carregarDadosAnunciante(PetModel pet) async {
    if (pet.usuarioNome.isNotEmpty) {
      nomeAnunciante = pet.usuarioNome;
    }

    if (pet.anuncianteId.isNotEmpty) {
      try {
        final docUsuario = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(pet.anuncianteId)
            .get();

        if (docUsuario.exists && docUsuario.data() != null) {
          final dados = docUsuario.data()!;
          if (nomeAnunciante.isEmpty ||
              nomeAnunciante == 'Protetor Independente') {
            nomeAnunciante =
                dados['nome'] ??
                dados['name'] ??
                dados['nomeCompleto'] ??
                'Protetor Independente';
          }
          fotoAnunciante = dados['fotoUrl'] ?? dados['fotoBase64'];
        }

        await _recalcularMediaAvaliacoes(pet.anuncianteId);
      } catch (e) {
        if (nomeAnunciante.isEmpty) {
          nomeAnunciante = 'Protetor Independente';
        }
      }
    } else {
      if (nomeAnunciante.isEmpty) {
        nomeAnunciante = 'Protetor Independente';
      }
    }

    carregandoAnunciante = false;
    notifyListeners();
  }

  Future<void> _recalcularMediaAvaliacoes(String anuncianteId) async {
    try {
      final snapshotAvaliacoes = await FirebaseFirestore.instance
          .collection('avaliacoes')
          .where('anuncianteId', isEqualTo: anuncianteId)
          .get();

      if (snapshotAvaliacoes.docs.isNotEmpty) {
        quantidadeAvaliacoes = snapshotAvaliacoes.docs.length;
        double somaNotas = 0.0;

        for (var doc in snapshotAvaliacoes.docs) {
          final nota = (doc.data()['nota'] ?? 0).toDouble();
          somaNotas += nota;
        }

        mediaAvaliacao = somaNotas / quantidadeAvaliacoes;
      } else {
        quantidadeAvaliacoes = 0;
        mediaAvaliacao = 0.0;
      }
    } catch (e) {
      quantidadeAvaliacoes = 0;
      mediaAvaliacao = 0.0;
    }
  }

  Future<bool> avaliarAnunciante({
    required String anuncianteId,
    required String avaliadorId,
    required double nota,
    required String comentario,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('avaliacoes').add({
        'anuncianteId': anuncianteId,
        'avaliadorId': avaliadorId,
        'nota': nota,
        'comentario': comentario,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      await _recalcularMediaAvaliacoes(anuncianteId);

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }
}

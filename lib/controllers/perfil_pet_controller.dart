import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:adota_facil/models/pet_model.dart';

class PerfilPetController extends ChangeNotifier {
  String nomeAnunciante = '';
  String? fotoAnunciante;
  bool carregandoAnunciante = true;

  // Variáveis para as avaliações
  int quantidadeAvaliacoes = 0;
  double mediaAvaliacao = 0.0;

  Future<void> carregarDadosAnunciante(PetModel pet) async {
    if (pet.usuarioNome.isNotEmpty) {
      nomeAnunciante = pet.usuarioNome;
    }

    if (pet.anuncianteId.isNotEmpty) {
      try {
        // 1. Busca dados do usuário (Nome e Foto caso venham vazios no pet)
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

        // 2. Busca as avaliações deste anunciante no Firestore
        final snapshotAvaliacoes = await FirebaseFirestore.instance
            .collection('avaliacoes')
            .where('anuncianteId', isEqualTo: pet.anuncianteId)
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

  // Função para enviar uma nova avaliação
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

      // Recarrega os dados para atualizar a média na tela na hora
      carregandoAnunciante = true;
      notifyListeners();

      // Simples objeto temporário apenas para atualizar a busca
      await carregarDadosAnunciante(
        PetModel(
          id: '',
          nome: '',
          especie: '',
          statusSaude: '',
          idade: '',
          porte: '',
          genero: '',
          anuncianteId: anuncianteId,
          usuarioNome: nomeAnunciante,
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adota_facil/models/solicitacao_adocao_model.dart';

abstract class SolicitacaoAdocaoRepository {
  Future<String> criarSolicitacao(SolicitacaoAdocaoModel solicitacao);
  Future<List<SolicitacaoAdocaoModel>> buscarPorAnunciante(String anuncianteId);
  Future<List<SolicitacaoAdocaoModel>> buscarPorAdotante(String adotanteId);
  Future<void> atualizarStatus(String solicitacaoId, StatusSolicitacao novoStatus);
}

class SolicitacaoAdocaoRepositoryImpl implements SolicitacaoAdocaoRepository {
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('solicitacoesAdocao');

  @override
  Future<String> criarSolicitacao(SolicitacaoAdocaoModel solicitacao) async {
    final doc = await _colecao.add(solicitacao.toMap());
    return doc.id;
  }

  @override
  Future<List<SolicitacaoAdocaoModel>> buscarPorAnunciante(
    String anuncianteId,
  ) async {
    final resultado = await _colecao
        .where('anuncianteId', isEqualTo: anuncianteId)
        .orderBy('criadoEm', descending: true)
        .get();
    return resultado.docs
        .map((doc) => SolicitacaoAdocaoModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<SolicitacaoAdocaoModel>> buscarPorAdotante(
    String adotanteId,
  ) async {
    final resultado = await _colecao
        .where('adotanteId', isEqualTo: adotanteId)
        .orderBy('criadoEm', descending: true)
        .get();
    return resultado.docs
        .map((doc) => SolicitacaoAdocaoModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> atualizarStatus(
    String solicitacaoId,
    StatusSolicitacao novoStatus,
  ) {
    return _colecao.doc(solicitacaoId).update({
      'status': novoStatus.name,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }
}
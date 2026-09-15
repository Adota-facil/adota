import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/controllers/meus_anuncios_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/models/repositories/animal_repository.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeusAnunciosView extends StatefulWidget {
  const MeusAnunciosView({super.key});

  @override
  State<MeusAnunciosView> createState() => _MeusAnunciosViewState();
}

class _MeusAnunciosViewState extends State<MeusAnunciosView> {
  late final MeusAnunciosController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MeusAnunciosController(
      context.read<AuthController>(),
      AnimalRepositoryImpl(),
    );
    _controller.addListener(_aoMudar);
  }

  void _aoMudar() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_aoMudar);
    super.dispose();
  }

  Future<void> _confirmarRemocao(PetModel pet) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover anúncio'),
        content: Text(
          'Remover "${pet.nome}" da lista? Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;

    final sucesso = await _controller.remover(pet.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(sucesso ? 'Anúncio removido.' : 'Não foi possível remover.'),
      ),
    );
  }

  Future<void> _alternarAdotado(PetModel pet) async {
    final sucesso = await _controller.alternarAdotado(pet);
    if (!mounted || sucesso) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Não foi possível atualizar.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF9737)),
        title: const Text(
          'Meus Anúncios',
          style: TextStyle(
            color: Color(0xFFEF9737),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_controller.carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller.erro != null) {
      return Center(child: Text(_controller.erro!));
    }
    if (_controller.pets.isEmpty) {
      return const Center(
        child: Text(
          'Você ainda não cadastrou nenhum pet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _controller.pets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pet = _controller.pets[index];
        return _CartaoAnuncio(
          pet: pet,
          onAlternarAdotado: () => _alternarAdotado(pet),
          onRemover: () => _confirmarRemocao(pet),
        );
      },
    );
  }
}

class _CartaoAnuncio extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onAlternarAdotado;
  final VoidCallback onRemover;

  const _CartaoAnuncio({
    required this.pet,
    required this.onAlternarAdotado,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: PetImageWidget(
              fotoBase64: pet.fotoBase64,
              fotoUrl: pet.fotoUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pet.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (pet.adotado)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Adotado',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pet.especie,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onAlternarAdotado,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(color: Color(0xFFEF9737)),
                        ),
                        child: Text(
                          pet.adotado ? 'Desmarcar adotado' : 'Marcar como adotado',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFEF9737),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onRemover,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
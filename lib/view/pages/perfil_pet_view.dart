import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/controllers/perfil_pet_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/pages/editar_pet_view.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/card_anunciante_widget.dart'; // <--- Importação necessária aqui
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilPetView extends StatelessWidget {
  final PetModel pet;

  const PerfilPetView({super.key, required this.pet});

  void _mostrarDialogAvaliacao(
    BuildContext context,
    PerfilPetController controller,
  ) {
    final usuarioAtualId = context.read<AuthController>().usuarioId;
    if (usuarioAtualId != null && usuarioAtualId == pet.anuncianteId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você não pode avaliar a si mesmo!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double notaSelecionada = 5.0;
    final comentarioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: const Text('Avaliar Protetor'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'O que você achou do atendimento deste anunciante?',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < notaSelecionada
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setStateModal(() {
                            notaSelecionada = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: comentarioController,
                    decoration: const InputDecoration(
                      labelText: 'Comentário (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    final sucesso = await controller.avaliarAnunciante(
                      anuncianteId: pet.anuncianteId,
                      avaliadorId: usuarioAtualId ?? 'anônimo',
                      nota: notaSelecionada,
                      comentario: comentarioController.text.trim(),
                    );

                    if (!context.mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sucesso
                              ? 'Avaliação enviada com sucesso!'
                              : 'Erro ao enviar avaliação.',
                        ),
                        backgroundColor: sucesso ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  child: const Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioAtualId = context.watch<AuthController>().usuarioId;
    final bool eDonoDoPet =
        usuarioAtualId != null &&
        usuarioAtualId.isNotEmpty &&
        usuarioAtualId == pet.anuncianteId;

    return ChangeNotifierProvider(
      create: (_) => PerfilPetController()..carregarDadosAnunciante(pet),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarWidget(leadingName: pet.nome, mostrarBotaoVoltar: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eDonoDoPet)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarPetView(pet: pet),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1976D2),
                        side: const BorderSide(color: Color(0xFF1976D2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text(
                        'Editar informações do pet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: PetImageWidget(
                      fotoBase64: pet.fotoBase64,
                      fotoUrl: pet.fotoUrl,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              pet.nome,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(pet.iconeGenero, color: pet.corGenero),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (pet.tagsSaude.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: pet.tagsSaude.map((tag) {
                              return Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Color(0xFFA45600),
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFFDE8E4),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          'Espécie: ${pet.especie}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Idade: ${pet.idade}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Porte: ${pet.porte}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Raça: ${pet.raca.isNotEmpty ? pet.raca : "-"}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Localização: ${pet.localizacao.isNotEmpty ? pet.localizacao : "-"}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGaleriaFotos(pet),
              const Text(
                'Descrição',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                pet.descricao.isNotEmpty
                    ? pet.descricao
                    : 'Sem descrição informada.',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              Consumer<PerfilPetController>(
                builder: (context, controller, child) {
                  return CardAnuncianteWidget(
                    nomeAnunciante: controller.carregandoAnunciante
                        ? 'Carregando...'
                        : controller.nomeAnunciante,
                    localizacao: pet.localizacao,
                    fotoPerfilUrl: controller.fotoAnunciante,
                    quantidadeAvaliacoes: controller.quantidadeAvaliacoes,
                    mediaAvaliacao: controller.mediaAvaliacao,
                    eDonoDoPet: eDonoDoPet,
                    onAvaliarTapped: () =>
                        _mostrarDialogAvaliacao(context, controller),
                    onContatoPressed: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaleriaFotos(PetModel pet) {
    final galeria = pet.fotosBase64.isNotEmpty ? pet.fotosBase64 : pet.fotos;
    final usaBase64 = pet.fotosBase64.isNotEmpty;

    if (galeria.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: galeria.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: PetImageWidget(
                  fotoBase64: usaBase64 ? galeria[index] : '',
                  fotoUrl: usaBase64 ? '' : galeria[index],
                  width: 80,
                  height: 80,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/controllers/perfil_pet_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
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
                    final usuarioId =
                        context.read<AuthController>().usuarioId ?? 'anônimo';

                    final sucesso = await controller.avaliarAnunciante(
                      anuncianteId: pet.anuncianteId,
                      avaliadorId: usuarioId,
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
                  return _CardAnunciante(
                    nomeAnunciante: controller.carregandoAnunciante
                        ? 'Carregando...'
                        : controller.nomeAnunciante,
                    localizacao: pet.localizacao,
                    fotoPerfilUrl: controller.fotoAnunciante,
                    quantidadeAvaliacoes: controller.quantidadeAvaliacoes,
                    mediaAvaliacao: controller.mediaAvaliacao,
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

class _CardAnunciante extends StatelessWidget {
  final String nomeAnunciante;
  final String localizacao;
  final String? fotoPerfilUrl;
  final int quantidadeAvaliacoes;
  final double mediaAvaliacao;
  final VoidCallback onAvaliarTapped;
  final VoidCallback onContatoPressed;

  const _CardAnunciante({
    required this.nomeAnunciante,
    required this.localizacao,
    this.fotoPerfilUrl,
    required this.quantidadeAvaliacoes,
    required this.mediaAvaliacao,
    required this.onAvaliarTapped,
    required this.onContatoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESPONSÁVEL PELO PET',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE65100),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sobre o anunciante',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (fotoPerfilUrl != null && fotoPerfilUrl!.isNotEmpty)
                    ? NetworkImage(fotoPerfilUrl!)
                    : null,
                child: (fotoPerfilUrl == null || fotoPerfilUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.grey, size: 32)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomeAnunciante,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Protetor independente',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            localizacao.isNotEmpty
                                ? localizacao
                                : 'Localização informada',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    InkWell(
                      onTap: onAvaliarTapped,
                      child: Row(
                        children: [
                          if (quantidadeAvaliacoes > 0) ...[
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < mediaAvaliacao.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 14,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${mediaAvaliacao.toStringAsFixed(1)} ($quantidadeAvaliacoes ${quantidadeAvaliacoes == 1 ? 'avaliação' : 'avaliações'})',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: List.generate(
                                5,
                                (_) => const Icon(
                                  Icons.star_border,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Toque para avaliar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Converse pelo WhatsApp e confirme todas as informações antes de combinar a adoção.',
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tem interesse neste pet?',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              ElevatedButton.icon(
                onPressed: onContatoPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                label: const Text(
                  'Entrar em contato',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

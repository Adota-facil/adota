import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilPetView extends StatefulWidget {
  final PetModel pet;

  const PerfilPetView({super.key, required this.pet});

  @override
  State<PerfilPetView> createState() => _PerfilPetViewState();
}

class _PerfilPetViewState extends State<PerfilPetView> {
  bool _carregandoContato = false;

  // Função para buscar o telefone do anunciante no Firestore e abrir o WhatsApp
  Future<void> _falarComAnunciante() async {
    setState(() => _carregandoContato = true);

    try {
      String? telefone;

      // Busca os dados do anunciante na coleção 'usuarios' usando o anuncianteId do pet
      if (widget.pet.anuncianteId.isNotEmpty) {
        final docUsuario = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(widget.pet.anuncianteId)
            .get();

        if (docUsuario.exists) {
          final dados = docUsuario.data();
          telefone = dados?['telefone'] as String?;
        }
      }

      // Limpa caracteres especiais e obtém apenas os dígitos
      String numeroLimpo = telefone?.replaceAll(RegExp(r'\D'), '') ?? '';

      // Adiciona o DDI do Brasil (55) automaticamente caso o usuário não tenha colocado
      if (numeroLimpo.isNotEmpty && !numeroLimpo.startsWith('55')) {
        numeroLimpo = '55$numeroLimpo';
      }

      if (!mounted) return;

      if (numeroLimpo.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Este anunciante não cadastrou um número de telefone.',
            ),
          ),
        );
        return;
      }

      const mensagem =
          'Olá! Vi o anúncio do pet no Adota Fácil e tenho interesse em saber mais.';
      final Uri url = Uri.parse(
        'https://wa.me/$numeroLimpo?text=${Uri.encodeComponent(mensagem)}',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Erro ao abrir o WhatsApp: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregandoContato = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: pet.nome, mostrarBotaoVoltar: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil Principal (Foto + Informações lado a lado)
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

            // Galeria de fotos adicionais
            Builder(
              builder: (context) {
                final galeria = pet.fotosBase64.isNotEmpty
                    ? pet.fotosBase64
                    : pet.fotos;
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
              },
            ),

            // Seção de Descrição
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

            // Card do Anunciante
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Anunciador',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anunciante',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Protetor Independente',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Botão de Contato com indicador de carregamento
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _carregandoContato
                          ? null
                          : _falarComAnunciante,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _carregandoContato
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Entrar em contato',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

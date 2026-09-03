import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:flutter/material.dart';

class PerfilPetView extends StatefulWidget {
  final PetModel pet;

  const PerfilPetView({super.key, required this.pet});

  @override
  State<PerfilPetView> createState() => _PerfilPetViewState();
}

class _PerfilPetViewState extends State<PerfilPetView> {

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: pet.nome, mostrarBotaoVoltar: true),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil Principal (Foto + Informações lado a lado)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Principal com cantos arredondados e tratamento de erro
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
                // Detalhes textuais
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome e ícone de gênero
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
                      // Tags de status (a partir de statusSaude, ex: "Castrado, Vacinado")
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
                      // Dados específicos do animal
                      Text('Espécie: ${pet.especie}',
                          style: const TextStyle(fontSize: 15)),
                      Text('Idade: ${pet.idade}',
                          style: const TextStyle(fontSize: 15)),
                      Text('Porte: ${pet.porte}',
                          style: const TextStyle(fontSize: 15)),
                      Text('Raça: ${pet.raca.isNotEmpty ? pet.raca : "-"}',
                          style: const TextStyle(fontSize: 15)),
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

            // Galeria de fotos adicionais (se houver)
            Builder(builder: (context) {
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
            }),

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
            // TODO: dados fixos até existir um model de usuário/anunciante ligado ao pet.
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
                  // Botão de Contato alinhado à direita
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
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
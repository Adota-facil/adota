import 'package:adota_facil/controllers/notificacao_controller.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificacoesSheet extends StatelessWidget {
  const NotificacoesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final notificacao = context.watch<NotificacaoController>();
    final itens = notificacao.notificacoes;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Notificações',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: NotificacaoController.categoriasDisponiveis.map((categoria) {
                  final selecionado = notificacao.categoriasFiltro.contains(categoria);
                  return FilterChip(
                    label: Text(categoria),
                    selected: selecionado,
                    onSelected: (_) => notificacao.alternarCategoria(categoria),
                    selectedColor: const Color(0xFFEF9737).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xFFEF9737),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child: itens.isEmpty
                  ? const Center(child: Text('Nenhuma notificação por aqui.'))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: itens.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final pet = itens[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipOval(
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: PetImageWidget(
                                fotoBase64: pet.fotoBase64,
                                fotoUrl: pet.fotoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(pet.nome),
                          subtitle:
                              Text('Novo ${pet.especie.toLowerCase()} disponível para adoção'),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
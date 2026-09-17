import 'package:flutter/material.dart';

class CardAnuncianteWidget extends StatelessWidget {
  final String nomeAnunciante;
  final String localizacao;
  final String? fotoPerfilUrl;
  final int quantidadeAvaliacoes;
  final double mediaAvaliacao;
  final bool eDonoDoPet; // <--- NOVO PARÂMETRO
  final VoidCallback onAvaliarTapped;
  final VoidCallback onContatoPressed;

  const CardAnuncianteWidget({
    super.key,
    required this.nomeAnunciante,
    required this.localizacao,
    this.fotoPerfilUrl,
    required this.quantidadeAvaliacoes,
    required this.mediaAvaliacao,
    required this.eDonoDoPet, // <--- NOVO PARÂMETRO
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE65100),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sobre o anunciante',
            style: TextStyle(
              fontSize: 15,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nomeAnunciante,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          mediaAvaliacao > 0
                              ? mediaAvaliacao.toStringAsFixed(1)
                              : '0.0',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' ($quantidadeAvaliacoes)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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

                    // SÓ EXIBE O BOTÃO SE NÃO FOR O DONO DO PET
                    if (!eDonoDoPet) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 34,
                        child: OutlinedButton.icon(
                          onPressed: onAvaliarTapped,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber.shade900,
                            side: BorderSide(color: Colors.amber.shade400),
                            backgroundColor: Colors.amber.shade50.withOpacity(
                              0.5,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                          label: const Text(
                            'Avaliar este anunciante',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!eDonoDoPet) ...[
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
        ],
      ),
    );
  }
}

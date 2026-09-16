import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CuriosidadesView extends StatefulWidget {
  const CuriosidadesView({super.key});

  @override
  State<CuriosidadesView> createState() => _CuriosidadesViewState();
}

class _CuriosidadesViewState extends State<CuriosidadesView> {
  Map<String, dynamic>? _raca;
  String? _imagem;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _buscarRaca();
  }

  Future<void> _buscarRaca() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://pro-api.thedogapi.com/v1/images/search'
          '?size=med'
          '&mime_types=jpg'
          '&format=json'
          '&has_breeds=true'
          '&order=RANDOM'
          '&limit=1',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'DEMO-API-KEY',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.body}',
        );
      }

      final List<dynamic> dados = jsonDecode(response.body);

      if (dados.isEmpty) {
        throw Exception('Nenhum cachorro encontrado.');
      }

      final cachorro = Map<String, dynamic>.from(dados.first);

      final breeds = cachorro['breeds'] as List<dynamic>?;

      if (breeds == null || breeds.isEmpty) {
        throw Exception(
          'A API não retornou informações da raça.',
        );
      }

      final raca = Map<String, dynamic>.from(
        breeds.first,
      );

      if (!mounted) return;

      setState(() {
        _raca = raca;
        _imagem = cachorro['url']?.toString();
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao consultar a API:\n$e';
        _carregando = false;
      });
    }
  }

  String _texto(dynamic valor) {
    if (valor == null || valor.toString().trim().isEmpty) {
      return 'Não informado';
    }

    return valor.toString();
  }

  String _traduzirTemperamento(String texto) {
    final traducoes = {
      'Affectionate': 'Afetuoso',
      'Alert': 'Atento',
      'Aloof': 'Reservado',
      'Assertive': 'Assertivo',
      'Athletic': 'Atlético',
      'Calm': 'Calmo',
      'Companionable': 'Companheiro',
      'Confident': 'Confiante',
      'Curious': 'Curioso',
      'Docile': 'Dócil',
      'Energetic': 'Energético',
      'Even Tempered': 'Equilibrado',
      'Friendly': 'Amigável',
      'Gentle': 'Gentil',
      'Happy': 'Feliz',
      'Independent': 'Independente',
      'Intelligent': 'Inteligente',
      'Loyal': 'Leal',
      'Loving': 'Carinhoso',
      'Obedient': 'Obediente',
      'Outgoing': 'Sociável',
      'Playful': 'Brincalhão',
      'Protective': 'Protetor',
      'Quick': 'Rápido',
      'Quiet': 'Tranquilo',
      'Reliable': 'Confiável',
      'Reserved': 'Reservado',
      'Responsive': 'Atento',
      'Self-confident': 'Autoconfiante',
      'Sociable': 'Sociável',
      'Stable': 'Estável',
      'Sweet-Tempered': 'Dócil',
      'Trainable': 'Fácil de treinar',
      'Trusting': 'Confiável',
      'Watchful': 'Vigilante',
      'Strong Willed': 'Determinado',
      'Stubborn': 'Teimoso',
      'Protective': 'Protetor',
      'Sensitive': 'Sensível',
      'Patient': 'Paciente',
      'Fearless': 'Destemido',
      'Hardy': 'Resistente',
      'Serious': 'Sério',
      'Aggressive': 'Agressivo',
      'Reserved with Strangers': 'Reservado com estranhos',
      'Good-natured': 'Bem-humorado',
      'Kind': 'Gentil',
      'Dignified': 'Digno',
      'Clever': 'Esperto',
      'Devoted': 'Dedicado',
      'Easygoing': 'Tranquilo',
      'Extroverted': 'Extrovertido',
      'Fun-loving': 'Divertido',
      'Laid-back': 'Descontraído',
      'People-Oriented': 'Voltado para pessoas',
      'Strong': 'Forte',
      'Vigilant': 'Vigilante',
      'Territorial': 'Territorial',
      'Protective': 'Protetor',
    };

    String resultado = texto;

    traducoes.forEach((ingles, portugues) {
      resultado = resultado.replaceAll(
        RegExp(
          '\\b${RegExp.escape(ingles)}\\b',
          caseSensitive: false,
        ),
        portugues,
      );
    });

    return resultado;
  }

  String _traduzirOrigem(String texto) {
    final traducoes = {
      'United States': 'Estados Unidos',
      'United Kingdom': 'Reino Unido',
      'England': 'Inglaterra',
      'Scotland': 'Escócia',
      'Wales': 'País de Gales',
      'Ireland': 'Irlanda',
      'Germany': 'Alemanha',
      'France': 'França',
      'Italy': 'Itália',
      'Spain': 'Espanha',
      'Portugal': 'Portugal',
      'Belgium': 'Bélgica',
      'Netherlands': 'Países Baixos',
      'Switzerland': 'Suíça',
      'Austria': 'Áustria',
      'Russia': 'Rússia',
      'China': 'China',
      'Japan': 'Japão',
      'Korea': 'Coreia',
      'Canada': 'Canadá',
      'Mexico': 'México',
      'Brazil': 'Brasil',
      'Australia': 'Austrália',
      'Hungary': 'Hungria',
      'Poland': 'Polônia',
      'Denmark': 'Dinamarca',
      'Norway': 'Noruega',
      'Sweden': 'Suécia',
      'Finland': 'Finlândia',
      'Turkey': 'Turquia',
      'India': 'Índia',
      'Afghanistan': 'Afeganistão',
      'Egypt': 'Egito',
      'South Africa': 'África do Sul',
      'Central Africa': 'África Central',
      'Tibet': 'Tibete',
      'Scandinavia': 'Escandinávia',
      'Mediterranean': 'Mediterrâneo',
    };

    String resultado = texto;

    traducoes.forEach((ingles, portugues) {
      resultado = resultado.replaceAll(
        RegExp(
          '\\b${RegExp.escape(ingles)}\\b',
          caseSensitive: false,
        ),
        portugues,
      );
    });

    return resultado;
  }

  String _traduzirExpectativa(String texto) {
    return texto
        .replaceAll(
          RegExp(r'\byears?\b', caseSensitive: false),
          'anos',
        )
        .replaceAll(
          RegExp(r'\byear\b', caseSensitive: false),
          'ano',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Curiosidades do Mundo Pet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Conheça diferentes raças de cães através da The Dog API.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _construirConteudo(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _carregando
                      ? null
                      : _buscarRaca,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text(
                        'Próxima Curiosidade',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirConteudo() {
    if (_carregando) {
      return Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    if (_erro != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              _erro!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarRaca,
              child: const Text(
                'Tentar novamente',
              ),
            ),
          ],
        ),
      );
    }

    if (_raca == null) {
      return const Center(
        child: Text(
          'Nenhuma raça encontrada.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    final nome = _texto(_raca!['name']);

    final origem = _traduzirOrigem(
      _texto(_raca!['origin']),
    );

    final temperamento = _traduzirTemperamento(
      _texto(_raca!['temperament']),
    );

    final expectativa = _traduzirExpectativa(
      _texto(_raca!['life_span']),
    );

    String peso = 'Não informado';

    if (_raca!['weight'] != null) {
      final weight = Map<String, dynamic>.from(
        _raca!['weight'],
      );

      peso = _texto(weight['metric']);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_imagem != null)
            Image.network(
              _imagem!,
              width: double.infinity,
              height: 230,
              fit: BoxFit.cover,
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  height: 230,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
              },
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  height: 230,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.pets,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pets,
                      color: Colors.orange,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Origem: $origem',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                const Divider(
                  height: 24,
                  color: Color(0xFFE0E0E0),
                ),
                const Text(
                  'Temperamento',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  temperamento,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.favorite_outline,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Expectativa de vida: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        expectativa,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.monitor_weight_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Peso: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$peso kg',
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
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
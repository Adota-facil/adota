import 'package:flutter/material.dart';

class CuriosidadesView extends StatefulWidget {
  const CuriosidadesView({super.key});

  @override
  State<CuriosidadesView> createState() => _CuriosidadesViewState();
}

class _CuriosidadesViewState extends State<CuriosidadesView> {
  late Future<Map<String, String>> _dadosApi;

  // Método simulando a chamada futura para a API de raças
  Future<Map<String, String>> _buscarCuriosidadeDaApi() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula o tempo de espera da rede
    return {
      'raca': 'Pinscher',
      'origem': 'Alemanha',
      'curiosidade': 'Apesar do tamanho pequeno, os Pinschers são extremamente corajosos, ótimos cães de guarda e possuem uma energia incansável. Eles são muito apegados aos seus tutores!',
    };
  }

  @override
  void initState() {
    super.initState();
    _dadosApi = _buscarCuriosidadeDaApi();
  }

  OutlineInputBorder estiloBorda() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curiosidades do Mundo Pet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Aprenda fatos interessantes sobre diferentes raças de animais:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            FutureBuilder<Map<String, String>>(
              future: _dadosApi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                    ),
                    child: const Center(
                      child: Text(
                        'Erro ao carregar informações da API.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final dados = snapshot.data!;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stars, color: Colors.orange, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            dados['raca']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Origem: ${dados['origem']!}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      const Divider(height: 24, color: Color(0xFFE0E0E0)),
                      Text(
                        dados['curiosidade']!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    _dadosApi = _buscarCuriosidadeDaApi();
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text(
                      'Próxima Curiosidade',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

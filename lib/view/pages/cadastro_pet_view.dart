import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class CadastroPetView extends StatefulWidget {
  const CadastroPetView({super.key});

  @override
  State<CadastroPetView> createState() => _CadastroPetViewState();
}

class _CadastroPetViewState extends State<CadastroPetView> {
  final _formKey = GlobalKey<FormState>();
  bool isCastrado = true;
  bool isVacinado = true;
  String? especieSelecionada;

  final List<String> especies = ['Cachorro', 'Gato', 'Pássaro', 'Outros'];

  OutlineInputBorder _estiloBorda() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
    );
  }

  Widget _construirCampo({
    required String label,
    required String dica,
    IconData? icone,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: dica,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
              prefixIcon: icone != null
                  ? Icon(icone, color: Colors.blue)
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: _estiloBorda(),
              focusedBorder: _estiloBorda().copyWith(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirDropdownEspecie() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Espécie*',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: especieSelecionada,
            hint: const Text(
              'Selecione a espécie',
              style: TextStyle(color: Colors.black26, fontSize: 14),
            ),
            decoration: InputDecoration(
              
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: _estiloBorda(),
              focusedBorder: _estiloBorda().copyWith(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
            items: especies.map((String especie) {
              return DropdownMenuItem<String>(
                value: especie,
                child: Text(especie),
              );
            }).toList(),
            onChanged: (String? novoValor) {
              setState(() {
                especieSelecionada = novoValor;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _construirCheckboxCadastro({
    required String label,
    required bool valorAtual,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: valorAtual,
            onChanged: onChanged,
            activeColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: "Bem vindo! \n Eduardo"),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Novo Pet para Adoção',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Insira as informações e características do bichinho:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _construirCampo(
                label: 'Nome do Pet*',
                dica: 'Ex: Bica',
                icone: Icons.pets,
              ),
              _construirDropdownEspecie(),
              _construirCampo(label: 'Raça*', dica: 'Ex: Pinscher, SRD, Persa'),
              Row(
                children: [
                  Expanded(
                    child: _construirCampo(label: 'Idade*', dica: 'Ex: 9 anos'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
                      label: 'Porte*',
                      dica: 'Ex: Pequeno',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _construirCampo(label: 'Cidade*', dica: 'Ex: Garanhuns'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
                      label: 'Estado*',
                      dica: 'Ex: Pernambuco',
                    ),
                  ),
                ],
              ),
              const Text(
                'Condições de Saúde*',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _construirCheckboxCadastro(
                    label: 'O pet é castrado',
                    valorAtual: isCastrado,
                    onChanged: (bool? value) {
                      setState(() {
                        isCastrado = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _construirCheckboxCadastro(
                    label: 'O pet está vacinado',
                    valorAtual: isVacinado,
                    onChanged: (bool? value) {
                      setState(() {
                        isVacinado = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _construirCampo(
                label: 'Descrição*',
                dica:
                    'Conte um pouco sobre a personalidade e história do pet...',
                maxLines: 4,
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
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: const Text(
                    'Salvar Pet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:adota_facil/controllers/cadastro_pet_controller.dart';
import 'package:adota_facil/models/animal_model.dart';
import 'package:adota_facil/view/constants/pet_constantes.dart';
import 'package:adota_facil/view/theme/app_theme.dart';
import 'package:adota_facil/view/widgets/campo_texto_formulario.dart';
import 'package:adota_facil/view/widgets/checkbox_formulario.dart';
import 'package:adota_facil/view/widgets/dropdown_formulario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String generoSelecionado = 'Macho';

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _porteController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _porteController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  List<String? Function()> get _validacoesExtras => [
        () => especieSelecionada == null ? 'Selecione a espécie do pet' : null,
      ];

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    for (final validar in _validacoesExtras) {
      final erro = validar();
      if (erro != null) {
        _mostrarErro(erro);
        return;
      }
    }

    final statusSaude = PetModel.montarStatusSaude(
      castrado: isCastrado,
      vacinado: isVacinado,
    );

    final novoPet = PetModel(
      id: '',
      nome: _nomeController.text.trim(),
      especie: especieSelecionada!,
      statusSaude: statusSaude,
      idade: _idadeController.text.trim(),
      porte: _porteController.text.trim(),
      genero: generoSelecionado,
      raca: _racaController.text.trim(),
      descricao: _descricaoController.text.trim(),
      localizacao:
          '${_cidadeController.text.trim()}, ${_estadoController.text.trim()}',
    );

    final controller = context.read<CadastroPetController>();
    final sucesso = await controller.cadastrarAnimal(novoPet);

    if (!mounted) return;

    if (sucesso) {
      _mostrarSucesso('Pet cadastrado com sucesso!');
      _resetarFormulario();
    } else {
      _mostrarErro(controller.erro ?? 'Erro ao cadastrar pet');
    }
  }

  void _resetarFormulario() {
    _formKey.currentState!.reset();
    _nomeController.clear();
    _racaController.clear();
    _idadeController.clear();
    _porteController.clear();
    _cidadeController.clear();
    _estadoController.clear();
    _descricaoController.clear();
    setState(() {
      especieSelecionada = null;
      isCastrado = true;
      isVacinado = true;
    });
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Widget _construirGradeFotosExemplo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fotos do Pet*', style: AppTheme.rotuloCampo),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.corBordaPadrao, width: 1.2),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.pets, color: Colors.black12, size: 64),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Foto Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 3 ? 12.0 : 0.0),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: AppTheme.corFundoCampo,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.corBordaPadrao,
                          width: 1.2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: AppTheme.corPrimaria,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salvando = context.watch<CadastroPetController>().salvando;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                  color: AppTheme.corPrimaria,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Insira as informações e características do bichinho:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              CampoTextoFormulario(
                label: 'Nome do Pet*',
                dica: 'Ex: Bica',
                controller: _nomeController,
                icone: Icons.pets,
              ),
              DropdownFormulario<String>(
                label: 'Espécie*',
                dica: 'Selecione a espécie',
                icone: Icons.category,
                itens: PetConstantes.especies,
                valorSelecionado: especieSelecionada,
                onChanged: (valor) =>
                    setState(() => especieSelecionada = valor),
              ),
              DropdownFormulario<String>(
                label: 'Gênero*',
                icone: Icons.wc,
                itens: PetConstantes.generos,
                valorSelecionado: generoSelecionado,
                onChanged: (valor) =>
                    setState(() => generoSelecionado = valor ?? 'Macho'),
              ),
              CampoTextoFormulario(
                label: 'Raça*',
                dica: 'Ex: Pinscher, SRD, Persa',
                controller: _racaController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CampoTextoFormulario(
                      label: 'Idade*',
                      dica: 'Ex: 9 anos',
                      controller: _idadeController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CampoTextoFormulario(
                      label: 'Porte*',
                      dica: 'Ex: Pequeno',
                      controller: _porteController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CampoTextoFormulario(
                      label: 'Cidade*',
                      dica: 'Ex: Garanhuns',
                      controller: _cidadeController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CampoTextoFormulario(
                      label: 'Estado*',
                      dica: 'Ex: Pernambuco',
                      controller: _estadoController,
                    ),
                  ),
                ],
              ),
              const Text('Condições de Saúde*', style: AppTheme.rotuloCampo),
              const SizedBox(height: 12),
              Column(
                children: [
                  CheckboxFormulario(
                    label: 'O pet é castrado',
                    valorAtual: isCastrado,
                    onChanged: (value) =>
                        setState(() => isCastrado = value ?? false),
                  ),
                  const SizedBox(height: 12),
                  CheckboxFormulario(
                    label: 'O pet está vacinado',
                    valorAtual: isVacinado,
                    onChanged: (value) =>
                        setState(() => isVacinado = value ?? false),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CampoTextoFormulario(
                label: 'Descrição*',
                dica:
                    'Conte um pouco sobre a personalidade e história do pet...',
                controller: _descricaoController,
                maxLines: 4,
              ),
              _construirGradeFotosExemplo(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.corPrimaria,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: salvando ? null : _salvarPet,
                  child: salvando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Salvar Pet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
import 'dart:convert';
import 'dart:typed_data';

import 'package:adota_facil/controller/home_controller.dart';
import 'package:adota_facil/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  bool _enviando = false;

  final List<String> especies = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Outros',
  ];

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _porteController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _descricaoController = TextEditingController();

  final _picker = ImagePicker();

  Uint8List? _fotoPrincipal;

  final List<Uint8List?> _fotosAdicionais =
      List<Uint8List?>.filled(4, null);

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

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  Future<void> _selecionarFotoPrincipal() async {
    try {
      final imagem = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      if (bytes.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A imagem selecionada está vazia.'),
          ),
        );

        return;
      }

      setState(() {
        _fotoPrincipal = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar a foto: $e'),
        ),
      );
    }
  }

  Future<void> _selecionarFotoAdicional(int index) async {
    try {
      final imagem = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      if (bytes.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A imagem selecionada está vazia.'),
          ),
        );

        return;
      }

      setState(() {
        _fotosAdicionais[index] = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar a foto: $e'),
        ),
      );
    }
  }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    if (especieSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a espécie do pet'),
        ),
      );

      return;
    }

    if (_fotoPrincipal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a foto principal do pet'),
        ),
      );

      return;
    }

    setState(() {
      _enviando = true;
    });

    final controller = context.read<HomeController>();

    try {
      final id = controller.gerarNovoId();

      final fotoBase64 = base64Encode(_fotoPrincipal!);

      final fotosBase64 = <String>[];

      for (final foto in _fotosAdicionais) {
        if (foto != null) {
          fotosBase64.add(base64Encode(foto));
        }
      }

      final tamanhoAproximado =
          fotoBase64.length +
          fotosBase64.fold<int>(
            0,
            (soma, f) => soma + f.length,
          );

      if (tamanhoAproximado > 900000) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'As fotos selecionadas são grandes demais. '
              'Escolha imagens menores ou em menor quantidade.',
            ),
          ),
        );

        setState(() {
          _enviando = false;
        });

        return;
      }

      final statusSaude = [
        if (isCastrado) 'Castrado',
        if (isVacinado) 'Vacinado',
      ].join(', ');

      final novoPet = PetModel(
        id: id,
        nome: _nomeController.text.trim(),
        especie: especieSelecionada!,
        statusSaude: statusSaude,
        idade: _idadeController.text.trim(),
        porte: _porteController.text.trim(),
        genero: generoSelecionado,
        raca: _racaController.text.trim(),
        descricao: _descricaoController.text.trim(),
        localizacao:
            '${_cidadeController.text.trim()}, '
            '${_estadoController.text.trim()}',
        fotoBase64: fotoBase64,
        fotosBase64: fotosBase64,
      );

      final sucesso =
          await controller.cadastrarAnimal(novoPet);

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet cadastrado com sucesso!'),
          ),
        );

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
          generoSelecionado = 'Macho';
          _fotoPrincipal = null;

          for (var i = 0; i < _fotosAdicionais.length; i++) {
            _fotosAdicionais[i] = null;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.erro ?? 'Erro ao cadastrar pet',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar as fotos: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
    }
  }

  OutlineInputBorder _estiloBorda() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFE0E0E0),
        width: 1.2,
      ),
    );
  }

  Widget _construirCampo({
    required String label,
    required String dica,
    required TextEditingController controller,
    IconData? icone,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            controller: controller,
            maxLines: maxLines,
            validator: _validarObrigatorio,
            decoration: InputDecoration(
              hintText: dica,
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 14,
              ),
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
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirDropdownEspecie() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
              style: TextStyle(
                color: Colors.black26,
                fontSize: 14,
              ),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.category,
                color: Colors.blue,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: _estiloBorda(),
              focusedBorder: _estiloBorda().copyWith(
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
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

  Widget _construirDropdownGenero() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gênero*',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: generoSelecionado,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.wc,
                color: Colors.blue,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: _estiloBorda(),
              focusedBorder: _estiloBorda().copyWith(
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Macho',
                child: Text('Macho'),
              ),
              DropdownMenuItem(
                value: 'Fêmea',
                child: Text('Fêmea'),
              ),
            ],
            onChanged: (String? novoValor) {
              setState(() {
                generoSelecionado = novoValor ?? 'Macho';
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
            side: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1.5,
            ),
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

  Widget _construirImagem(
    Uint8List bytes, {
    bool principal = false,
  }) {
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF5F5F5),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image_outlined,
                color: Colors.redAccent,
                size: 36,
              ),
              const SizedBox(height: 6),
              Text(
                principal
                    ? 'Erro ao carregar foto'
                    : 'Erro',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirGradeFotos() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fotos do Pet*',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selecionarFotoPrincipal,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 180,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1.2,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _fotoPrincipal != null
                      ? _construirImagem(
                          _fotoPrincipal!,
                          principal: true,
                        )
                      : const Center(
                          child: Icon(
                            Icons.pets,
                            color: Colors.black12,
                            size: 64,
                          ),
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
            children: List.generate(
              4,
              (index) {
                final foto = _fotosAdicionais[index];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < 3 ? 12 : 0,
                    ),
                    child: InkWell(
                      onTap: () =>
                          _selecionarFotoAdicional(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 75,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1.2,
                          ),
                        ),
                        child: foto != null
                            ? _construirImagem(foto)
                            : const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.blue,
                                  size: 22,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salvando =
        context.watch<HomeController>().salvando ||
        _enviando;

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
                  color: Colors.blue,
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
              _construirCampo(
                label: 'Nome do Pet*',
                dica: 'Ex: Bica',
                controller: _nomeController,
                icone: Icons.pets,
              ),
              _construirDropdownEspecie(),
              _construirDropdownGenero(),
              _construirCampo(
                label: 'Raça*',
                dica: 'Ex: Pinscher, SRD, Persa',
                controller: _racaController,
              ),
              Row(
                children: [
                  Expanded(
                    child: _construirCampo(
                      label: 'Idade*',
                      dica: 'Ex: 9 anos',
                      controller: _idadeController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
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
                    child: _construirCampo(
                      label: 'Cidade*',
                      dica: 'Ex: Garanhuns',
                      controller: _cidadeController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
                      label: 'Estado*',
                      dica: 'Ex: Pernambuco',
                      controller: _estadoController,
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
                controller: _descricaoController,
                maxLines: 4,
              ),
              _construirGradeFotos(),
              const SizedBox(height: 12),
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
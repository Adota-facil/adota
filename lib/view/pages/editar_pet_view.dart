import 'dart:convert';
import 'dart:typed_data';
import 'package:adota_facil/controllers/home_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/constants/pet_constantes.dart';
import 'package:adota_facil/view/widgets/dropdown_formulario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:adota_facil/view/widgets/ajuste_foto_widget.dart';
import 'package:adota_facil/view/theme/app_theme.dart';
import 'package:adota_facil/view/widgets/campo_texto_formulario.dart';
import 'package:adota_facil/view/widgets/checkbox_formulario.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';

class EditarPetView extends StatefulWidget {
  final PetModel pet;

  const EditarPetView({super.key, required this.pet});

  @override
  State<EditarPetView> createState() => _EditarPetViewState();
}

class _EditarPetViewState extends State<EditarPetView> {
  static const int _tamanhoMaximoFotos = 600 * 1024;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _fotosSelecionadas = [];
  final List<Uint8List> _fotosBytes = [];

  late bool isCastrado;
  late bool isVacinado;

  String? especieSelecionada;
  late String generoSelecionado;
  String? porteSelecionado;
  String? estadoSelecionado;

  late final TextEditingController _nomeController;
  late final TextEditingController _racaController;
  late final TextEditingController _idadeController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.pet.nome);
    _racaController = TextEditingController(text: widget.pet.raca);
    _idadeController = TextEditingController(text: widget.pet.idade);
    _descricaoController = TextEditingController(text: widget.pet.descricao);

    final localizacaoPartes = widget.pet.localizacao.split(',');
    _cidadeController = TextEditingController(
      text: localizacaoPartes.isNotEmpty ? localizacaoPartes[0].trim() : '',
    );
    if (localizacaoPartes.length > 1) {
      final estadoBruto = localizacaoPartes[1].trim();
      if (PetConstantes.estados.contains(estadoBruto)) {
        estadoSelecionado = estadoBruto;
      }
    }

    especieSelecionada = PetConstantes.especies.contains(widget.pet.especie)
        ? widget.pet.especie
        : null;
    
    generoSelecionado = PetConstantes.generos.contains(widget.pet.genero)
        ? widget.pet.genero
        : 'Macho';

    porteSelecionado = PetConstantes.portes.contains(widget.pet.porte)
        ? widget.pet.porte
        : null;

    isCastrado = widget.pet.statusSaude.toLowerCase().contains('castrado');
    isVacinado = widget.pet.statusSaude.toLowerCase().contains('vacinado');

    if (widget.pet.fotosBase64.isNotEmpty) {
      for (var base64Str in widget.pet.fotosBase64) {
        try {
          final bytes = base64Decode(base64Str);
          _fotosBytes.add(bytes);
          _fotosSelecionadas.add(XFile.fromData(bytes, mimeType: 'image/jpeg'));
        } catch (_) {}
      }
    } else if (widget.pet.fotoBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(widget.pet.fotoBase64);
        _fotosBytes.add(bytes);
        _fotosSelecionadas.add(XFile.fromData(bytes, mimeType: 'image/jpeg'));
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _cidadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarECortarFoto() async {
    if (_fotosSelecionadas.length >= 4) {
      _mostrarErro('Limite de 5 fotos atingido.');
      return;
    }

    final ImageSource? origem = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.corPrimaria),
              title: const Text('Tirar foto com a câmera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.corPrimaria),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (origem == null) return;

    try {
      final XFile? imagemOrigem = await _picker.pickImage(
        source: origem,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 60,
      );

      if (imagemOrigem == null) return;

      final bytes = await imagemOrigem.readAsBytes();

      if (!mounted) return;

      final Uint8List? imagemCortadaBytes = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AjusteFoto(imageBytes: bytes)),
      );

      if (imagemCortadaBytes != null) {
        final xFileCortado = XFile.fromData(
          imagemCortadaBytes,
          name: imagemOrigem.name,
          mimeType: 'image/jpeg',
        );

        setState(() {
          _fotosSelecionadas.add(xFileCortado);
          _fotosBytes.add(imagemCortadaBytes);
        });
      }
    } catch (e) {
      _mostrarErro('Erro ao capturar imagem: $e');
    }
  }

  void _removerFoto(int index) {
    setState(() {
      _fotosSelecionadas.removeAt(index);
      _fotosBytes.removeAt(index);
    });
  }

  List<String?> _validarCamposExtras() {
    List<String?> erros = [];
    if (especieSelecionada == null) erros.add('Selecione a espécie do pet');
    if (porteSelecionado == null) erros.add('Selecione o porte do pet');
    if (estadoSelecionado == null) erros.add('Selecione o estado');
    if (_fotosSelecionadas.isEmpty) {
      erros.add('Adicione pelo menos uma foto do pet');
    }
    return erros;
  }

  Future<List<String>> _converterFotosParaBase64() async {
    List<String> listaBase64 = [];
    for (var bytes in _fotosBytes) {
      listaBase64.add(base64Encode(bytes));
    }
    return listaBase64;
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      _mostrarErro('Preencha todos os campos obrigatórios do formulário.');
      return;
    }

    final errosExtras = _validarCamposExtras();
    if (errosExtras.isNotEmpty) {
      _mostrarErro(errosExtras.first!);
      return;
    }

    final tamanhoFotos = _fotosBytes.fold<int>(
      0,
      (total, bytes) => total + bytes.length,
    );
    if (tamanhoFotos > _tamanhoMaximoFotos) {
      _mostrarErro(
        'As fotos ocupam muito espaço. Remova uma foto ou escolha imagens menores.',
      );
      return;
    }

    final controller = context.read<HomeController>();

    try {
      final fotosEmBase64 = await _converterFotosParaBase64();

      final statusSaudeCalculado = PetModel.montarStatusSaude(
        castrado: isCastrado,
        vacinado: isVacinado,
      );

      final petAtualizado = widget.pet.copyWith(
        nome: _nomeController.text.trim(),
        especie: especieSelecionada!,
        statusSaude: statusSaudeCalculado,
        idade: _idadeController.text.trim(),
        porte: porteSelecionado!,
        genero: generoSelecionado,
        raca: _racaController.text.trim(),
        descricao: _descricaoController.text.trim(),
        localizacao: '${_cidadeController.text.trim()}, $estadoSelecionado',
        fotoBase64: fotosEmBase64.isNotEmpty ? fotosEmBase64.first : '',
        fotosBase64: fotosEmBase64,
      );

      final sucesso = await controller.cadastrarAnimal(petAtualizado);

      if (!mounted) return;

      if (sucesso) {
        _mostrarSucesso('Alterações salvas com sucesso!');
        Navigator.pop(context, true);
      } else {
        _mostrarErro(
          controller.erro ?? 'Erro ao atualizar pet no banco de dados.',
        );
      }
    } catch (e) {
      _mostrarErro('Ocorreu uma falha ao processar as fotos: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.green),
    );
  }

  Widget _construirGradeFotos() {
    final temFotoPrincipal = _fotosBytes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fotos do Pet*', style: AppTheme.rotuloCampo),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 1 / 1,
            child: InkWell(
              onTap: _selecionarECortarFoto,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.corFundoCampo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.corBordaPadrao,
                    width: 1.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (temFotoPrincipal)
                        Image.memory(
                          _fotosBytes[0],
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      if (!temFotoPrincipal)
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: AppTheme.corPrimaria,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Adicionar Foto Principal',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      if (temFotoPrincipal)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removerFoto(0),
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) {
              final fotoIndex = index + 1;
              final temFoto = _fotosBytes.length > fotoIndex;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 3 ? 8.0 : 0.0),
                  child: InkWell(
                    onTap: temFoto ? null : _selecionarECortarFoto,
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.corFundoCampo,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.corBordaPadrao,
                            width: 1.2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (temFoto)
                                Image.memory(
                                  _fotosBytes[fotoIndex],
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              if (!temFoto)
                                const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppTheme.corPrimaria,
                                    size: 20,
                                  ),
                                ),
                              if (temFoto)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => _removerFoto(fotoIndex),
                                    child: const CircleAvatar(
                                      radius: 9,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
    final salvando = context.watch<HomeController>().salvando;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(
        leadingName: 'Editar Pet',
        mostrarBotaoVoltar: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Atualize os dados do pet',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Modifique as informações abaixo e salve as alterações.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _construirGradeFotos(),
                  const SizedBox(height: 18),
                  CampoTextoFormulario(
                    label: 'Nome do Pet*',
                    dica: 'Ex: Bica',
                    controller: _nomeController,
                    icone: Icons.pets,
                  ),
                  const SizedBox(height: 18),
                  DropdownFormulario<String>(
                    label: 'Espécie*',
                    dica: 'Selecione a espécie',
                    icone: Icons.category,
                    itens: PetConstantes.especies,
                    valorSelecionado: especieSelecionada,
                    onChanged: (valor) =>
                        setState(() => especieSelecionada = valor),
                  ),
                  const SizedBox(height: 18),
                  DropdownFormulario<String>(
                    label: 'Gênero*',
                    icone: Icons.wc,
                    itens: PetConstantes.generos,
                    valorSelecionado: generoSelecionado,
                    onChanged: (valor) =>
                        setState(() => generoSelecionado = valor ?? 'Macho'),
                  ),
                  const SizedBox(height: 18),
                  CampoTextoFormulario(
                    label: 'Raça*',
                    dica: 'Ex: Pinscher, SRD, Persa',
                    controller: _racaController,
                  ),
                  const SizedBox(height: 18),
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
                          label: 'Cidade*',
                          dica: 'Ex: Garanhuns',
                          controller: _cidadeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  DropdownFormulario<String>(
                    label: 'Porte*',
                    dica: 'Selecione o porte',
                    icone: Icons.straighten,
                    itens: PetConstantes.portes,
                    valorSelecionado: porteSelecionado,
                    onChanged: (valor) => setState(() => porteSelecionado = valor),
                  ),
                  const SizedBox(height: 18),
                  DropdownFormulario<String>(
                    label: 'Estado*',
                    dica: 'Selecione o estado',
                    icone: Icons.map,
                    itens: PetConstantes.estados,
                    valorSelecionado: estadoSelecionado,
                    onChanged: (valor) => setState(() => estadoSelecionado = valor),
                  ),
                  const SizedBox(height: 18),
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
                    dica: 'Conte um pouco sobre a personalidade e história do pet...',
                    controller: _descricaoController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.corPrimaria,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: salvando ? null : _salvarAlteracoes,
                      child: salvando
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Salvar Alterações',
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
        ),
      ),
    );
  }
}
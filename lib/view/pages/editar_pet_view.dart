import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';

class EditarPetView extends StatefulWidget {
  final PetModel pet;

  const EditarPetView({super.key, required this.pet});

  @override
  State<EditarPetView> createState() => _EditarPetViewState();
}

class _EditarPetViewState extends State<EditarPetView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _porteController;
  late TextEditingController _racaController;
  late TextEditingController _localizacaoController;
  late TextEditingController _descricaoController;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.pet.nome);
    _idadeController = TextEditingController(text: widget.pet.idade);
    _porteController = TextEditingController(text: widget.pet.porte);
    _racaController = TextEditingController(text: widget.pet.raca);
    _localizacaoController = TextEditingController(
      text: widget.pet.localizacao,
    );
    _descricaoController = TextEditingController(text: widget.pet.descricao);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _porteController.dispose();
    _racaController.dispose();
    _localizacaoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      await FirebaseFirestore.instance
          .collection('animais')
          .doc(widget.pet.id)
          .update({
            'nome': _nomeController.text.trim(),
            'idade': _idadeController.text.trim(),
            'porte': _porteController.text.trim(),
            'raca': _racaController.text.trim(),
            'localizacao': _localizacaoController.text.trim(),
            'descricao': _descricaoController.text.trim(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informações atualizadas com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(
        leadingName: 'Editar Pet',
        mostrarBotaoVoltar: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Atualize os dados do pet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pet',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, informe o nome'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _porteController,
                decoration: const InputDecoration(
                  labelText: 'Porte',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localizacaoController,
                decoration: const InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _salvando ? null : _atualizarPet,
                  child: _salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            color: Colors.white,
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
